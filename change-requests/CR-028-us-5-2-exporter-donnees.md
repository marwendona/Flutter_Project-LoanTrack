# CR-028 — US-5.2 : exporter les données

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — |

## 1. Demande

Exporter toutes les données dans un fichier JSON afin de ne rien perdre en cas de changement ou de réinitialisation du téléphone (US-5.2).

## 2. Motivation

La sauvegarde système Android est désactivée (ENF-02, Q-04) : l'export manuel est le seul moyen de conserver les données hors de l'application.

## 3. Changement proposé

- ECR-06 Paramètres : ligne « Exporter les données ».
- Appui → sélecteur de fichier système (SAF, `file_picker`), nom proposé `loantrack-sauvegarde-AAAA-MM-JJ.json` (date du jour via `clock`).
- Contenu (RG-50), format versionné `formatVersion: 1` :
  `{ formatVersion, exportedAt, currency, borrowers[], loans[], repayments[] }`.
  - `exportedAt` : date et heure ISO 8601 (UTC) de l'export.
  - `currency` : code ISO 4217 de la devise.
  - Montants en unités mineures (`int`), dates en `AAAA-MM-JJ`, identifiants conservés (liens prêt → emprunteur, remboursement → prêt).
  - Aucune valeur calculée (reste dû, statut, totaux) n'est exportée.
- Message de succès (snackbar) après enregistrement ; message d'échec en cas d'erreur ; rien si l'utilisateur annule le sélecteur.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `02-regles-metier.md` (RG-50 : détail du format), `03-ecrans-et-parcours.md` (ECR-06 : ligne Exporter) ; `docs/ARCHITECTURE_TECHNIQUE.md` §6 (API `file_picker`) |
| Écrans | ECR-06 |
| Base de données | Non |
| Format d'export JSON | Création du format v1 |
| Backlog | US-5.2 terminée |
| Tests | DTO / sérialisation, `BackupService` (Drift en mémoire), controller d'export (mocktail), widget ECR-06 |

## 5. Critères d'acceptation

- [x] Sélecteur de fichier système (SAF), nom par défaut `loantrack-sauvegarde-AAAA-MM-JJ.json`.
- [x] Contenu conforme à RG-50 ; message de succès / d'échec.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (238 tests, dont 12 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/data/backup/backup_dto.dart` (DTO `freezed` + `json_serializable`, `LocalDayJsonConverter`) et fichiers générés, `lib/data/backup/backup_service.dart` (`createBackup` lu dans une transaction, `encode`, `fileName`), `lib/data/backup/backup_file_saver.dart` (`BackupFileSaver`, `FilePickerBackupFileSaver` via `FilePicker.saveFile`, MIME `application/json`), `lib/data/providers.dart` (`backupServiceProvider`, `backupFileSaverProvider`), `lib/features/settings/export_controller.dart` (`ExportController`, `ExportResult`), `lib/features/settings/settings_screen.dart` (ligne Exporter), `lib/l10n/app_fr.arb` (4 clés `settingsExport*`) et fichiers l10n générés, `specifications/02-regles-metier.md` (RG-50), `specifications/03-ecrans-et-parcours.md` (ECR-06).
  - Tests : `test/data/backup/backup_service_test.dart` (6, Drift en mémoire : contenu JSON exact, base vide, aller-retour DTO, convertisseur de dates), `test/features/settings/export_controller_test.dart` (3, mocktail), `test/features/settings/settings_screen_test.dart` (+3 : succès, annulation, échec ; comptage des lignes du dialogue de devise adapté).
  - Choix : `nameKey` (dérivé du nom, RG-02) n'est pas exporté, il sera recalculé à l'import ; `fromJson` est généré dès maintenant (nécessaire à `toJson` avec freezed) mais l'import reste l'objet d'US-5.3.
  - L'API de `file_picker` 13 est statique (`FilePicker.saveFile`) et non `FilePicker.platform.saveFile` : `docs/ARCHITECTURE_TECHNIQUE.md` §6 corrigé en conséquence.
  - Aucun nouveau paquet (`file_picker`, `json_serializable` déjà présents) ; pas de migration de base.
  - À vérifier sur le S22 (US-6.4) : enregistrement réel via le sélecteur système et rendu en mode sombre (seules des couleurs du thème sont utilisées).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
