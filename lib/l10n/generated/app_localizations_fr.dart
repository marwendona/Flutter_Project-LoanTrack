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
  String get reliabilityTitle => 'Fiabilité';

  @override
  String reliabilityColorLabel(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'green': 'Toujours à l\'heure',
      'blue': '1 retard court',
      'purple': '1 retard long',
      'yellow': '2 retards courts',
      'orange': '2 retards dont 1 long',
      'red': 'Retards fréquents',
      'black': 'Retards très fréquents',
      'other': 'Non évalué',
    });
    return '$_temp0';
  }

  @override
  String reliabilityDelayDetail(int late, int longDelays) {
    String _temp0 = intl.Intl.pluralLogic(
      late,
      locale: localeName,
      other: '$late prêts en retard',
      one: '1 prêt en retard',
    );
    String _temp1 = intl.Intl.pluralLogic(
      longDelays,
      locale: localeName,
      other: 'dont $longDelays de plus d\'un mois',
      zero: 'dont aucun de plus d\'un mois',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get reliabilityNoDelay => 'Aucun prêt en retard';

  @override
  String reliabilityColorCondition(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'green': 'Tous les prêts évalués ont été remboursés au plus tard à la date promise.',
      'blue': 'Un seul prêt en retard, d\'un mois au plus.',
      'purple': 'Un seul prêt en retard, de plus d\'un mois.',
      'yellow': 'Deux prêts en retard, d\'un mois au plus chacun.',
      'orange': 'Deux prêts en retard, dont un de plus d\'un mois.',
      'red':
          'Deux prêts en retard de plus d\'un mois, ou trois prêts en retard.',
      'black': 'Plus de trois prêts en retard.',
      'other': 'Aucun prêt évalué : aucun prêt, ou seulement des prêts sans date promise ou pas encore échus.',
    });
    return '$_temp0';
  }

  @override
  String get reliabilityLegendTitle => 'Signification des couleurs';

  @override
  String get reliabilityLegendFootnote =>
      'Un prêt est en retard s\'il a été soldé après la date promise, ou s\'il ne l\'est toujours pas alors que cette date est passée. Les retards comptent sur tous les prêts, même soldés.';

  @override
  String get borrowersByColorTitle => 'Emprunteurs par couleur';

  @override
  String get borrowersByColorEmpty => 'Aucun emprunteur.';

  @override
  String borrowersByColorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emprunteurs',
      one: '1 emprunteur',
    );
    return '$_temp0';
  }

  @override
  String get actionClose => 'Fermer';

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
  String get borrowerFormEditTitle => 'Modifier l\'emprunteur';

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

  @override
  String get borrowerSearchHint => 'Rechercher un emprunteur...';

  @override
  String get loanFormNewTitle => 'Nouveau prêt';

  @override
  String get loanFormAmount => 'Montant';

  @override
  String get loanFormLoanDate => 'Date du prêt';

  @override
  String get loanFormPromisedReturnDate =>
      'Date de retour promise (facultative)';

  @override
  String get loanFormPromisedReturnDateNone => 'Non définie';

  @override
  String get loanFormPromisedReturnDateClear => 'Effacer la date promise';

  @override
  String get loanFormNote => 'Note / motif (facultatif)';

  @override
  String get loanAmountRequired => 'Le montant est obligatoire.';

  @override
  String loanAmountInvalid(int decimals) {
    String _temp0 = intl.Intl.pluralLogic(
      decimals,
      locale: localeName,
      other: 'Montant invalide : au plus $decimals décimales.',
      one: 'Montant invalide : au plus 1 décimale.',
      zero: 'Montant invalide : saisissez un nombre entier.',
    );
    return '$_temp0';
  }

  @override
  String get loanAmountNotPositive => 'Le montant doit être supérieur à zéro.';

  @override
  String loanAmountTooLarge(String max) {
    return 'Le montant ne peut pas dépasser $max.';
  }

  @override
  String get loanDateInFuture =>
      'La date du prêt ne peut pas être dans le futur.';

  @override
  String get loanPromisedReturnDateBeforeLoanDate =>
      'La date promise doit être égale ou postérieure à la date du prêt.';

  @override
  String loanAmountBelowRepaid(String repaid) {
    return 'Le montant ne peut pas être inférieur au montant déjà remboursé ($repaid).';
  }

  @override
  String loanDateAfterFirstRepayment(String date) {
    return 'La date du prêt ne peut pas être postérieure au premier remboursement ($date).';
  }

  @override
  String get loanFormEditTitle => 'Modifier le prêt';

  @override
  String get loanNotFound => 'Ce prêt n\'existe plus.';

  @override
  String get loanDeleteAction => 'Supprimer le prêt';

  @override
  String get loanDeleteTitle => 'Supprimer ce prêt ?';

  @override
  String loanDeleteMessage(String amount, String date) {
    return 'Le prêt de $amount du $date et tous ses remboursements seront supprimés.';
  }

  @override
  String get loanDeleteConfirm => 'Supprimer';

  @override
  String get moreActionsTooltip => 'Plus d\'actions';

  @override
  String get borrowerDetailNotFound => 'Cet emprunteur n\'existe plus.';

  @override
  String get borrowerDetailCallTooltip => 'Appeler';

  @override
  String get borrowerDetailCallError => 'Impossible d\'ouvrir le composeur.';

  @override
  String get borrowerDetailTotalLent => 'Total prêté';

  @override
  String get borrowerDetailTotalRepaid => 'Total remboursé';

  @override
  String get borrowerDetailLoansEmpty =>
      'Aucun prêt. Appuyez sur « Prêt » pour en ajouter un.';

  @override
  String get loanAddButton => 'Prêt';

  @override
  String loanLentOn(String date) {
    return 'Prêté le $date';
  }

  @override
  String loanPromisedReturn(String date) {
    return 'Retour promis : $date';
  }

  @override
  String loanRepaidAmount(String amount) {
    return 'Remboursé : $amount';
  }

  @override
  String loanRemainingAmount(String amount) {
    return 'Reste dû : $amount';
  }

  @override
  String loanRepaidOn(String date) {
    return 'Remboursé le $date';
  }

  @override
  String get loanStatusOngoing => 'En cours';

  @override
  String get loanStatusPartiallyRepaid => 'Partiellement remboursé';

  @override
  String get loanStatusRepaid => 'Remboursé';

  @override
  String loanStatusOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'En retard de $days jours',
      one: 'En retard de 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get repaymentFormNewTitle => 'Nouveau remboursement';

  @override
  String get repaymentAddAction => 'Ajouter un remboursement';

  @override
  String get repaymentFormAmount => 'Montant remboursé';

  @override
  String get repaymentFormFullAmount => 'Totalité';

  @override
  String get repaymentFormDate => 'Date du remboursement';

  @override
  String get repaymentFormNote => 'Note (facultative)';

  @override
  String repaymentAmountExceedsRemaining(String remaining) {
    return 'Le montant ne peut pas dépasser le reste dû ($remaining).';
  }

  @override
  String repaymentDateBeforeLoanDate(String date) {
    return 'La date ne peut pas être antérieure à la date du prêt ($date).';
  }

  @override
  String get repaymentDateInFuture =>
      'La date du remboursement ne peut pas être dans le futur.';

  @override
  String get loanDetailTitle => 'Détail du prêt';

  @override
  String get repaymentHistoryTitle => 'Remboursements';

  @override
  String get repaymentHistoryEmpty => 'Aucun remboursement.';

  @override
  String get repaymentAddButton => 'Remboursement';

  @override
  String get repaymentFormEditTitle => 'Modifier le remboursement';

  @override
  String repaymentFormMaxAmount(String amount) {
    return 'Montant maximal : $amount';
  }

  @override
  String repaymentAmountExceedsMax(String max) {
    return 'Le montant ne peut pas dépasser $max (reste dû + montant initial).';
  }

  @override
  String get repaymentDeleteTitle => 'Supprimer ce remboursement ?';

  @override
  String repaymentDeleteMessage(String amount, String date) {
    return 'Le remboursement de $amount du $date sera supprimé.';
  }

  @override
  String get repaymentDeleteConfirm => 'Supprimer';

  @override
  String get dashboardRemainingTitle => 'Reste à recevoir';

  @override
  String dashboardBorrowersWithRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Auprès de $count emprunteurs',
      one: 'Auprès de 1 emprunteur',
      zero: 'Aucun emprunteur ne vous doit d\'argent',
    );
    return '$_temp0';
  }

  @override
  String get dashboardRepaymentRate => 'Taux de remboursement';

  @override
  String dashboardRepaymentRateValue(int percent) {
    return '$percent %';
  }

  @override
  String dashboardOverdueLoans(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prêts en retard',
      one: '1 prêt en retard',
      zero: 'Aucun prêt en retard',
    );
    return '$_temp0';
  }

  @override
  String get dashboardEmpty => 'Aucun prêt enregistré';

  @override
  String get dashboardAddBorrower => 'Ajouter un emprunteur';

  @override
  String get dashboardFilterAll => 'Tous';

  @override
  String get dashboardFilterWithRemaining => 'Avec reste dû';

  @override
  String get dashboardFilterOverdue => 'En retard';

  @override
  String get dashboardFilterNoMatch =>
      'Aucun emprunteur ne correspond à ce filtre';

  @override
  String get dashboardByBorrowerTitle => 'Par emprunteur';

  @override
  String get settingsCurrency => 'Devise';

  @override
  String settingsCurrencyValue(String code, String name) {
    return '$code — $name';
  }

  @override
  String get settingsCurrencyDialogTitle => 'Choisir la devise';

  @override
  String get settingsCurrencyLocked =>
      'La devise ne peut plus être modifiée une fois des prêts enregistrés';

  @override
  String get settingsCurrencyChangeError =>
      'La devise n\'a pas pu être modifiée';

  @override
  String get settingsExport => 'Exporter les données';

  @override
  String get settingsExportSubtitle =>
      'Enregistrer une sauvegarde au format JSON';

  @override
  String get settingsExportSuccess => 'Données exportées';

  @override
  String get settingsExportError => 'L\'export des données a échoué';

  @override
  String get settingsImport => 'Importer des données';

  @override
  String get settingsImportSubtitle =>
      'Remplacer les données par une sauvegarde JSON';

  @override
  String get settingsImportConfirmTitle => 'Remplacer toutes les données ?';

  @override
  String settingsImportConfirmMessage(
    String date,
    int borrowerCount,
    int loanCount,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      borrowerCount,
      locale: localeName,
      other: '$borrowerCount emprunteurs',
      one: '1 emprunteur',
      zero: 'aucun emprunteur',
    );
    String _temp1 = intl.Intl.pluralLogic(
      loanCount,
      locale: localeName,
      other: '$loanCount prêts',
      one: '1 prêt',
      zero: 'aucun prêt',
    );
    return 'Sauvegarde du $date : $_temp0, $_temp1.\n\nToutes les données actuelles seront remplacées par celles de ce fichier.';
  }

  @override
  String get settingsImportConfirm => 'Remplacer';

  @override
  String get settingsImportCancel => 'Annuler';

  @override
  String get settingsImportSuccess => 'Données importées';

  @override
  String get settingsImportInvalid =>
      'Fichier invalide : aucune donnée n\'a été modifiée';

  @override
  String get settingsImportUnsupportedVersion =>
      'Version de fichier non prise en charge : aucune donnée n\'a été modifiée';

  @override
  String get settingsImportError => 'L\'import des données a échoué';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeDialogTitle => 'Choisir le thème';

  @override
  String settingsThemeValue(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'light': 'Clair',
      'dark': 'Sombre',
      'other': 'Système',
    });
    return '$_temp0';
  }

  @override
  String get settingsThemeChangeError => 'Le thème n\'a pas pu être modifié';

  @override
  String get settingsVersion => 'Version';

  @override
  String settingsVersionValue(String name, String code) {
    return '$name ($code)';
  }

  @override
  String get settingsVersionUnavailable => 'Indisponible';

  @override
  String currencyName(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'TND': 'Dinar tunisien',
      'EUR': 'Euro',
      'USD': 'Dollar américain',
      'GBP': 'Livre sterling',
      'CHF': 'Franc suisse',
      'CAD': 'Dollar canadien',
      'MAD': 'Dirham marocain',
      'DZD': 'Dinar algérien',
      'LYD': 'Dinar libyen',
      'other': '$code',
    });
    return '$_temp0';
  }
}
