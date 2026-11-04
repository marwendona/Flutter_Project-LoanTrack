# CR-009 — US-0.6 : signature release

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Préparer la signature de l'APK release et la configuration de confidentialité Android (US-0.6, epic E0).

## 2. Motivation

Installer et mettre à jour l'APK sur le S22 sans perte de données, sans exposer les données financières (ENF-01, ENF-02, ENF-11, `docs/ARCHITECTURE_TECHNIQUE.md` §7 et §8).

## 3. Changement proposé

- `android/app/build.gradle.kts` : `signingConfig` release lue depuis `android/key.properties` (ignoré par git). Si le fichier est absent, la compilation debug fonctionne toujours et la release n'est pas signée.
- Manifeste `main` : aucune permission ; `allowBackup="false"`, `fullBackupContent="false"`, `dataExtractionRules` excluant toutes les données.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | Aucun |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-0.6 ; vérifications sur l'APK release reportées à US-6.4 |
| Tests | Aucun test automatisé (vérification manuelle) |

## 5. Critères d'acceptation

- [x] `signingConfig` release lisant `android/key.properties`, build debug fonctionnel sans ce fichier.
- [x] `allowBackup=false` ; aucune permission dans le manifeste `main`.
- [ ] Absence de la permission `INTERNET` dans l'APK release — reporté à US-6.4.
- [ ] APK release arm64 installé sur le S22 — reporté à US-6.4.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30. Report des deux vérifications sur APK à US-6.4 décidé par le propriétaire le 2026-11-02.

## 7. Suivi de l'implémentation

- Commit : `88adaab` ; report des vérifications : `29ead9e`.
