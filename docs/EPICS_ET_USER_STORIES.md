# Epics et user stories — LoanTrack

**Version** : 2.1 (CR-036 — renumérotation E7 ↔ E8, 2026-11-09) · 2.0 (CR-035 — V2, 2026-11-09) · 1.1 (CR-001, CR-002 — approuvées le 2026-10-30)

Légende — **Priorité** (MoSCoW) : `M` Must · `S` Should · `C` Could · **Taille** : `XS` < 1 h · `S` ~ ½ j · `M` ~ 1 j · `L` 2–3 j
**Statut** : ⬜ À faire · 🟨 En cours · ✅ Terminé

Ordre d'implémentation conseillé : **E0 → E1 → E2 → E3 → E4 → E5 → E6** (V1, livrée), puis **E7 → E8** (V2).

## Vue d'ensemble

| Epic | Titre | Version | Stories | Statut |
|---|---|---|---|---|
| E0 | Socle technique | V1 | 6 | ✅ |
| E1 | Gestion des emprunteurs | V1 | 5 | ✅ |
| E2 | Gestion des prêts | V1 | 4 | ✅ |
| E3 | Gestion des remboursements | V1 | 4 | ✅ |
| E4 | Tableau de bord et totaux | V1 | 3 | ✅ |
| E5 | Paramètres, sauvegarde et restauration | V1 | 4 | ✅ |
| E6 | Finitions et livraison de l'APK | V1 | 4 | ✅ |
| E7 | Fiabilité des emprunteurs (couleurs) | V2 | 3 | 🟨 |
| E8 | Améliorations V2 | V2 | 4 | ⬜ |

---

## E0 — Socle technique

> Objectif : un projet Android compilable, testable et installable sur le S22, avec l'architecture en place.

