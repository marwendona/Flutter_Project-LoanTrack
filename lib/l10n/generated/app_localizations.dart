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
