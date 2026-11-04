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
}
