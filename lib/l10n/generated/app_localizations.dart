import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'LoanTrack'**
  String get appTitle;

  /// Onglet et titre de l'écran ECR-01
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get navDashboard;

  /// Onglet et titre de l'écran ECR-02
  ///
  /// In fr, this message translates to:
  /// **'Emprunteurs'**
  String get navBorrowers;

  /// Onglet et titre de l'écran ECR-06
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// Message affiché quand la lecture de la base échoue
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les données.'**
  String get loadError;

  /// Badge d'un emprunteur ayant au moins un prêt en retard (RG-20)
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get overdueBadge;

  /// État vide de la liste des emprunteurs (ECR-02)
  ///
  /// In fr, this message translates to:
  /// **'Aucun emprunteur. Appuyez sur + pour en ajouter un.'**
  String get borrowersEmpty;

  /// Nombre de prêts non entièrement remboursés d'un emprunteur (ECR-02)
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun prêt actif} =1{1 prêt actif} other{{count} prêts actifs}}'**
  String borrowersActiveLoans(int count);

  /// Libellé du reste dû d'un emprunteur dans la liste (ECR-02)
  ///
  /// In fr, this message translates to:
  /// **'Reste dû'**
  String get borrowersRemainingLabel;

  /// Bouton d'annulation d'un formulaire ou d'un dialogue
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionCancel;

  /// Bouton d'enregistrement d'un formulaire
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get actionSave;

  /// Message affiché quand l'écriture en base échoue
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer. Réessayez.'**
  String get saveError;

  /// Erreur de validation d'une note trop longue
  ///
  /// In fr, this message translates to:
  /// **'La note ne peut pas dépasser {max} caractères.'**
  String noteTooLong(int max);

  /// Info-bulle du bouton + de la liste des emprunteurs (ECR-02)
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un emprunteur'**
  String get borrowerAddTooltip;

  /// Titre de la feuille de création d'un emprunteur (ECR-02)
  ///
  /// In fr, this message translates to:
  /// **'Nouvel emprunteur'**
  String get borrowerFormNewTitle;

  /// Titre de la feuille de modification d'un emprunteur (US-1.4)
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'emprunteur'**
  String get borrowerFormEditTitle;

  /// Champ nom du formulaire emprunteur
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get borrowerFormName;

  /// Champ téléphone du formulaire emprunteur
  ///
  /// In fr, this message translates to:
  /// **'Téléphone (facultatif)'**
  String get borrowerFormPhone;

  /// Champ note du formulaire emprunteur
  ///
  /// In fr, this message translates to:
  /// **'Note (facultative)'**
  String get borrowerFormNote;

  /// Erreur : nom d'emprunteur vide (RG-01)
  ///
  /// In fr, this message translates to:
  /// **'Le nom est obligatoire.'**
  String get borrowerNameRequired;

  /// Erreur : nom d'emprunteur trop long (RG-01)
  ///
  /// In fr, this message translates to:
  /// **'Le nom ne peut pas dépasser {max} caractères.'**
  String borrowerNameTooLong(int max);

  /// Erreur : nom d'emprunteur déjà utilisé (RG-02)
  ///
  /// In fr, this message translates to:
  /// **'Un emprunteur porte déjà ce nom.'**
  String get borrowerNameDuplicate;

  /// Titre du dialogue de confirmation de suppression d'un emprunteur (RG-03)
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cet emprunteur ?'**
  String get borrowerDeleteTitle;

  /// Bouton de confirmation de suppression d'un emprunteur
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get borrowerDeleteConfirm;

  /// Message de confirmation de suppression d'un emprunteur (RG-03)
  ///
  /// In fr, this message translates to:
  /// **'{loanCount, plural, =0{Aucun prêt} =1{1 prêt} other{{loanCount} prêts}} seront supprimés. Reste dû : {remaining}.'**
  String borrowerDeleteMessage(int loanCount, String remaining);

  /// Indice du champ de recherche d'emprunteur (US-1.5)
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un emprunteur...'**
  String get borrowerSearchHint;

  /// Titre de l'écran de création d'un prêt (ECR-04) et action qui l'ouvre
  ///
  /// In fr, this message translates to:
  /// **'Nouveau prêt'**
  String get loanFormNewTitle;

  /// Champ montant du formulaire prêt (ECR-04)
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get loanFormAmount;

  /// Champ date du prêt (ECR-04)
  ///
  /// In fr, this message translates to:
  /// **'Date du prêt'**
  String get loanFormLoanDate;

  /// Champ date de retour promise (ECR-04)
  ///
  /// In fr, this message translates to:
  /// **'Date de retour promise (facultative)'**
  String get loanFormPromisedReturnDate;

  /// Valeur affichée quand aucune date de retour promise n'est choisie
  ///
  /// In fr, this message translates to:
  /// **'Non définie'**
  String get loanFormPromisedReturnDateNone;

  /// Info-bulle du bouton qui efface la date de retour promise
  ///
  /// In fr, this message translates to:
  /// **'Effacer la date promise'**
  String get loanFormPromisedReturnDateClear;

  /// Champ note du formulaire prêt (ECR-04)
  ///
  /// In fr, this message translates to:
  /// **'Note / motif (facultatif)'**
  String get loanFormNote;

  /// Erreur : montant de prêt vide (RG-10)
  ///
  /// In fr, this message translates to:
  /// **'Le montant est obligatoire.'**
  String get loanAmountRequired;

  /// Erreur : saisie du montant non reconnue (RG-10)
  ///
  /// In fr, this message translates to:
  /// **'{decimals, plural, =0{Montant invalide : saisissez un nombre entier.} =1{Montant invalide : au plus 1 décimale.} other{Montant invalide : au plus {decimals} décimales.}}'**
  String loanAmountInvalid(int decimals);

  /// Erreur : montant de prêt nul (RG-10)
  ///
  /// In fr, this message translates to:
  /// **'Le montant doit être supérieur à zéro.'**
  String get loanAmountNotPositive;

  /// Erreur : montant de prêt trop élevé (RG-10)
  ///
  /// In fr, this message translates to:
  /// **'Le montant ne peut pas dépasser {max}.'**
  String loanAmountTooLarge(String max);

  /// Erreur : date du prêt future (RG-11)
  ///
  /// In fr, this message translates to:
  /// **'La date du prêt ne peut pas être dans le futur.'**
  String get loanDateInFuture;

  /// Erreur : date de retour promise antérieure à la date du prêt (RG-12)
  ///
  /// In fr, this message translates to:
  /// **'La date promise doit être égale ou postérieure à la date du prêt.'**
  String get loanPromisedReturnDateBeforeLoanDate;

  /// Erreur : montant d'un prêt modifié inférieur au montant déjà remboursé (RG-13)
  ///
  /// In fr, this message translates to:
  /// **'Le montant ne peut pas être inférieur au montant déjà remboursé ({repaid}).'**
  String loanAmountBelowRepaid(String repaid);

  /// Erreur : date d'un prêt modifié postérieure à son premier remboursement (RG-11)
  ///
  /// In fr, this message translates to:
  /// **'La date du prêt ne peut pas être postérieure au premier remboursement ({date}).'**
  String loanDateAfterFirstRepayment(String date);

  /// Titre d'ECR-04 en modification et action qui l'ouvre (US-2.4)
  ///
  /// In fr, this message translates to:
  /// **'Modifier le prêt'**
  String get loanFormEditTitle;

  /// Message d'ECR-04 quand le prêt à modifier a été supprimé
  ///
  /// In fr, this message translates to:
  /// **'Ce prêt n\'existe plus.'**
  String get loanNotFound;

  /// Action du menu ⋮ d'un prêt (US-2.4)
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le prêt'**
  String get loanDeleteAction;

  /// Titre du dialogue de suppression d'un prêt (RG-14)
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce prêt ?'**
  String get loanDeleteTitle;

  /// Message du dialogue de suppression d'un prêt (RG-14)
  ///
  /// In fr, this message translates to:
  /// **'Le prêt de {amount} du {date} et tous ses remboursements seront supprimés.'**
  String loanDeleteMessage(String amount, String date);

  /// Bouton de confirmation du dialogue de suppression d'un prêt
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get loanDeleteConfirm;

  /// Info-bulle d'un menu ⋮
  ///
  /// In fr, this message translates to:
  /// **'Plus d\'actions'**
  String get moreActionsTooltip;

  /// Message d'ECR-03 quand l'emprunteur a été supprimé
  ///
  /// In fr, this message translates to:
  /// **'Cet emprunteur n\'existe plus.'**
  String get borrowerDetailNotFound;

  /// Info-bulle du téléphone d'un emprunteur : ouvre le composeur (ECR-03)
  ///
  /// In fr, this message translates to:
  /// **'Appeler'**
  String get borrowerDetailCallTooltip;

  /// Message affiché quand le composeur du téléphone ne peut pas être ouvert (ECR-03)
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir le composeur.'**
  String get borrowerDetailCallError;

  /// Résumé d'ECR-03 : somme des prêts de l'emprunteur (RG-30)
  ///
  /// In fr, this message translates to:
  /// **'Total prêté'**
  String get borrowerDetailTotalLent;

  /// Résumé d'ECR-03 : somme des remboursements de l'emprunteur (RG-30)
  ///
  /// In fr, this message translates to:
  /// **'Total remboursé'**
  String get borrowerDetailTotalRepaid;

  /// État vide de la liste des prêts d'un emprunteur (ECR-03)
  ///
  /// In fr, this message translates to:
  /// **'Aucun prêt. Appuyez sur « Prêt » pour en ajouter un.'**
  String get borrowerDetailLoansEmpty;

  /// Bouton flottant « + Prêt » d'ECR-03, ouvre ECR-04
  ///
  /// In fr, this message translates to:
  /// **'Prêt'**
  String get loanAddButton;

  /// Date du prêt sur la carte d'un prêt (ECR-03)
  ///
  /// In fr, this message translates to:
  /// **'Prêté le {date}'**
  String loanLentOn(String date);

  /// Date de retour promise sur la carte d'un prêt (ECR-03) ; « Non définie » si absente
  ///
  /// In fr, this message translates to:
  /// **'Retour promis : {date}'**
  String loanPromisedReturn(String date);

  /// Montant remboursé d'un prêt (RG-21)
  ///
  /// In fr, this message translates to:
  /// **'Remboursé : {amount}'**
  String loanRepaidAmount(String amount);

  /// Reste dû d'un prêt (RG-21)
  ///
  /// In fr, this message translates to:
  /// **'Reste dû : {amount}'**
  String loanRemainingAmount(String amount);

  /// Date de remboursement effective d'un prêt soldé (RG-22)
  ///
  /// In fr, this message translates to:
  /// **'Remboursé le {date}'**
  String loanRepaidOn(String date);

  /// Statut d'un prêt (RG-20)
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get loanStatusOngoing;

  /// Statut d'un prêt (RG-20)
  ///
  /// In fr, this message translates to:
  /// **'Partiellement remboursé'**
  String get loanStatusPartiallyRepaid;

  /// Statut d'un prêt (RG-20)
  ///
  /// In fr, this message translates to:
  /// **'Remboursé'**
  String get loanStatusRepaid;

  /// Statut d'un prêt en retard avec le nombre de jours de retard (RG-20, RG-23)
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =1{En retard de 1 jour} other{En retard de {days} jours}}'**
  String loanStatusOverdue(int days);

  /// Titre de la feuille de saisie d'un remboursement (ECR-05b)
  ///
  /// In fr, this message translates to:
  /// **'Nouveau remboursement'**
  String get repaymentFormNewTitle;

  /// Action du menu ⋮ d'un prêt qui ouvre ECR-05b (US-3.1)
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un remboursement'**
  String get repaymentAddAction;

  /// Champ montant de la feuille de remboursement (ECR-05b)
  ///
  /// In fr, this message translates to:
  /// **'Montant remboursé'**
  String get repaymentFormAmount;

  /// Bouton qui pré-remplit le montant avec le reste dû (RG-18)
  ///
  /// In fr, this message translates to:
  /// **'Totalité'**
  String get repaymentFormFullAmount;

  /// Champ date réelle du remboursement (ECR-05b)
  ///
  /// In fr, this message translates to:
  /// **'Date du remboursement'**
  String get repaymentFormDate;

  /// Champ note de la feuille de remboursement (ECR-05b)
  ///
  /// In fr, this message translates to:
  /// **'Note (facultative)'**
  String get repaymentFormNote;

  /// Erreur : remboursement supérieur au reste dû (RG-16)
  ///
  /// In fr, this message translates to:
  /// **'Le montant ne peut pas dépasser le reste dû ({remaining}).'**
  String repaymentAmountExceedsRemaining(String remaining);

  /// Erreur : date de remboursement antérieure à la date du prêt (RG-17)
  ///
  /// In fr, this message translates to:
  /// **'La date ne peut pas être antérieure à la date du prêt ({date}).'**
  String repaymentDateBeforeLoanDate(String date);

  /// Erreur : date de remboursement future (RG-17)
  ///
  /// In fr, this message translates to:
  /// **'La date du remboursement ne peut pas être dans le futur.'**
  String get repaymentDateInFuture;

  /// Titre de l'écran de détail d'un prêt (ECR-05)
  ///
  /// In fr, this message translates to:
  /// **'Détail du prêt'**
  String get loanDetailTitle;

  /// Titre de l'historique des remboursements d'un prêt (ECR-05)
  ///
  /// In fr, this message translates to:
  /// **'Remboursements'**
  String get repaymentHistoryTitle;

  /// État vide de l'historique des remboursements (ECR-05)
  ///
  /// In fr, this message translates to:
  /// **'Aucun remboursement.'**
  String get repaymentHistoryEmpty;

  /// Bouton flottant « + Remboursement » d'ECR-05, ouvre ECR-05b
  ///
  /// In fr, this message translates to:
  /// **'Remboursement'**
  String get repaymentAddButton;

  /// Titre de la feuille ECR-05b en modification (US-3.3)
  ///
  /// In fr, this message translates to:
  /// **'Modifier le remboursement'**
  String get repaymentFormEditTitle;

  /// Rappel du plafond d'un remboursement modifié : reste dû + montant initial (RG-16)
  ///
  /// In fr, this message translates to:
  /// **'Montant maximal : {amount}'**
  String repaymentFormMaxAmount(String amount);

  /// Erreur : remboursement modifié supérieur au plafond (RG-16)
  ///
  /// In fr, this message translates to:
  /// **'Le montant ne peut pas dépasser {max} (reste dû + montant initial).'**
  String repaymentAmountExceedsMax(String max);

  /// Titre du dialogue de confirmation de suppression d'un remboursement (RG-19)
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce remboursement ?'**
  String get repaymentDeleteTitle;

  /// Message du dialogue de suppression d'un remboursement (RG-19)
  ///
  /// In fr, this message translates to:
  /// **'Le remboursement de {amount} du {date} sera supprimé.'**
  String repaymentDeleteMessage(String amount, String date);

  /// Bouton de suppression d'un remboursement (ECR-05b) et de confirmation (RG-19)
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get repaymentDeleteConfirm;

  /// Titre de la carte mise en avant d'ECR-01 : reste dû global (RG-31)
  ///
  /// In fr, this message translates to:
  /// **'Reste à recevoir'**
  String get dashboardRemainingTitle;

  /// Nombre d'emprunteurs ayant un reste dû > 0 (RG-31, ECR-01)
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun emprunteur ne vous doit d\'argent} =1{Auprès de 1 emprunteur} other{Auprès de {count} emprunteurs}}'**
  String dashboardBorrowersWithRemaining(int count);

  /// Indicateur d'ECR-01 : total remboursé / total prêté (RG-32)
  ///
  /// In fr, this message translates to:
  /// **'Taux de remboursement'**
  String get dashboardRepaymentRate;

  /// Valeur du taux de remboursement en pourcentage (RG-32)
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String dashboardRepaymentRateValue(int percent);

  /// Indicateur d'ECR-01 : nombre de prêts en retard (RG-31)
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun prêt en retard} =1{1 prêt en retard} other{{count} prêts en retard}}'**
  String dashboardOverdueLoans(int count);

  /// État vide d'ECR-01
  ///
  /// In fr, this message translates to:
  /// **'Aucun prêt enregistré'**
  String get dashboardEmpty;

  /// Bouton de l'état vide d'ECR-01, ouvre la feuille « Nouvel emprunteur »
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un emprunteur'**
  String get dashboardAddBorrower;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
