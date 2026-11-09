# CR-004 — US-0.1 : environnement et création du projet Flutter

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Technique |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | 1.0.0+1 |

## 1. Demande

Disposer d'un projet Flutter initialisé, compilable et ouvrable dans IntelliJ IDEA (US-0.1, epic E0).

## 2. Motivation

Démarrer le développement sur une base saine, conforme à `docs/ARCHITECTURE_TECHNIQUE.md` (CR-002 : Flutter et IntelliJ IDEA).

## 3. Changement proposé

- Projet créé par `flutter create --org com.loantrack --project-name loantrack --platforms android .` (Android uniquement), en conservant `README.md` et `.gitignore`.
- applicationId et namespace `com.loantrack.app`, nom affiché « LoanTrack », `minSdk 26`.
- Dépendances de l'architecture déclarées dans `pubspec.yaml` (Flutter 3.47.9 stable), versions verrouillées par `pubspec.lock`.
- `.editorconfig` et `README.md` (commandes du projet).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucun |
| Écrans | Aucun |
| Base de données | Non |
| Format d'export JSON | Non |
| Backlog | US-0.1 ; vérification sur le S22 reportée à US-6.4 |
| Tests | Aucun (couvert par US-0.2) |

## 5. Critères d'acceptation

- [x] `flutter doctor` : Flutter et Android toolchain OK (Android Studio non requis).
- [x] Projet créé à la racine sans écraser `README.md` ni `.gitignore`.
- [x] applicationId / namespace `com.loantrack.app`, nom « LoanTrack », `minSdk 26`.
- [x] Dépendances ajoutées dans `pubspec.yaml`.
- [x] `flutter run` lance l'application depuis IntelliJ (validé sur émulateur le 2026-11-02).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : `88adaab` (establish technical foundations and initialize the project).
- Remarques : le lancement sur le Samsung Galaxy S22 physique est reporté à US-6.4. Vérifié lors de la livraison V1.0.0 (CR-034, 2026-11-09).
