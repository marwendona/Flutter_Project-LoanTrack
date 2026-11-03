// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LoanTrack';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navBorrowers => 'Emprunteurs';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get loadError => 'Impossible de charger les données.';

  @override
  String get overdueBadge => 'En retard';

  @override
  String get borrowersEmpty =>
      'Aucun emprunteur. Appuyez sur + pour en ajouter un.';

  @override
  String borrowersActiveLoans(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prêts actifs',
      one: '1 prêt actif',
      zero: 'Aucun prêt actif',
    );
    return '$_temp0';
  }

  @override
  String get borrowersRemainingLabel => 'Reste dû';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get saveError => 'Impossible d\'enregistrer. Réessayez.';

  @override
  String noteTooLong(int max) {
    return 'La note ne peut pas dépasser $max caractères.';
  }

  @override
  String get borrowerAddTooltip => 'Ajouter un emprunteur';

  @override
  String get borrowerFormNewTitle => 'Nouvel emprunteur';

  @override
  String get borrowerFormName => 'Nom';

  @override
  String get borrowerFormPhone => 'Téléphone (facultatif)';

  @override
  String get borrowerFormNote => 'Note (facultative)';

  @override
  String get borrowerNameRequired => 'Le nom est obligatoire.';

  @override
  String borrowerNameTooLong(int max) {
    return 'Le nom ne peut pas dépasser $max caractères.';
  }

  @override
  String get borrowerNameDuplicate => 'Un emprunteur porte déjà ce nom.';

  @override
  String get borrowerDeleteTitle => 'Supprimer cet emprunteur ?';

  @override
  String get borrowerDeleteConfirm => 'Supprimer';

  @override
  String borrowerDeleteMessage(int loanCount, String remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      loanCount,
      locale: localeName,
      other: '$loanCount prêts',
      one: '1 prêt',
      zero: 'Aucun prêt',
    );
    return '$_temp0 seront supprimés. Reste dû : $remaining.';
  }
}
