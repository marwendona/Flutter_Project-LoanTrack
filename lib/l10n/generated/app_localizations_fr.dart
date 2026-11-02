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
}
