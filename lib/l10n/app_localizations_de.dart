// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String agendaItemNumber(Object number) {
    return 'Programmpunkt #$number';
  }

  @override
  String get doYouReallyWantToDeleteThisAgendaItem =>
      'Möchtest du wirklich diesen Programmpunkt löschen?';

  @override
  String get doYouReallyWantToForceStartThisAgendaItem =>
      'Möchtest du diesen Programmpunkt wirklich erzwingen?';

  @override
  String get titleColon => 'Titel:';

  @override
  String get titleOptional => 'Titel (optional)';

  @override
  String get competitor1 => 'Teilnehmer 1';

  @override
  String get competitor2 => 'Teilnehmer 2';

  @override
  String get integralsColon => 'Integrale:';

  @override
  String get codes => 'Codes';

  @override
  String get timeLimitColon => 'Zeitlimit:';

  @override
  String get durationInSeconds => 'Dauer in Sekunden';

  @override
  String get spareIntegralsColon => 'Tiebreaker-Integrale:';

  @override
  String get codesOptional => 'Codes (optional)';

  @override
  String get competitorsColon => 'Teilnehmer:';

  @override
  String get competitors => 'Teilnehmer';

  @override
  String get integralColon => 'Integral:';

  @override
  String get codesRequired => 'Codes (erforderlich)';

  @override
  String get title => 'Titel';

  @override
  String get subtitleColon => 'Untertitel:';

  @override
  String get subtitle => 'Untertitel';

  @override
  String get imageUrlColon => 'Bild-URL:';

  @override
  String get imageUrl => 'Bild-URL';

  @override
  String get youtubeVideoIdColon => 'YouTube-Video-ID:';

  @override
  String get doYouReallyWantToStartFromTheBeginning =>
      'Möchtest du wirklich von vorne beginnen?';

  @override
  String get doYouReallyWantToReset => 'Möchtest du wirklich zurücksetzen?';

  @override
  String get startFromBeginning => 'Von vorne beginnen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get downloadDocuments => 'Dokumente herunterladen';

  @override
  String get noAgendaItemsYet => 'Noch keine Programmpunkte.';

  @override
  String integralNumber(Object number) {
    return 'Integral #$number';
  }

  @override
  String get nameOptional => 'Name (optional)';

  @override
  String get doYouReallyWantToDeleteThisIntegral =>
      'Möchtest du dieses Integral wirklich löschen?';

  @override
  String get codeCopiedToClipboard => 'Code in die Zwischenablage kopiert';

  @override
  String get spareIntegralQuestionMark => 'Tiebreaker-Integral?';

  @override
  String get problemLatex => 'Aufgabe (LaTeX)';

  @override
  String get solutionLatex => 'Lösung (LaTeX)';

  @override
  String get youtubeVideoID => 'YouTube-Video-ID';

  @override
  String get youtubeVideoIDOptional => 'YouTube-Video-ID (optional)';

  @override
  String get integralsAdded => 'Integrale hinzugefügt';

  @override
  String codesList(Object codes) {
    return 'Codes: $codes';
  }

  @override
  String get codesCopiedToClipboard => 'Codes in die Zwischenablage kopiert';

  @override
  String get copyCodes => 'Codes kopieren';

  @override
  String get close => 'Schließen';

  @override
  String get importIntegrals => 'Integrale importieren';

  @override
  String get import => 'Importieren';

  @override
  String get tournamentTree => 'Turnierbaum';

  @override
  String get preview => 'Vorschau';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get allIntegralTypes => 'Alle Integral-Typen';

  @override
  String get regularIntegrals => 'Reguläre Integrale';

  @override
  String get spareIntegrals => 'Tiebreaker-Integrale';

  @override
  String get allIntegrals => 'Alle Integrale';

  @override
  String get allocatedIntegrals => 'Zugewiesene Integrale';

  @override
  String get unallocatedIntegrals => 'Nicht zugewiesene Integrale';

  @override
  String get usedIntegrals => 'Verwendete Integrale';

  @override
  String get unusedIntegrals => 'Unverwendete Integrale';

  @override
  String get noIntegralsYet => 'Noch keine Integrale.';

  @override
  String get noIntegralsMatchTheFilter =>
      'Keine Integrale entsprechen den Filtern.';

  @override
  String get resetFilters => 'Filter zurücksetzen';

  @override
  String get start => 'Start';

  @override
  String get resumeTimer => 'Timer fortsetzen';

  @override
  String get pauseTimer => 'Timer pausieren';

  @override
  String get doYouReallyWantToShowTheSolution =>
      'Möchtest du wirklich die Lösung anzeigen?';

  @override
  String get showSolution => 'Lösung anzeigen';

  @override
  String personWins(Object person) {
    return '$person gewinnt';
  }

  @override
  String get draw => 'Unentschieden';

  @override
  String get cannotEditFinishedAgendaItem =>
      'Kann abgeschlossenen Programmpunkt nicht bearbeiten';

  @override
  String get nextIntegral => 'Nächstes Integral';

  @override
  String get doYouReallyWantToGoBack => 'Möchtest du wirklich zurückgehen?';

  @override
  String get noActiveAgendaItem => 'Kein aktiver Programmpunkt';

  @override
  String get pleaseChooseAnAgendaItemInCompetitionPlanner =>
      'Bitte wähle einen Programmpunkt im Wettkampfplaner';

  @override
  String get currentAgendaItemIsNotFinishedYet =>
      'Der aktuelle Programmpunkt ist noch nicht abgeschlossen. Möchtest du trotzdem fortfahren?';

  @override
  String get startExclamationMark => 'Start!';

  @override
  String get additionalIntegral => 'Zusätzliches Integral';

  @override
  String get doYouReallyWantToFinishThisQualificationRound =>
      'Möchtest du diese Qualifikationsrunde wirklich beenden?';

  @override
  String get qualificationRoundFinished => 'Qualifikationsrunde beendet';

  @override
  String get chooseASpareIntegral => 'Wähle ein Ersatz-Integral';

  @override
  String get choose => 'Wählen';

  @override
  String copyrightNotice(Object year) {
    return 'Software entwickelt in Heidelberg (MIT-Lizenz, $year)';
  }

  @override
  String comingUpTitle(Object title) {
    return 'Als nächstes: $title';
  }

  @override
  String get nextIntegralComingUp => 'Nächste Aufgabe...';

  @override
  String aVsB(Object a, Object b) {
    return '$a vs. $b';
  }

  @override
  String exerciseNumber(Object number) {
    return 'Aufgabe $number';
  }

  @override
  String extraExerciseNumber(Object extra, Object number) {
    return 'Aufgabe $number+$extra';
  }

  @override
  String get pleaseEnterAValidEmail =>
      'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 5 Zeichen lang sein';

  @override
  String get passwordTooLong => 'Passwort darf maximal 25 Zeichen lang sein';

  @override
  String get authentication => 'Authentifizierung';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get register => 'Registrieren';

  @override
  String get login => 'Anmelden';

  @override
  String get missionControl => 'Kontrollzentrum';

  @override
  String get competitionPlanner => 'Wettkampfplaner';

  @override
  String get integrals => 'Integrale';

  @override
  String get settings => 'Einstellungen';

  @override
  String get choosePresentation => 'Präsentation wählen';

  @override
  String get mainPresentation => 'Hauptpräsentation';

  @override
  String get sidePresentation => 'Nebenpräsentation';

  @override
  String get latexBabelLanguage => 'ngerman';

  @override
  String get integralListConfidential => 'Integralliste (VERTRAULICH)';

  @override
  String get qualificationRound => 'Qualifikationsrunde';

  @override
  String get knockoutRound => 'K.o.-Runde';

  @override
  String get turnAroundWhenInstructed => 'Bitte erst auf Anweisung umdrehen!';

  @override
  String get integralNumberPrint => 'Integral Nr.';

  @override
  String get qualificationTestSolutions => 'Lösungen zum Qualifikations-Test';

  @override
  String get exerciseNumberPrint => 'Aufgabe';

  @override
  String get qualificationTest => 'Qualifikationstest';

  @override
  String get remarksOnTheTest => 'Hinweise -- bitte gründlich durchlesen:';

  @override
  String get goodLuck => 'Viel Erfolg!';

  @override
  String get remarksColon => 'Hinweise:';

  @override
  String get remarks => 'Hinweise';

  @override
  String get language => 'Sprache';

  @override
  String get notSpecifiedYet => 'Noch nicht festgelegt';

  @override
  String get text => 'Text';

  @override
  String get video => 'Video';

  @override
  String get yes => 'Ja';

  @override
  String get clickBoxToEdit => '(Box anklicken zum Bearbeiten)';

  @override
  String get editTournamentTreeEntry => 'Eintrag bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get videoPlaceholder => 'Video-Platzhalter';

  @override
  String get comingUp => 'Als nächstes';

  @override
  String get customization => 'Anpassung';

  @override
  String get competitionName => 'Wettkampfname';

  @override
  String get competitionNameColon => 'Wettkampfname:';

  @override
  String get appName => 'Integration Bee Helper';

  @override
  String get logoColon => 'Logo:';

  @override
  String get backgroundColon => 'Hintergrund:';

  @override
  String get uploadImage => 'Hochladen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get addCompetitor => 'Teilnehmer hinzufügen';

  @override
  String get spareQuestionMark => 'Tiebreaker?';

  @override
  String get allocatedQuestionMark => 'Zugewiesen?';

  @override
  String get usedQuestionMark => 'Verwendet?';

  @override
  String get addIntegral => 'Integral hinzufügen';

  @override
  String get editIntegral => 'Integral bearbeiten';

  @override
  String get imageColon => 'Bild:';

  @override
  String get selectIntegral => 'Integral auswählen';

  @override
  String get tagsColon => 'Tags:';

  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get tag => 'Tag';

  @override
  String get exportFilenameZip => 'integration_bee_documents.zip';

  @override
  String get exportFilenameKnockout => 'EINSEITIG_SW_knockout.tex';

  @override
  String get exportFilenameQualification => 'DOPPELSEITIG_SW_qualifikation.tex';

  @override
  String get exportFilenameTest => 'DOPPELSEITIG_SW_qualifikations_test.tex';

  @override
  String get exportFilenameSolution =>
      'DOPPELSEITIG_SW_qualifikations_test_loesung.tex';

  @override
  String get exportFilenameList => 'DOPPELSEITIG_SW_integral_liste.tex';
}