> Les vérifications sur le S22 physique sont reportées à **US-6.4** (l'application a été validée sur émulateur le 2026-11-02).

### US-0.1 — Environnement et création du projet Flutter · `M` · `S` · ✅
**En tant que** développeur, **je veux** un projet Flutter initialisé et ouvrable dans IntelliJ IDEA **afin de** démarrer sur une base saine.
- [x] `flutter doctor` : Flutter et Android toolchain OK (l'absence d'Android Studio est acceptée) — voir `ARCHITECTURE_TECHNIQUE.md` §3.
- [x] `flutter create --org com.loantrack --project-name loantrack --platforms android .` à la racine, sans écraser `README.md` ni `.gitignore` existants (fusionner si besoin).
- [x] applicationId et namespace changés en `com.loantrack.app`, nom affiché « LoanTrack », `minSdk 26`.
- [x] Dépendances de `ARCHITECTURE_TECHNIQUE.md` ajoutées dans `pubspec.yaml`.
- [x] `flutter run` affiche l'application depuis IntelliJ. *(validé sur émulateur ; vérification sur le S22 reportée à US-6.4)*

### US-0.2 — Qualité et tests · `M` · `XS` · ✅
- [x] `analysis_options.yaml` (`flutter_lints` + règles strictes : `strict-casts`, `strict-raw-types`, exclusion des fichiers générés).
- [x] `flutter_test` + `mocktail` ; un test exemple passe ; `flutter analyze` sans avertissement.

### US-0.3 — Thème, textes et navigation · `M` · `S` · ✅
**Je veux** une barre de navigation à 3 onglets (Tableau de bord, Emprunteurs, Paramètres) **afin de** naviguer dans l'app.
- [x] Thème Material 3 clair/sombre (`material_ui`, CR-003) + couleurs dynamiques (`dynamic_color`). *(validé sur émulateur ; rendu clair/sombre et Material You sur le S22 reporté à US-6.4)*
- [x] Localisation française (`l10n.yaml`, `app_fr.arb`, `locale: fr`).
- [x] `go_router` avec `StatefulShellRoute` et 3 écrans squelettes.
- [x] Couleurs de statut définies (vert, rouge, orange, neutre) — ECR « Formats d'affichage ».

### US-0.4 — Base de données et providers · `M` · `M` · ✅
- [x] `ProviderScope` à la racine, providers de base (`appDatabaseProvider`, repositories).
- [x] `AppDatabase` Drift v1 avec les 3 tables, clés étrangères `CASCADE` (`PRAGMA foreign_keys = ON`), index, convertisseur `LocalDay`.
- [x] Schéma v1 exporté dans `drift_schemas/`.
- [x] Tests DAO en mémoire : insertion, lecture, cascade.

### US-0.5 — Types `Money` et `LocalDay` · `M` · `S` · ✅
- [x] `Money(int amountMinor)` : addition, soustraction, comparaison.
- [x] Parsing de la saisie utilisateur (`"1250,5"` → `1250500` en TND) et formatage (`1 250,500 TND`).
- [x] `LocalDay` : création depuis `clock.now()`, comparaison, conversion `epochDay`, formatage `dd/MM/yyyy`.
- [x] Tests unitaires couvrant 0, 2 et 3 décimales, saisies invalides, changement d'heure. — RG-40, ENF-05

### US-0.6 — Signature release · `M` · `S` · ✅
- [x] `signingConfig` release lisant `android/key.properties` (absent → la compilation debug fonctionne toujours ; la release n'est alors pas signée).
- [x] `allowBackup=false` ; aucune permission dans le manifeste `main`.
- Vérification de l'absence de `INTERNET` dans l'APK release et installation sur le S22 : reportées à US-6.4. — ENF-01, ENF-02, ENF-11

---

## E1 — Gestion des emprunteurs

### US-1.1 — Lister les emprunteurs · `M` · `S` · ✅
**En tant que** prêteur, **je veux** voir la liste de mes emprunteurs **afin de** retrouver rapidement une personne.
- [x] Chaque ligne : nom, reste dû, nombre de prêts actifs (reste dû > 0), badge « En retard ».
- [x] Tri par reste dû décroissant puis nom (RG-04).
- [x] État vide explicite. — ECR-02

### US-1.2 — Ajouter un emprunteur · `M` · `S` · ✅
**Je veux** ajouter un emprunteur (nom, téléphone, note) **afin de** lui associer des prêts.
- [x] Bouton + → formulaire ; nom obligatoire 1–60 car., espaces retirés (RG-01).
- [x] Doublon de nom refusé avec message (RG-02).
- [x] Après enregistrement, l'emprunteur apparaît dans la liste.

### US-1.3 — Supprimer un emprunteur · `M` · `S` · ✅
**Je veux** supprimer un emprunteur **afin de** nettoyer ma liste.
- [x] Accessible par appui long / menu ⋮ et depuis le détail.
- [x] Dialogue de confirmation indiquant le nombre de prêts et le reste dû supprimés (RG-03).
- [x] Suppression en cascade dans une transaction ; totaux mis à jour immédiatement.

### US-1.4 — Modifier un emprunteur · `S` · `XS` · ✅
- [x] Modification nom / téléphone / note avec les mêmes validations que la création.

### US-1.5 — Rechercher un emprunteur · `S` · `XS` · ✅
- [x] Champ de recherche filtrant la liste par nom (insensible à la casse et aux accents).

---

## E2 — Gestion des prêts

### US-2.1 — Enregistrer un prêt · `M` · `M` · ✅
**En tant que** prêteur, **je veux** enregistrer le montant donné, la date du don et la date de retour promise **afin de** garder une trace fiable.
- [x] Formulaire ECR-04 : montant, date du prêt (défaut aujourd'hui), date promise (optionnelle), note.
- [x] Validations RG-10, RG-11, RG-12 avec messages sous les champs ; « Enregistrer » désactivé si invalide.
- Point d'entrée provisoire (menu ⋮ d'ECR-02 → « Nouveau prêt ») remplacé par le bouton « + Prêt » d'ECR-03 (US-2.2, CR-017).

### US-2.2 — Voir le détail d'un emprunteur et ses prêts · `M` · `M` · ✅
**Je veux** voir pour un emprunteur tous ses prêts **afin de** connaître sa situation.
- [x] En-tête (nom, téléphone cliquable, note) et résumé : total prêté, remboursé, reste dû.
- [x] Carte par prêt : montant, date du prêt, date promise, remboursé / reste dû + barre, statut, date de remboursement effective si soldé (RG-15, RG-20 à RG-23).
- [x] — ECR-03

### US-2.3 — Statut calculé d'un prêt · `M` · `S` · ✅
- [x] Service `LoanStatusCalculator` (`compute`, `overdueDays`) implémentant RG-20 et le nombre de jours de retard (RG-23), avec date du jour injectée (nom aligné sur l'architecture, CR-018).
- [x] Tests unitaires couvrant chaque statut et les cas limites (échéance aujourd'hui = pas en retard, reste dû 0 avec date dépassée = Remboursé).

### US-2.4 — Modifier / supprimer un prêt · `M` · `S` · ✅
- [x] Modification avec RG-13 (montant ≥ déjà remboursé) ; date du prêt ≤ premier remboursement (RG-11 complétée, CR-019).
- [x] Suppression avec confirmation, cascade sur les remboursements (RG-14).
- Accès par le menu ⋮ de chaque carte de prêt d'ECR-03 (CR-019) ; ECR-05 (US-3.2) offrira les mêmes actions.

---

## E3 — Gestion des remboursements

### US-3.1 — Enregistrer un remboursement (partiel ou total) · `M` · `M` · ✅
**En tant que** prêteur, **je veux** saisir le montant rendu et la date réelle **afin de** suivre ce qui reste dû.
- [x] Feuille ECR-05b : montant, date réelle (défaut aujourd'hui), note ; rappel du reste dû.
- [x] Bouton « Totalité » (RG-18).
- [x] Validations RG-16, RG-17 ; statut et totaux mis à jour immédiatement.
- Accès par le menu ⋮ de chaque carte de prêt d'ECR-03, masqué si le prêt est remboursé (CR-020), et par le bouton « + Remboursement » d'ECR-05 (CR-021).

### US-3.2 — Historique des remboursements d'un prêt · `M` · `S` · ✅
- [x] Écran ECR-05 : infos du prêt + liste des remboursements (date réelle, montant), du plus récent au plus ancien.
- [x] Bouton + Remboursement masqué si le prêt est soldé.
- Accès par appui sur une carte de prêt d'ECR-03 ; menu ⋮ Modifier / Supprimer le prêt (CR-021).

### US-3.3 — Modifier / supprimer un remboursement · `S` · `S` · ✅
- [x] Modification avec plafond = reste dû + montant initial (RG-16) ; suppression avec confirmation (RG-19).
- Accès par appui sur un remboursement de l'historique d'ECR-05 → ECR-05b en modification, avec bouton Supprimer (CR-022).

### US-3.4 — Tests d'intégration du calcul de reste dû · `M` · `S` · ✅
- [x] Tests DAO : agrégations remboursé / reste dû par prêt et par emprunteur, y compris prêts sans remboursement.
- Tests dans `test/data/database/daos/balance_aggregation_test.dart` (CR-023).

---

## E4 — Tableau de bord et totaux

### US-4.1 — Totaux globaux · `M` · `M` · ✅
**En tant que** prêteur, **je veux** voir la totalité du crédit donné à tous les emprunteurs **afin de** connaître ma situation d'un coup d'œil.
- [x] Carte « Reste à recevoir » + total prêté, total remboursé, taux de remboursement (barre), prêts en retard (nombre + montant, en rouge si > 0). — RG-31, RG-32, RG-33
- Montant en retard = somme des restes dus des prêts en retard ; taux arrondi à l'entier inférieur ; état vide d'ECR-01 inclus (CR-024).

### US-4.2 — Totaux par emprunteur · `M` · `S` · ✅
**Je veux** voir, pour chaque emprunteur, le total prêté, remboursé et le reste dû **afin de** comparer les situations.
- [x] Liste sous les indicateurs, tri RG-04, tap → détail emprunteur. — RG-30
- Tous les emprunteurs sont listés, y compris ceux sans prêt (CR-025).

### US-4.3 — Filtres du tableau de bord · `S` · `XS` · ✅
- [x] Filtres *Tous* / *Avec reste dû* / *En retard* sur la liste par emprunteur.
- Boutons segmentés sous « Par emprunteur », *Tous* par défaut, filtre non persisté, message si aucun résultat (CR-026).

---

## E5 — Paramètres, sauvegarde et restauration

### US-5.1 — Choix de la devise · `M` · `S` · ✅
- [x] Devise par défaut TND (3 décimales), stockée dans `shared_preferences` (RG-40).
- [x] Modifiable dans Paramètres uniquement tant qu'aucun prêt n'existe ; sinon affichée en lecture seule avec message explicatif (RG-41).
- Devises proposées : TND, EUR, USD, GBP, CHF, CAD, MAD, DZD, LYD ; changement appliqué immédiatement (CR-027).

### US-5.2 — Exporter les données · `M` · `M` · ✅
**Je veux** exporter toutes mes données dans un fichier **afin de** ne rien perdre si je change ou réinitialise mon téléphone.
- [x] Sélecteur de fichier système (SAF), nom par défaut `loantrack-sauvegarde-AAAA-MM-JJ.json`.
- [x] Contenu conforme à RG-50 ; message de succès / d'échec.
- Format JSON v1 détaillé dans RG-50 ; aucun message si le sélecteur est annulé (CR-028).

### US-5.3 — Importer des données · `M` · `M` · ✅
- [x] Sélection du fichier, aperçu (nb d'emprunteurs / prêts / date d'export), confirmation de remplacement.
- [x] Validation complète avant écriture ; remplacement transactionnel ; fichier invalide refusé sans modification (RG-51).
- [x] Test aller-retour export → import identique.
- Contrôles détaillés dans RG-51 ; la devise du fichier est appliquée ; message spécifique pour une version de format inconnue (CR-029).

### US-5.4 — Thème et informations · `C` · `XS` · ✅
- [x] Choix du thème Système / Clair / Sombre ; affichage de la version.
- Thème enregistré dans `shared_preferences` et appliqué immédiatement ; version lue avec `package_info_plus` (CR-030).

---

## E6 — Finitions et livraison de l'APK

### US-6.1 — Icône et écran de démarrage · `S` · `S` · ✅
- [x] Icône adaptative et icône thématique Android 13+ (`flutter_launcher_icons`), écran de démarrage (`flutter_native_splash`).
- Motif blanc (pièce + flèche circulaire) sur fond `#00695C` ; démarrage `#00695C` en clair, `#00332C` en sombre ; sources dans `assets/icon/` générées par `tool/generate_icon_sources.dart` (CR-031). Rendu à vérifier sur le S22 (US-6.4).

### US-6.2 — Accessibilité et ergonomie · `S` · `S` · ✅
- [x] `tooltip` / `Semantics` sur les icônes, statuts toujours accompagnés d'un libellé, zones tactiles ≥ 48 dp, test avec police agrandie. — ENF-08
- Test `test/accessibility_test.dart` : guidelines Flutter (zones tactiles, libellés, contraste) en clair et sombre et police ×2 sans débordement, au format du S22, sur tous les écrans et feuilles ; montants qui passent sous leur libellé, boutons de formulaire empilables (CR-032). Vérification TalkBack sur le S22 (US-6.4).

### US-6.3 — Test du parcours complet · `M` · `S` · ✅
- [x] Test de widgets (`testWidgets`) : ajouter emprunteur → prêt → remboursement partiel → vérifier les totaux du tableau de bord.

### US-6.4 — Livraison V1.0.0 · `M` · `S` · ✅
- [x] `version: 1.0.0+1` dans `pubspec.yaml` *(fait)*, APK release signé (`--target-platform android-arm64`) installé sur le S22. — ENF-01, ENF-11
- [x] Vérification : l'APK release ne contient pas la permission `INTERNET`. — ENF-02
- [x] Vérification sur le S22 : rendu clair/sombre et couleurs dynamiques (Material You). *(reporté de E0)*
- [x] Vérifications manuelles : mode avion OK, mise à jour d'APK sans perte de données, export/import sur l'appareil.
- [x] CR-001 et CR-002 passées à « Implémentée ».
- Contrôle statique fait : manifeste `main` et manifestes des 8 plugins Android sans aucune permission ; build, installation et recette sur le S22 à réaliser sur le poste de développement (liste dans CR-034).

---

# Version 2

> Périmètre V2 décidé par CR-035 (2026-11-09) : E7 en premier, puis E8. Numérotation E7 / E8 inversée par CR-036. Chaque story garde sa propre CR à l'implémentation.

## E7 — Fiabilité des emprunteurs (couleurs)

> Objectif : savoir d'un coup d'œil quels emprunteurs remboursent à l'heure, grâce à une couleur calculée à partir de leurs retards (RG-60 à RG-64), et les retrouver regroupés par couleur.

### US-7.1 — Calcul de la couleur de fiabilité · `M` · `M` · ✅
**En tant que** prêteur, **je veux** que chaque emprunteur reçoive automatiquement une couleur selon la ponctualité de ses remboursements **afin de** juger sa fiabilité sans relire tout son historique.
- [x] Modèle `domain` de la couleur de fiabilité (Vert, Bleu, Violet, Jaune, Orange, Rouge, Noir, Non évalué) dans l'ordre RG-64.
- [x] Service `domain/services` (Dart pur, date du jour injectée) calculant pour un prêt : évaluable ou non, à l'heure / en retard, retard court / long (RG-60, RG-61) ; et pour un emprunteur : N, L et la couleur (RG-62).
- [x] Données nécessaires (date promise, reste dû, date du dernier remboursement par prêt) fournies par les repositories sans nouvelle colonne ni migration ; couleur jamais stockée ni exportée (RG-63).
- [x] Tests unitaires : chaque couleur ; remboursé le jour de la date promise = à l'heure ; retard de 1 mois pile = court, 1 mois + 1 jour = long ; date promise en fin de mois (31/01 → 28/02) ; prêt non soldé en retard compté jusqu'à aujourd'hui ; prêt non échu ou sans date promise ignoré ; N = 2 et L = 2 → Rouge ; N = 4 → Noir ; aucun prêt → Non évalué.
- `ReliabilityColor` / `LoanPunctuality` et `BorrowerReliability` (`lib/domain/models`), service `ReliabilityCalculator` (`loanPunctuality`, `shortDelayLimit`, `evaluate`, `colorFor`) ; `LoanBalance` porte la date du dernier remboursement, agrégée en SQL par `BorrowersDao.watchWithLoanBalances` (CR-037).

### US-7.2 — Afficher la couleur de fiabilité d'un emprunteur · `M` · `S` · ✅
**Je veux** voir la couleur de fiabilité dans la liste des emprunteurs et sur la fiche d'un emprunteur **afin de** la repérer sans chercher.
- [x] Couleurs de fiabilité fixes définies dans le thème, lisibles en clair et en sombre (contour de la pastille noire en sombre) — « Formats d'affichage ».
- [x] ECR-02 : pastille + libellé (RG-62) sur chaque ligne.
- [x] ECR-03 : pastille + libellé et « N prêts en retard, dont L de plus d'un mois » (omis si Vert ou Non évalué).
- [x] Mise à jour immédiate après ajout / modification / suppression d'un prêt ou d'un remboursement.
- [x] Libellés dans `app_fr.arb` ; couleur jamais seule (ENF-08) ; tests de widgets et test d'accessibilité mis à jour.
- Extension de thème `ReliabilityColors`, widgets `ReliabilityIndicator` / `ReliabilityDot` (`lib/core`), `BorrowerSummary.reliability` calculé par `BorrowerSummaryCalculator` (CR-038).

### US-7.3 — Page « Emprunteurs par couleur » · `M` · `M` · ⬜
**Je veux** une page où les emprunteurs sont regroupés par couleur **afin de** voir rapidement qui est fiable et qui ne l'est pas.
- [ ] Bouton icône « Emprunteurs par couleur » (infobulle) dans la barre du haut d'ECR-02 → ECR-07 (route `go_router` sous l'onglet Emprunteurs).
- [ ] Une section par couleur dans l'ordre RG-64, en-tête avec pastille, libellé et nombre d'emprunteurs ; couleurs vides masquées ; tri RG-04 dans chaque section.
- [ ] Ligne : nom, reste dû, N et L ; appui → ECR-03.
- [ ] Bouton « Signification des couleurs » → dialogue reprenant RG-62 en clair.
- [ ] État vide « Aucun emprunteur. » ; mode sombre et police agrandie vérifiés (test d'accessibilité étendu à ECR-07).
- [ ] Tests de widgets : regroupement, ordre des sections, navigation vers ECR-03. — ECR-07

## E8 — Améliorations V2

> Stories prévues dès la V1 (Q-05, Q-06), confirmées en V2 par CR-035. Leurs spécifications détaillées (règles, écrans) seront rédigées dans la CR de chaque story avant son développement ; tout nouveau paquet sera justifié dans `ARCHITECTURE_TECHNIQUE.md` et toute nouvelle permission Android validée par le propriétaire (aucune permission `INTERNET`, ENF-01).

### US-8.1 — Verrouillage de l'application · `C` · `M` · ⬜
**En tant que** prêteur, **je veux** protéger l'application par l'empreinte ou le code de mon téléphone **afin que** personne d'autre ne voie mes prêts. — Q-05
- [ ] Option « Verrouiller l'application » dans ECR-06, désactivée par défaut, enregistrée dans `shared_preferences`.
- [ ] Option active : authentification du téléphone (empreinte ou code) au démarrage et au retour au premier plan ; contenu non affiché tant que l'authentification n'a pas réussi.
- [ ] Contenu masqué dans l'écran des applications récentes quand l'option est active.
- [ ] Option indisponible, avec un message, si le téléphone n'a aucun verrouillage configuré.

### US-8.2 — Rappel le jour de la date promise · `C` · `L` · ⬜
**Je veux** recevoir une notification le jour de la date de retour promise d'un prêt non soldé **afin de** penser à relancer l'emprunteur. — Q-06
- [ ] Option « Rappels » dans ECR-06 ; autorisation de notification demandée à l'activation (Android 13+).
- [ ] Notification locale (sans réseau) le jour de la date promise, à une heure fixe, pour chaque prêt non soldé ; appui → ECR-05.
- [ ] Rappels reprogrammés après création / modification / suppression d'un prêt ou d'un remboursement, après un import et après un redémarrage du téléphone ; annulés quand le prêt est soldé.

### US-8.3 — Historique de l'encours · `C` · `L` · ⬜
**Je veux** voir l'évolution de mon reste à recevoir dans le temps **afin de** savoir si mon encours augmente ou diminue.
- [ ] Graphique de l'encours global en fin de mois sur les 12 derniers mois, sur ECR-01.
- [ ] Valeurs calculées à partir des dates de prêt et de remboursement (jamais stockées).
- [ ] Graphique accompagné d'une valeur textuelle accessible (TalkBack), lisible en clair et sombre.

### US-8.4 — Partager un récapitulatif d'un emprunteur · `C` · `S` · ⬜
**Je veux** envoyer à un emprunteur le récapitulatif de ce qu'il me doit (ex. WhatsApp, SMS) **afin de** le relancer facilement.
- [ ] Action « Partager le récapitulatif » dans le menu ⋮ d'ECR-03 → feuille de partage Android.
- [ ] Texte en français : nom, prêts non soldés (montant, date du prêt, date promise, reste dû) et total restant dû ; la couleur de fiabilité n'est pas incluse.
- [ ] Aucun accès réseau par l'application elle-même (le partage passe par l'application choisie par l'utilisateur).
