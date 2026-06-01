import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hallo Welt!'**
  String get helloWorld;

  /// No description provided for @agendaItemNumber.
  ///
  /// In en, this message translates to:
  /// **'Agenda item #{number}'**
  String agendaItemNumber(Object number);

  /// No description provided for @doYouReallyWantToDeleteThisAgendaItem.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this agenda item?'**
  String get doYouReallyWantToDeleteThisAgendaItem;

  /// No description provided for @doYouReallyWantToForceStartThisAgendaItem.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to force-start this agenda item?'**
  String get doYouReallyWantToForceStartThisAgendaItem;

  /// No description provided for @titleColon.
  ///
  /// In en, this message translates to:
  /// **'Title:'**
  String get titleColon;

  /// No description provided for @titleOptional.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get titleOptional;

  /// No description provided for @competitor1.
  ///
  /// In en, this message translates to:
  /// **'Competitor 1'**
  String get competitor1;

  /// No description provided for @competitor2.
  ///
  /// In en, this message translates to:
  /// **'Competitor 2'**
  String get competitor2;

  /// No description provided for @integralsColon.
  ///
  /// In en, this message translates to:
  /// **'Integrals:'**
  String get integralsColon;

  /// No description provided for @codes.
  ///
  /// In en, this message translates to:
  /// **'Codes'**
  String get codes;

  /// No description provided for @timeLimitColon.
  ///
  /// In en, this message translates to:
  /// **'Time limit:'**
  String get timeLimitColon;

  /// No description provided for @durationInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Duration in seconds'**
  String get durationInSeconds;

  /// No description provided for @spareIntegralsColon.
  ///
  /// In en, this message translates to:
  /// **'Tiebreaker integrals:'**
  String get spareIntegralsColon;

  /// No description provided for @codesOptional.
  ///
  /// In en, this message translates to:
  /// **'Codes (optional)'**
  String get codesOptional;

  /// No description provided for @competitorsColon.
  ///
  /// In en, this message translates to:
  /// **'Competitors:'**
  String get competitorsColon;

  /// No description provided for @competitors.
  ///
  /// In en, this message translates to:
  /// **'Competitors'**
  String get competitors;

  /// No description provided for @integralColon.
  ///
  /// In en, this message translates to:
  /// **'Integral:'**
  String get integralColon;

  /// No description provided for @codesRequired.
  ///
  /// In en, this message translates to:
  /// **'Codes (required)'**
  String get codesRequired;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @subtitleColon.
  ///
  /// In en, this message translates to:
  /// **'Subtitle:'**
  String get subtitleColon;

  /// No description provided for @subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get subtitle;

  /// No description provided for @imageUrlColon.
  ///
  /// In en, this message translates to:
  /// **'Image URL:'**
  String get imageUrlColon;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @youtubeVideoIdColon.
  ///
  /// In en, this message translates to:
  /// **'YouTube video ID:'**
  String get youtubeVideoIdColon;

  /// No description provided for @doYouReallyWantToStartFromTheBeginning.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to start from the beginning?'**
  String get doYouReallyWantToStartFromTheBeginning;

  /// No description provided for @doYouReallyWantToReset.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset?'**
  String get doYouReallyWantToReset;

  /// No description provided for @startFromBeginning.
  ///
  /// In en, this message translates to:
  /// **'Start from beginning'**
  String get startFromBeginning;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @downloadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Download Documents'**
  String get downloadDocuments;

  /// No description provided for @noAgendaItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No agenda items yet.'**
  String get noAgendaItemsYet;

  /// No description provided for @integralNumber.
  ///
  /// In en, this message translates to:
  /// **'Integral #{number}'**
  String integralNumber(Object number);

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get nameOptional;

  /// No description provided for @doYouReallyWantToDeleteThisIntegral.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this integral?'**
  String get doYouReallyWantToDeleteThisIntegral;

  /// No description provided for @codeCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopiedToClipboard;

  /// No description provided for @spareIntegralQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Tiebreaker integral?'**
  String get spareIntegralQuestionMark;

  /// No description provided for @problemLatex.
  ///
  /// In en, this message translates to:
  /// **'Problem (LaTeX)'**
  String get problemLatex;

  /// No description provided for @solutionLatex.
  ///
  /// In en, this message translates to:
  /// **'Solution (LaTeX)'**
  String get solutionLatex;

  /// No description provided for @youtubeVideoID.
  ///
  /// In en, this message translates to:
  /// **'YouTube video ID'**
  String get youtubeVideoID;

  /// No description provided for @youtubeVideoIDOptional.
  ///
  /// In en, this message translates to:
  /// **'YouTube video ID (optional)'**
  String get youtubeVideoIDOptional;

  /// No description provided for @integralsAdded.
  ///
  /// In en, this message translates to:
  /// **'Integrals added'**
  String get integralsAdded;

  /// No description provided for @codesList.
  ///
  /// In en, this message translates to:
  /// **'Codes: {codes}'**
  String codesList(Object codes);

  /// No description provided for @codesCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Codes copied to clipboard'**
  String get codesCopiedToClipboard;

  /// No description provided for @copyCodes.
  ///
  /// In en, this message translates to:
  /// **'Copy codes'**
  String get copyCodes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @importIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Import integrals'**
  String get importIntegrals;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @tournamentTree.
  ///
  /// In en, this message translates to:
  /// **'Tournament tree'**
  String get tournamentTree;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @allIntegralTypes.
  ///
  /// In en, this message translates to:
  /// **'All integral types'**
  String get allIntegralTypes;

  /// No description provided for @regularIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Regular integrals'**
  String get regularIntegrals;

  /// No description provided for @spareIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Tiebreaker integrals'**
  String get spareIntegrals;

  /// No description provided for @allIntegrals.
  ///
  /// In en, this message translates to:
  /// **'All integrals'**
  String get allIntegrals;

  /// No description provided for @allocatedIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Allocated integrals'**
  String get allocatedIntegrals;

  /// No description provided for @unallocatedIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Unallocated integrals'**
  String get unallocatedIntegrals;

  /// No description provided for @usedIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Used integrals'**
  String get usedIntegrals;

  /// No description provided for @unusedIntegrals.
  ///
  /// In en, this message translates to:
  /// **'Unused integrals'**
  String get unusedIntegrals;

  /// No description provided for @noIntegralsYet.
  ///
  /// In en, this message translates to:
  /// **'No integrals yet.'**
  String get noIntegralsYet;

  /// No description provided for @noIntegralsMatchTheFilter.
  ///
  /// In en, this message translates to:
  /// **'No integrals match the filters.'**
  String get noIntegralsMatchTheFilter;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFilters;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @resumeTimer.
  ///
  /// In en, this message translates to:
  /// **'Resume timer'**
  String get resumeTimer;

  /// No description provided for @pauseTimer.
  ///
  /// In en, this message translates to:
  /// **'Pause timer'**
  String get pauseTimer;

  /// No description provided for @doYouReallyWantToShowTheSolution.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to show the solution?'**
  String get doYouReallyWantToShowTheSolution;

  /// No description provided for @showSolution.
  ///
  /// In en, this message translates to:
  /// **'Show solution'**
  String get showSolution;

  /// No description provided for @personWins.
  ///
  /// In en, this message translates to:
  /// **'{person} wins'**
  String personWins(Object person);

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @cannotEditFinishedAgendaItem.
  ///
  /// In en, this message translates to:
  /// **'Cannot edit finished agenda item'**
  String get cannotEditFinishedAgendaItem;

  /// No description provided for @nextIntegral.
  ///
  /// In en, this message translates to:
  /// **'Next integral'**
  String get nextIntegral;

  /// No description provided for @doYouReallyWantToGoBack.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to go back?'**
  String get doYouReallyWantToGoBack;

  /// No description provided for @noActiveAgendaItem.
  ///
  /// In en, this message translates to:
  /// **'No active agenda item'**
  String get noActiveAgendaItem;

  /// No description provided for @pleaseChooseAnAgendaItemInCompetitionPlanner.
  ///
  /// In en, this message translates to:
  /// **'Please choose an agenda item in competition planner.'**
  String get pleaseChooseAnAgendaItemInCompetitionPlanner;

  /// No description provided for @currentAgendaItemIsNotFinishedYet.
  ///
  /// In en, this message translates to:
  /// **'The current agenda item is not finished yet. Do you want to go forward anyway?'**
  String get currentAgendaItemIsNotFinishedYet;

  /// No description provided for @startExclamationMark.
  ///
  /// In en, this message translates to:
  /// **'Start!'**
  String get startExclamationMark;

  /// No description provided for @additionalIntegral.
  ///
  /// In en, this message translates to:
  /// **'Additional integral'**
  String get additionalIntegral;

  /// No description provided for @doYouReallyWantToFinishThisQualificationRound.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to finish this qualification round?'**
  String get doYouReallyWantToFinishThisQualificationRound;

  /// No description provided for @qualificationRoundFinished.
  ///
  /// In en, this message translates to:
  /// **'Qualification round finished'**
  String get qualificationRoundFinished;

  /// No description provided for @chooseASpareIntegral.
  ///
  /// In en, this message translates to:
  /// **'Choose a tiebreaker integral'**
  String get chooseASpareIntegral;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @copyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'Software developed in Heidelberg (MIT license, {year})'**
  String copyrightNotice(Object year);

  /// No description provided for @comingUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming up: {title}'**
  String comingUpTitle(Object title);

  /// No description provided for @nextIntegralComingUp.
  ///
  /// In en, this message translates to:
  /// **'Next integral coming up'**
  String get nextIntegralComingUp;

  /// No description provided for @aVsB.
  ///
  /// In en, this message translates to:
  /// **'{a} vs. {b}'**
  String aVsB(Object a, Object b);

  /// No description provided for @exerciseNumber.
  ///
  /// In en, this message translates to:
  /// **'Exercise {number}'**
  String exerciseNumber(Object number);

  /// No description provided for @extraExerciseNumber.
  ///
  /// In en, this message translates to:
  /// **'Exercise {number}+{extra}'**
  String extraExerciseNumber(Object extra, Object number);

  /// No description provided for @pleaseEnterAValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterAValidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 5 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at most 25 characters'**
  String get passwordTooLong;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @missionControl.
  ///
  /// In en, this message translates to:
  /// **'Mission Control'**
  String get missionControl;

  /// No description provided for @competitionPlanner.
  ///
  /// In en, this message translates to:
  /// **'Competition planner'**
  String get competitionPlanner;

  /// No description provided for @integrals.
  ///
  /// In en, this message translates to:
  /// **'Integrals'**
  String get integrals;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @choosePresentation.
  ///
  /// In en, this message translates to:
  /// **'Choose presentation'**
  String get choosePresentation;

  /// No description provided for @mainPresentation.
  ///
  /// In en, this message translates to:
  /// **'Main presentation'**
  String get mainPresentation;

  /// No description provided for @sidePresentation.
  ///
  /// In en, this message translates to:
  /// **'Side presentation'**
  String get sidePresentation;

  /// No description provided for @latexBabelLanguage.
  ///
  /// In en, this message translates to:
  /// **'english'**
  String get latexBabelLanguage;

  /// No description provided for @integralListConfidential.
  ///
  /// In en, this message translates to:
  /// **'Integral list (CONFIDENTIAL)'**
  String get integralListConfidential;

  /// No description provided for @qualificationRound.
  ///
  /// In en, this message translates to:
  /// **'Qualification round'**
  String get qualificationRound;

  /// No description provided for @knockoutRound.
  ///
  /// In en, this message translates to:
  /// **'Knockout round'**
  String get knockoutRound;

  /// No description provided for @turnAroundWhenInstructed.
  ///
  /// In en, this message translates to:
  /// **'Please only turn around when instructed!'**
  String get turnAroundWhenInstructed;

  /// No description provided for @integralNumberPrint.
  ///
  /// In en, this message translates to:
  /// **'Integral No.'**
  String get integralNumberPrint;

  /// No description provided for @qualificationTestSolutions.
  ///
  /// In en, this message translates to:
  /// **'Qualification test solutions'**
  String get qualificationTestSolutions;

  /// No description provided for @exerciseNumberPrint.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseNumberPrint;

  /// No description provided for @qualificationTest.
  ///
  /// In en, this message translates to:
  /// **'Qualification test'**
  String get qualificationTest;

  /// No description provided for @remarksOnTheTest.
  ///
  /// In en, this message translates to:
  /// **'Remarks on the test -- please read carefully'**
  String get remarksOnTheTest;

  /// No description provided for @goodLuck.
  ///
  /// In en, this message translates to:
  /// **'Good luck!'**
  String get goodLuck;

  /// No description provided for @remarksColon.
  ///
  /// In en, this message translates to:
  /// **'Remarks:'**
  String get remarksColon;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notSpecifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Not specified yet'**
  String get notSpecifiedYet;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @clickBoxToEdit.
  ///
  /// In en, this message translates to:
  /// **'(Click box to edit)'**
  String get clickBoxToEdit;

  /// No description provided for @editTournamentTreeEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editTournamentTreeEntry;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @videoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Video placeholder'**
  String get videoPlaceholder;

  /// No description provided for @comingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get comingUp;

  /// No description provided for @customization.
  ///
  /// In en, this message translates to:
  /// **'Customization'**
  String get customization;

  /// No description provided for @competitionName.
  ///
  /// In en, this message translates to:
  /// **'Competition name'**
  String get competitionName;

  /// No description provided for @competitionNameColon.
  ///
  /// In en, this message translates to:
  /// **'Competition name:'**
  String get competitionNameColon;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Integration Bee Helper'**
  String get appName;

  /// No description provided for @logoColon.
  ///
  /// In en, this message translates to:
  /// **'Logo:'**
  String get logoColon;

  /// No description provided for @backgroundColon.
  ///
  /// In en, this message translates to:
  /// **'Background:'**
  String get backgroundColon;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadImage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @addCompetitor.
  ///
  /// In en, this message translates to:
  /// **'Add competitor'**
  String get addCompetitor;

  /// No description provided for @spareQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Tiebreaker?'**
  String get spareQuestionMark;

  /// No description provided for @allocatedQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Allocated?'**
  String get allocatedQuestionMark;

  /// No description provided for @usedQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Used?'**
  String get usedQuestionMark;

  /// No description provided for @addIntegral.
  ///
  /// In en, this message translates to:
  /// **'Add integral'**
  String get addIntegral;

  /// No description provided for @editIntegral.
  ///
  /// In en, this message translates to:
  /// **'Edit integral'**
  String get editIntegral;

  /// No description provided for @imageColon.
  ///
  /// In en, this message translates to:
  /// **'Image:'**
  String get imageColon;

  /// No description provided for @selectIntegral.
  ///
  /// In en, this message translates to:
  /// **'Select integral'**
  String get selectIntegral;

  /// No description provided for @tagsColon.
  ///
  /// In en, this message translates to:
  /// **'Tags:'**
  String get tagsColon;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @exportFilenameZip.
  ///
  /// In en, this message translates to:
  /// **'integration_bee_documents.zip'**
  String get exportFilenameZip;

  /// No description provided for @exportFilenameKnockout.
  ///
  /// In en, this message translates to:
  /// **'ONE-SIDED_BW_knockout.tex'**
  String get exportFilenameKnockout;

  /// No description provided for @exportFilenameQualification.
  ///
  /// In en, this message translates to:
  /// **'DOUBLE-SIDED_BW_qualification.tex'**
  String get exportFilenameQualification;

  /// No description provided for @exportFilenameTest.
  ///
  /// In en, this message translates to:
  /// **'DOUBLE-SIDED_BW_qualification_test.tex'**
  String get exportFilenameTest;

  /// No description provided for @exportFilenameSolution.
  ///
  /// In en, this message translates to:
  /// **'DOUBLE-SIDED_BW_qualification_test_solution.tex'**
  String get exportFilenameSolution;

  /// No description provided for @exportFilenameList.
  ///
  /// In en, this message translates to:
  /// **'DOUBLE-SIDED_BW_integrals_list.tex'**
  String get exportFilenameList;
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
