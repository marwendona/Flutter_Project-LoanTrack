# CR-037 — US-7.1 : calcul de la couleur de fiabilité

| Champ | Valeur |
|---|---|
| **Statut** | Implémentée |
| **Type** | Nouvelle fonctionnalité |
| **Date de création** | 2026-11-09 |
| **Date de décision** | 2026-11-09 (périmètre V2 validé par CR-035) |
| **Version livrée** | — |

## 1. Demande

Implémenter la user story US-7.1 : chaque emprunteur reçoit automatiquement une couleur de fiabilité calculée à partir de la ponctualité de ses remboursements (RG-60 à RG-64). Cette story livre uniquement le calcul (domaine + données) ; l'affichage relève d'US-7.2 et d'US-7.3.

## 2. Motivation

Juger la fiabilité d'un emprunteur sans relire tout son historique. Le calcul doit être fiable, testé et indépendant de l'interface pour être réutilisé par ECR-02, ECR-03 et ECR-07.

## 3. Changement proposé

- **Modèle `domain`** `ReliabilityColor` (`lib/domain/models/reliability_color.dart`) : `green`, `blue`, `purple`, `yellow`, `orange`, `red`, `black`, `notEvaluated` déclarés dans l'ordre RG-64 (comparables par leur rang).
- **Modèle `domain`** `LoanPunctuality` : `notEvaluable`, `onTime`, `shortDelay`, `longDelay` (RG-60, RG-61), et `BorrowerReliability` : N (prêts en retard), L (retards longs), nombre de prêts évalués et couleur (RG-62).
- **Service** `ReliabilityCalculator` (`lib/domain/services/reliability_calculator.dart`, Dart pur, date du jour injectée) : `loanPunctuality`, `evaluate` (emprunteur), `colorFor`.
- **Données** : `LoanBalance` reçoit la date du dernier remboursement (RG-22), agrégée en SQL (`MAX`) dans `BorrowersDao.watchWithLoanBalances` et transmise par `BorrowerRepositoryImpl` ; `LoanSummary.balance` la transmet aussi. Aucune nouvelle colonne, aucune migration ; la couleur n'est ni stockée ni exportée (RG-63).

## 4. Analyse d'impact

| Élément | Impact |
|---|---|
| Spécifications | Aucune (RG-60 à RG-64 déjà décrites par CR-035) |
| Écrans | Aucun (affichage dans US-7.2 / US-7.3) |
| Base de données | Non (requête existante complétée d'un agrégat `MAX`) |
| Format d'export JSON | Non |
| Backlog | US-7.1 passée à Terminé |
| Tests | Nouveau `reliability_calculator_test.dart` ; tests repository / DAO complétés |

## 5. Critères d'acceptation

- [x] Modèle `domain` de la couleur de fiabilité (Vert, Bleu, Violet, Jaune, Orange, Rouge, Noir, Non évalué) dans l'ordre RG-64.
- [x] Service `domain/services` (Dart pur, date du jour injectée) calculant pour un prêt : évaluable ou non, à l'heure / en retard, retard court / long (RG-60, RG-61) ; et pour un emprunteur : N, L et la couleur (RG-62).
- [x] Données nécessaires (date promise, reste dû, date du dernier remboursement par prêt) fournies par les repositories sans nouvelle colonne ni migration ; couleur jamais stockée ni exportée (RG-63).
- [x] Tests unitaires couvrant les cas listés dans US-7.1.
- [x] `flutter analyze` sans nouvel avertissement et `flutter test` vert (352 tests).

## 6. Décision

Approuvée dans le cadre du périmètre V2 (CR-035) le 2026-11-09.

## 7. Suivi de l'implémentation

- Commit : — (non commité).
- Remarques (2026-11-09) :
  - Aucun changement visible : la couleur n'est pas encore affichée (US-7.2, US-7.3).
  - `LoanPunctuality` est déclaré dans `reliability_color.dart` avec `ReliabilityColor` ; `ReliabilityColor` implémente `Comparable` (ordre RG-64), utile au tri d'ECR-07.
  - Un prêt soldé sans date de remboursement (impossible, car montant > 0) est traité par prudence comme non évaluable.
  - Tests ajoutés : `test/domain/services/reliability_calculator_test.dart` (ordre, ponctualité, retard court / long dont fin de mois, années bissextiles et passage d'année, chaque couleur) ; agrégat de la date du dernier remboursement dans `balance_aggregation_test.dart` et `repositories_test.dart`.
  - `build_runner` a régénéré plusieurs fichiers sans rapport avec des différences d'espaces uniquement ; ils ont été restaurés, seuls `loan_balance.freezed.dart` et `borrower_reliability.freezed.dart` changent.
  - `flutter analyze` : les 5 infos antérieures (tests placés dans `lib/`, cf. CR-016) subsistent.
