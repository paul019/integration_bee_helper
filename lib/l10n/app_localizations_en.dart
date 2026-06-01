// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String agendaItemNumber(Object number) {
    return 'Agenda item #$number';
  }

  @override
  String get doYouReallyWantToDeleteThisAgendaItem =>
      'Do you really want to delete this agenda item?';

  @override
  String get doYouReallyWantToForceStartThisAgendaItem =>
      'Do you really want to force-start this agenda item?';

  @override
  String get titleColon => 'Title:';

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get competitor1 => 'Competitor 1';

  @override
  String get competitor2 => 'Competitor 2';

  @override
  String get integralsColon => 'Integrals:';

  @override
  String get codes => 'Codes';

  @override
  String get timeLimitColon => 'Time limit:';

  @override
  String get durationInSeconds => 'Duration in seconds';

  @override
  String get spareIntegralsColon => 'Tiebreaker integrals:';

  @override
  String get codesOptional => 'Codes (optional)';

  @override
  String get competitorsColon => 'Competitors:';

  @override
  String get competitors => 'Competitors';

  @override
  String get integralColon => 'Integral:';

  @override
  String get codesRequired => 'Codes (required)';

  @override
  String get title => 'Title';

  @override
  String get subtitleColon => 'Subtitle:';

  @override
  String get subtitle => 'Subtitle';

  @override
  String get imageUrlColon => 'Image URL:';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get youtubeVideoIdColon => 'YouTube video ID:';

  @override
  String get doYouReallyWantToStartFromTheBeginning =>
      'Do you really want to start from the beginning?';

  @override
  String get doYouReallyWantToReset => 'Do you really want to reset?';

  @override
  String get startFromBeginning => 'Start from beginning';

  @override
  String get reset => 'Reset';

  @override
  String get downloadDocuments => 'Download Documents';

  @override
  String get noAgendaItemsYet => 'No agenda items yet.';

  @override
  String integralNumber(Object number) {
    return 'Integral #$number';
  }

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get doYouReallyWantToDeleteThisIntegral =>
      'Do you really want to delete this integral?';

  @override
  String get codeCopiedToClipboard => 'Code copied to clipboard';

  @override
  String get spareIntegralQuestionMark => 'Tiebreaker integral?';

  @override
  String get problemLatex => 'Problem (LaTeX)';

  @override
  String get solutionLatex => 'Solution (LaTeX)';

  @override
  String get youtubeVideoID => 'YouTube video ID';

  @override
  String get youtubeVideoIDOptional => 'YouTube video ID (optional)';

  @override
  String get integralsAdded => 'Integrals added';

  @override
  String codesList(Object codes) {
    return 'Codes: $codes';
  }

  @override
  String get codesCopiedToClipboard => 'Codes copied to clipboard';

  @override
  String get copyCodes => 'Copy codes';

  @override
  String get close => 'Close';

  @override
  String get importIntegrals => 'Import integrals';

  @override
  String get import => 'Import';

  @override
  String get tournamentTree => 'Tournament tree';

  @override
  String get preview => 'Preview';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get allIntegralTypes => 'All integral types';

  @override
  String get regularIntegrals => 'Regular integrals';

  @override
  String get spareIntegrals => 'Tiebreaker integrals';

  @override
  String get allIntegrals => 'All integrals';

  @override
  String get allocatedIntegrals => 'Allocated integrals';

  @override
  String get unallocatedIntegrals => 'Unallocated integrals';

  @override
  String get usedIntegrals => 'Used integrals';

  @override
  String get unusedIntegrals => 'Unused integrals';

  @override
  String get noIntegralsYet => 'No integrals yet.';

  @override
  String get noIntegralsMatchTheFilter => 'No integrals match the filters.';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get start => 'Start';

  @override
  String get resumeTimer => 'Resume timer';

  @override
  String get pauseTimer => 'Pause timer';

  @override
  String get doYouReallyWantToShowTheSolution =>
      'Do you really want to show the solution?';

  @override
  String get showSolution => 'Show solution';

  @override
  String personWins(Object person) {
    return '$person wins';
  }

  @override
  String get draw => 'Draw';

  @override
  String get cannotEditFinishedAgendaItem => 'Cannot edit finished agenda item';

  @override
  String get nextIntegral => 'Next integral';

  @override
  String get doYouReallyWantToGoBack => 'Do you really want to go back?';

  @override
  String get noActiveAgendaItem => 'No active agenda item';

  @override
  String get pleaseChooseAnAgendaItemInCompetitionPlanner =>
      'Please choose an agenda item in competition planner.';

  @override
  String get currentAgendaItemIsNotFinishedYet =>
      'The current agenda item is not finished yet. Do you want to go forward anyway?';

  @override
  String get startExclamationMark => 'Start!';

  @override
  String get additionalIntegral => 'Additional integral';

  @override
  String get doYouReallyWantToFinishThisQualificationRound =>
      'Do you really want to finish this qualification round?';

  @override
  String get qualificationRoundFinished => 'Qualification round finished';

  @override
  String get chooseASpareIntegral => 'Choose a tiebreaker integral';

  @override
  String get choose => 'Choose';

  @override
  String copyrightNotice(Object year) {
    return 'Software developed in Heidelberg (MIT license, $year)';
  }

  @override
  String comingUpTitle(Object title) {
    return 'Coming up: $title';
  }

  @override
  String get nextIntegralComingUp => 'Next integral coming up';

  @override
  String aVsB(Object a, Object b) {
    return '$a vs. $b';
  }

  @override
  String exerciseNumber(Object number) {
    return 'Exercise $number';
  }

  @override
  String extraExerciseNumber(Object extra, Object number) {
    return 'Exercise $number+$extra';
  }

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 5 characters';

  @override
  String get passwordTooLong => 'Password must be at most 25 characters';

  @override
  String get authentication => 'Authentication';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get register => 'Register';

  @override
  String get login => 'Login';

  @override
  String get missionControl => 'Mission Control';

  @override
  String get competitionPlanner => 'Competition planner';

  @override
  String get integrals => 'Integrals';

  @override
  String get settings => 'Settings';

  @override
  String get choosePresentation => 'Choose presentation';

  @override
  String get mainPresentation => 'Main presentation';

  @override
  String get sidePresentation => 'Side presentation';

  @override
  String get latexBabelLanguage => 'english';

  @override
  String get integralListConfidential => 'Integral list (CONFIDENTIAL)';

  @override
  String get qualificationRound => 'Qualification round';

  @override
  String get knockoutRound => 'Knockout round';

  @override
  String get turnAroundWhenInstructed =>
      'Please only turn around when instructed!';

  @override
  String get integralNumberPrint => 'Integral No.';

  @override
  String get qualificationTestSolutions => 'Qualification test solutions';

  @override
  String get exerciseNumberPrint => 'Exercise';

  @override
  String get qualificationTest => 'Qualification test';

  @override
  String get remarksOnTheTest => 'Remarks on the test -- please read carefully';

  @override
  String get goodLuck => 'Good luck!';

  @override
  String get remarksColon => 'Remarks:';

  @override
  String get remarks => 'Remarks';

  @override
  String get language => 'Language';

  @override
  String get notSpecifiedYet => 'Not specified yet';

  @override
  String get text => 'Text';

  @override
  String get video => 'Video';

  @override
  String get yes => 'Yes';

  @override
  String get clickBoxToEdit => '(Click box to edit)';

  @override
  String get editTournamentTreeEntry => 'Edit entry';

  @override
  String get save => 'Save';

  @override
  String get videoPlaceholder => 'Video placeholder';

  @override
  String get comingUp => 'Coming up';

  @override
  String get customization => 'Customization';

  @override
  String get competitionName => 'Competition name';

  @override
  String get competitionNameColon => 'Competition name:';

  @override
  String get appName => 'Integration Bee Helper';

  @override
  String get logoColon => 'Logo:';

  @override
  String get backgroundColon => 'Background:';

  @override
  String get uploadImage => 'Upload';

  @override
  String get confirm => 'Confirm';

  @override
  String get addCompetitor => 'Add competitor';

  @override
  String get spareQuestionMark => 'Tiebreaker?';

  @override
  String get allocatedQuestionMark => 'Allocated?';

  @override
  String get usedQuestionMark => 'Used?';

  @override
  String get addIntegral => 'Add integral';

  @override
  String get editIntegral => 'Edit integral';

  @override
  String get imageColon => 'Image:';

  @override
  String get selectIntegral => 'Select integral';

  @override
  String get tagsColon => 'Tags:';

  @override
  String get addTag => 'Add tag';

  @override
  String get tag => 'Tag';

  @override
  String get exportFilenameZip => 'integration_bee_documents.zip';

  @override
  String get exportFilenameKnockout => 'ONE-SIDED_BW_knockout.tex';

  @override
  String get exportFilenameQualification => 'DOUBLE-SIDED_BW_qualification.tex';

  @override
  String get exportFilenameTest => 'DOUBLE-SIDED_BW_qualification_test.tex';

  @override
  String get exportFilenameSolution =>
      'DOUBLE-SIDED_BW_qualification_test_solution.tex';

  @override
  String get exportFilenameList => 'DOUBLE-SIDED_BW_integrals_list.tex';
}
