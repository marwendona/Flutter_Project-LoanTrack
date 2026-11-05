# Epics et user stories — LoanTrack

**Version** : 1.1 (CR-001, CR-002 — approuvées le 2026-10-30)

Légende — **Priorité** (MoSCoW) : `M` Must · `S` Should · `C` Could · **Taille** : `XS` < 1 h · `S` ~ ½ j · `M` ~ 1 j · `L` 2–3 j
**Statut** : ⬜ À faire · 🟨 En cours · ✅ Terminé

Ordre d'implémentation conseillé : **E0 → E1 → E2 → E3 → E4 → E5 → E6** (V1), puis E7 (V2).

## Vue d'ensemble

| Epic | Titre | Version | Stories | Statut |
|---|---|---|---|---|
| E0 | Socle technique | V1 | 6 | ✅ |
| E1 | Gestion des emprunteurs | V1 | 5 | ✅ |
| E2 | Gestion des prêts | V1 | 4 | ✅ |
| E3 | Gestion des remboursements | V1 | 4 | ✅ |
| E4 | Tableau de bord et totaux | V1 | 3 | ✅ |
| E5 | Paramètres, sauvegarde et restauration | V1 | 4 | ✅ |
| E6 | Finitions et livraison de l'APK | V1 | 4 | ⬜ |
| E7 | Améliorations V2 | V2 | 4 | ⬜ |

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

### US-6.4 — Livraison V1.0.0 · `M` · `S` · ⬜
- [ ] `version: 1.0.0+1` dans `pubspec.yaml`, APK release signé (`--target-platform android-arm64`) installé sur le S22. — ENF-01, ENF-11
- [ ] Vérification : l'APK release ne contient pas la permission `INTERNET`. — ENF-02
- [ ] Vérification sur le S22 : rendu clair/sombre et couleurs dynamiques (Material You). *(reporté de E0)*
- [ ] Vérifications manuelles : mode avion OK, mise à jour d'APK sans perte de données, export/import sur l'appareil.
- [ ] CR-001 et CR-002 passées à « Implémentée ».

---

## E7 — Améliorations V2 (hors périmètre V1, à confirmer)

| Story | Description | Priorité |
|---|---|---|
| US-7.1 | Verrouillage de l'app par empreinte / code du téléphone + masquage dans les applis récentes (Q-05) | C |
| US-7.2 | Notification de rappel le jour de la date promise (Q-06) | C |
| US-7.3 | Historique / graphique de l'encours dans le temps | C |
| US-7.4 | Partager un récapitulatif texte d'un emprunteur (ex. via WhatsApp / SMS) | C |
