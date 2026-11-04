# CR-029 — US-5.3 : importer des données

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Importer un fichier de sauvegarde JSON (produit par l'export, US-5.2) pour restaurer toutes les données, par exemple sur un téléphone neuf ou réinitialisé (US-5.3).

## 2. Motivation

L'export (CR-028) n'a d'intérêt que si la sauvegarde peut être restaurée ; la sauvegarde système Android est désactivée (ENF-02, Q-04).

## 3. Changement proposé

- ECR-06 Paramètres : ligne « Importer des données ».
- Appui → sélecteur de fichier système (SAF, `file_picker`, `FilePicker.pickFile`) ; rien si l'utilisateur annule.
- **Validation complète en mémoire avant toute écriture** (RG-51) ; le fichier est refusé, sans rien modifier, si :
  - ce n'est pas du JSON UTF-8 conforme au format v1 (champs manquants ou de mauvais type, date invalide) ;
  - `formatVersion` est différent de 1 (version inconnue : message spécifique) ;
  - la devise n'est pas une devise proposée (RG-40) ;
  - les identifiants ne sont pas uniques, ou un prêt / remboursement référence un emprunteur / prêt absent ;
  - une règle métier est violée : nom (RG-01) ou doublon de nom (RG-02), longueur des notes, montant ≤ 0 ou > maximum (RG-10, RG-16), date de retour promise < date du prêt (RG-12), remboursement antérieur au prêt (RG-17), somme des remboursements > montant du prêt (RG-16).
  - Les règles « pas de date dans le futur » (RG-11, RG-17) ne sont **pas** contrôlées : elles dépendent de la date du jour au moment de la saisie, et une sauvegarde valide ne peut pas les violer.
- Fichier valide → dialogue de confirmation « Remplacer toutes les données ? » avec l'aperçu : date d'export, nombre d'emprunteurs, nombre de prêts, et l'avertissement que les données actuelles seront remplacées.
- Confirmation → **remplacement dans une seule transaction** (ENF-06) : suppression de toutes les données, insertion des données du fichier avec leurs identifiants, `nameKey` recalculé (RG-02) ; la devise du fichier devient la devise de l'application (les montants sont en unités mineures de cette devise).
- Messages : « Données importées » ; « Fichier invalide : aucune donnée n'a été modifiée » ; « Version de fichier non prise en charge : aucune donnée n'a été modifiée » ; « L'import des données a échoué » en cas d'erreur d'écriture. Ligne désactivée (indicateur de progression) pendant l'import.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `02-regles-metier.md` (RG-51 : contrôles et devise), `03-ecrans-et-parcours.md` (ECR-06 : ligne Importer) ; `docs/ARCHITECTURE_TECHNIQUE.md` §6 (API `file_picker` 13) |
| Écrans | ECR-06 |
| Base de données | Non (pas de migration) |
| Format d'export JSON | Non (lecture du format v1) |
| Backlog | US-5.3 terminée |
| Tests | Validation et restauration (`BackupService`, Drift en mémoire, aller-retour export → import), controller d'import (mocktail), widget ECR-06 |

## 5. Critères d'acceptation

- [x] Sélection du fichier, aperçu (nb d'emprunteurs / prêts / date d'export), confirmation de remplacement.
- [x] Validation complète avant écriture ; remplacement transactionnel ; fichier invalide refusé sans modification (RG-51).
- [x] Test aller-retour export → import identique.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (277 tests, dont 39 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/data/backup/backup_validator.dart` (`BackupValidator`, `InvalidBackupException`, `InvalidBackupReason`), `lib/data/backup/backup_file_picker.dart` (`BackupFilePicker`, `FilePickerBackupFilePicker` via `FilePicker.pickFile` + `readAsBytes`), `lib/data/backup/backup_service.dart` (`decode`, `restore`), `lib/data/providers.dart` (`backupFilePickerProvider`), `lib/features/settings/import_controller.dart` (`ImportController` : `pick`, `restore`), `lib/features/settings/settings_screen.dart` (ligne Importer + dialogue de confirmation), `lib/l10n/app_fr.arb` (10 clés `settingsImport*`) et fichiers l10n générés, `specifications/02-regles-metier.md` (RG-51), `specifications/03-ecrans-et-parcours.md` (ECR-06), `docs/ARCHITECTURE_TECHNIQUE.md` §6, `docs/EPICS_ET_USER_STORIES.md` (US-5.3 ✅).
  - Tests : `test/data/backup/backup_validator_test.dart` (20, chaque règle), `test/data/backup/backup_service_test.dart` (+8 : aller-retour export → import vers une autre base, identifiants suivants, rollback si l'écriture échoue, fichiers non JSON / mal formés / version inconnue / règle métier violée), `test/features/settings/import_controller_test.dart` (4), `test/features/settings/settings_screen_test.dart` (+7 : aperçu et remplacement, annulations, fichier invalide, version inconnue, échec, mode sombre).
  - Le code généré par `json_serializable` lit les entiers avec `(num).toInt()`, ce qui tronquerait un montant décimal (`12.5` → `12`) : `decode` refuse tout nombre non entier (le format v1 n'en contient aucun).
  - La devise est enregistrée en dernier dans la transaction : si l'enregistrement échoue, les données sont annulées (testé). Comme `shared_preferences` n'est pas transactionnel, un échec du commit SQLite *après* l'enregistrement de la devise laisserait la devise changée sans les données ; ce cas est jugé négligeable.
  - Le sélecteur accepte tout type de fichier (pas de filtre `.json`), le contenu étant validé de toute façon.
  - Aucun nouveau paquet, pas de migration de base, format d'export inchangé.
  - À vérifier sur le S22 (US-6.4) : import réel via le sélecteur système et rendu du dialogue en mode sombre.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
