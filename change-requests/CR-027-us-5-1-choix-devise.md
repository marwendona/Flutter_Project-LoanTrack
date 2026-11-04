# CR-027 — US-5.1 : choix de la devise

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-04 |
| **Date de décision** | 2026-10-30 (backlog validé avec CR-001 et CR-002) |
| **Version livrée** | — (non livrée, prévue en 1.0.0) |

## 1. Demande

Permettre de choisir la devise de l'application dans les Paramètres (US-5.1).

## 2. Motivation

La devise est aujourd'hui figée à TND dans le code (`currencyProvider`). RG-40 et RG-41 prévoient un réglage persistant, modifiable tant qu'aucun prêt n'a été saisi.

## 3. Changement proposé

- La devise est stockée dans `shared_preferences` (code ISO 4217) ; **TND par défaut** (3 décimales) si rien n'est enregistré ou si le code stocké est inconnu (RG-40).
- Liste des devises proposées (code ISO 4217, décimales) : TND (3), EUR (2), USD (2), GBP (2), CHF (2), CAD (2), MAD (2), DZD (2), LYD (3).
- ECR-06 Paramètres : ligne « Devise » affichant le code et le nom de la devise.
  - Aucun prêt : appui → dialogue de choix de la devise ; le choix est enregistré et appliqué immédiatement à tous les montants affichés.
  - Au moins un prêt : ligne en lecture seule (icône cadenas) avec le message « La devise ne peut plus être modifiée une fois des prêts enregistrés » (RG-41).
- Le verrouillage est aussi contrôlé côté logique (le controller refuse le changement si un prêt existe), pas seulement dans l'interface.

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | `03-ecrans-et-parcours.md` (ECR-06) : précision du comportement de la ligne Devise et de la liste des devises |
| Écrans | ECR-06 |
| Base de données | Non (nouvelle requête de comptage des prêts, pas de migration) |
| Format d'export JSON | Non (la devise y figurera avec US-5.2) |
| Backlog | US-5.1 terminée |
| Tests | Catalogue des devises, `SettingsStore`, DAO (`hasAny`), controller de devise, tests de widgets d'ECR-06 |

## 5. Critères d'acceptation

- [x] Devise par défaut TND (3 décimales), stockée dans `shared_preferences` (RG-40).
- [x] Modifiable dans Paramètres uniquement tant qu'aucun prêt n'existe ; sinon affichée en lecture seule avec le message explicatif (RG-41).
- [x] Le changement de devise est appliqué immédiatement aux montants affichés.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (226 tests, dont 16 nouveaux).

## 6. Décision

Approuvée dans le cadre du backlog V1 (CR-001, CR-002) le 2026-10-30.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-04) :
  - Fichiers : `lib/core/money/currency.dart` (catalogue `Currency.supported`, `fromCode`), `lib/data/settings/settings_store.dart` (`SettingsStore`, `SharedPreferencesSettingsStore`, `InMemorySettingsStore`), `lib/data/providers.dart` (`settingsStoreProvider`, `currencyProvider` lu depuis les paramètres), `lib/main.dart` (chargement de `SharedPreferences` au démarrage), `LoanRepository` / `LoansDao` (`hasAny`, `watchHasAny` — requête `COUNT`, pas de migration), `lib/features/settings/currency_controller.dart` (`CurrencyController`, `currencyLockedProvider`, `CurrencyLockedException`), `lib/features/settings/settings_screen.dart` (ligne Devise + dialogue), `lib/l10n/app_fr.arb` (6 clés `settingsCurrency*` / `currencyName`) et fichiers l10n générés, `specifications/03-ecrans-et-parcours.md` (ECR-06).
  - Tests : `test/core/money/currency_test.dart` (4), `test/data/settings/settings_store_test.dart` (4), `test/features/settings/currency_controller_test.dart` (4, base Drift en mémoire), `test/features/settings/settings_screen_test.dart` (4) ; `test/app_test.dart` adapté (override de `currencyLockedProvider`, l'onglet Paramètres interrogeant désormais la base).
  - Choix : la liste des devises proposées n'était pas précisée par la spec ; 9 devises retenues (TND par défaut + devises courantes et du Maghreb), extensible dans `Currency.supported`. Un code stocké inconnu revient à TND.
  - `settingsStoreProvider` est en mémoire par défaut (pour ne pas imposer `shared_preferences` aux tests existants) ; `main.dart` le surcharge avec le stockage persistant.
  - Tant que l'existence de prêts n'est pas connue (chargement), la devise est affichée verrouillée par prudence.
  - Pas de `build_runner` nécessaire : aucune table ni modèle `freezed` modifié (méthodes DAO seulement).
  - Mode sombre : uniquement des couleurs du thème (test de rendu en thème sombre) ; rendu visuel sur appareil à confirmer (US-6.4).
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
