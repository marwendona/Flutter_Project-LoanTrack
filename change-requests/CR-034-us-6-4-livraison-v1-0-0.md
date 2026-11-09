# CR-034 — US-6.4 : livraison V1.0.0

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-05 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Implémenter US-6.4 : livrer la V1.0.0 — APK release signé arm64 installé sur le S22, vérifications de l'absence de `INTERNET`, du rendu clair / sombre et Material You, et vérifications manuelles (mode avion, mise à jour sans perte de données, export / import), puis clôture de CR-001 et CR-002.

## 2. Motivation

Dernière story de la V1 : elle regroupe toutes les vérifications sur l'APK release et sur l'appareil physique reportées par les stories précédentes (US-0.1, US-0.3, US-0.6, US-2.2, US-5.x, US-6.1, US-6.2). ENF-01, ENF-02, ENF-11.

## 3. Changement proposé

- `pubspec.yaml` : `version: 1.0.0+1` (déjà en place, aucun changement).
- Contrôle statique : manifeste `main` et manifestes des plugins Android sans permission `INTERNET`.
- Build `flutter build apk --release --target-platform android-arm64`, contrôle des permissions de l'APK (`aapt dump permissions`), installation sur le S22.
- Recette manuelle sur le S22 (liste au §7).
- Aucun changement de code de production prévu.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Non |
| Écrans | Non |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-6.4 ; clôture de CR-001, CR-002 et des réserves « S22 » des CR précédentes |
| Tests | Aucun nouveau test automatique ; recette manuelle sur le S22 |

## 5. Critères d'acceptation

- [x] `version: 1.0.0+1` dans `pubspec.yaml`.
- [x] APK release signé (`--target-platform android-arm64`) installé sur le S22. — ENF-01, ENF-11
- [x] L'APK release ne contient pas la permission `INTERNET`. — ENF-02
- [x] Sur le S22 : rendu clair / sombre et couleurs dynamiques (Material You).
- [x] Vérifications manuelles : mode avion OK, mise à jour d'APK sans perte de données, export / import sur l'appareil.
- [x] CR-001 et CR-002 passées à « Implémentée ».
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert.

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `98e37fa` (Release V1.0.0).
- Clôture (2026-11-09) : recette sur le S22 validée par le propriétaire ; CR-034, CR-001 et CR-002 passées à « Implémentée » en version `1.0.0+1` ; critères reportés de CR-004, CR-006 et CR-009 complétés.
- Remarques (2026-11-05) :
  - `pubspec.yaml` contient déjà `version: 1.0.0+1` : aucun fichier de code modifié.
  - Contrôle statique : le manifeste `main` ne déclare aucune permission (`allowBackup="false"`, `fullBackupContent="false"`, `dataExtractionRules`) ; les manifestes des 8 plugins Android (`file_picker`, `dynamic_color`, `jni`, `jni_flutter`, `package_info_plus`, `path_provider_android`, `shared_preferences_android`, `url_launcher_android`) n'en déclarent aucune. Les bibliothèques Maven transitives ne sont visibles que dans le manifeste fusionné : le contrôle sur l'APK reste nécessaire.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent ; ces fichiers ne sont importés par aucun code de production et n'entrent donc pas dans l'APK. `flutter test` : 321 tests verts.
  - **Bloquant dans l'environnement de l'agent** : pas de SDK Android (`flutter doctor` : « Android SDK not found »), pas d'`adb`, pas de `android/key.properties` ni de keystore. Le build signé, le contrôle de l'APK et la recette sont à faire par le propriétaire sur le poste de développement, selon la procédure ci-dessous.

### Procédure de livraison (à exécuter sur le poste de développement)

1. `flutter pub get` puis `flutter build apk --release --target-platform android-arm64` (keystore et `android/key.properties` présents).
2. Ajouter un fichier dans C:\Users\MSI\Documents\Freelance\LoanTrack\android\key.propertie et le remplir par:
   storePassword=<votre_mot_de_passe>
   keyPassword=<votre_mot_de_passe>
   keyAlias=upload
   storeFile=upload-keystore.jks
3. Vérifier la signature : `C:\Flutter\Android_SDK\build-tools\36.0.0\apksigner.bat verify --print-certs build/app/outputs/flutter-apk/app-release.apk` (certificat du keystore personnel, pas la clé debug).
4. Vérifier les permissions : `C:\Flutter\Android_SDK\build-tools\36.0.0\aapt.exe dump permissions build/app/outputs/flutter-apk/app-release.apk` (ou IntelliJ › *Analyze APK*) → aucune ligne `android.permission.INTERNET`. — ENF-02
5. **Mise à jour sans perte** : avec une version antérieure installée et des données saisies, `flutter install --release` (ou `adb install -r …`) → les données sont conservées. — ENF-11
6. Version affichée dans Paramètres : `1.0.0 (1)`.
7. Mode avion activé : lancement, création / modification / suppression d'emprunteur, prêt et remboursement fonctionnent. — ENF-01
8. Thème : Système / Clair / Sombre, couleurs dynamiques Material You (changer de fond d'écran) ; parcourir tous les écrans et feuilles en sombre.
9. Icône adaptative, icône thématique (Android 13+), écran de démarrage clair (`#00695C`) et sombre (`#00332C`) — réserve CR-031.
10. Accessibilité : TalkBack activé et taille de police au maximum sur tous les écrans — réserve CR-032.
11. Export JSON via le sélecteur système, puis import du fichier exporté → données identiques ; contrôle du dialogue d'import en sombre — réserves CR-028, CR-029.
12. Bouton d'appel d'un emprunteur : ouverture du composeur pré-rempli — réserve CR-017.
13. Une fois tout validé : cocher les critères ci-dessus, passer CR-034, CR-001 et CR-002 à « Implémentée » (version `1.0.0+1`), et compléter les critères reportés de CR-004, CR-006 et CR-009.
