import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_live_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_test.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/basic_models/text_file.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';
import 'package:integration_bee_helper/services/basic_services/download_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

class ExportDocumentsService {
  Future<void> exportDocuments(BuildContext context) async {
    final agendaItems = await AgendaItemsService().getCompetitionAgendaItems();
    final allIntegrals = await IntegralsService().getAllIntegrals();

    if (context.mounted) {
      _exportDocuments(
        context,
        agendaItems: agendaItems,
        allIntegrals: allIntegrals,
      );
    }
  }

  Future<void> _exportDocuments(
    BuildContext context, {
    String eventName = 'Heidelberg Integration Bee 2024', // TODO
    required List<AgendaItemModelCompetition> agendaItems,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<Future<TextFile?>> futures = [];

    futures.add(_generateKnockoutRoundCards(
      context,
      knockoutRounds: agendaItems.whereType<AgendaItemModelKnockout>().toList(),
      allIntegrals: allIntegrals,
    ));

    futures.add(_generateQualificationRoundSheets(
      context,
      qualificationRounds:
          agendaItems.whereType<AgendaItemModelQualification>().toList(),
      allIntegrals: allIntegrals,
    ));

    futures.add(_generateTests(
      context,
      tests: agendaItems.whereType<AgendaItemModelTest>().toList(),
      allIntegrals: allIntegrals,
    ));

    futures.add(_generateIntegralsList(
      context,
      agendaItems:
          agendaItems.whereType<AgendaItemModelLiveCompetition>().toList(),
      allIntegrals: allIntegrals,
    ));

    final textFiles = await Future.wait(futures);

    await DownloadService().downloadFilesAsZIP(
      files: textFiles.whereType<TextFile>().toList(),
      zipFileName: 'integration_bee_documents.zip',
    );
  }

  Future<TextFile?> _generateKnockoutRoundCards(
    BuildContext context, {
    required List<AgendaItemModelKnockout> knockoutRounds,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<String> partialCommands = [];
    final Set<String> usedIntegralCodes = {};

    // Construct partial commands:
    for (var knockoutRound in knockoutRounds) {
      for (var integralCode in knockoutRound.integralsCodes) {
        final latex = allIntegrals
            .firstWhere((integral) => integral.code == integralCode)
            .latexProblem;

        usedIntegralCodes.add(integralCode);

        // Add twice:
        for (var i = 0; i < 2; i++) {
          partialCommands.add(
            '{$integralCode \\hfill ${_transformTitle(knockoutRound.title)}}{${latex.transformed}}',
          );
        }
      }
    }

    // Add spare integrals:
    final Set<String> allSpareIntegralCodes = allIntegrals
        .where((integral) => integral.type == IntegralType.spare)
        .map((integral) => integral.code)
        .toSet();
    final Set<String> unusedSpareIntegralCodes =
        allSpareIntegralCodes.difference(usedIntegralCodes);

    for (var integralCode in unusedSpareIntegralCodes) {
      final latex = allIntegrals
          .firstWhere((integral) => integral.code == integralCode)
          .latexProblem;

      // Add twice:
      for (var i = 0; i < 2; i++) {
        partialCommands
            .add('{$integralCode \\hfill Tiebreaker}{${latex.transformed}}');
      }
    }

    if (partialCommands.isEmpty) {
      return null;
    }

    // Add empty commands to make the number of commands a multiple of 4:
    while (partialCommands.length % 4 != 0) {
      partialCommands.add('{Leer}{}');
    }

    // Construct final commands:
    final List<String> commands = [];

    for (var i = 0; i < partialCommands.length; i += 4) {
      var command = r'\quartet';

      for (var j = 0; j < 4; j++) {
        command += partialCommands[i + j];
      }

      commands.add(command);
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/knockout_round_cards.tex',
      displayFileName: 'EINSEITIG_SW_knockout.tex',
    );
    file = file.makeReplacement(newText: commands.join('\n'));

    return file;
  }

  Future<TextFile?> _generateQualificationRoundSheets(
    BuildContext context, {
    required List<AgendaItemModelQualification> qualificationRounds,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<String> commands = [];

    // Regular integrals:
    for (var qualificationRound in qualificationRounds) {
      for (var integralCode in qualificationRound.integralsCodes) {
        final latex = allIntegrals
            .firstWhere((integral) => integral.code == integralCode)
            .latexProblem;

        for (var competitorName in qualificationRound.competitorNames) {
          commands.add(
            '\\singlet{$integralCode}{${_transformTitle(qualificationRound.title)}}{$competitorName}{${latex.transformed}}',
          );
        }
      }
    }

    // Spare integrals:
    final Set<String> spareIntegralCodes = {};
    var maxNumberOfCompetitors = 0;

    for (var qualificationRound in qualificationRounds) {
      spareIntegralCodes.addAll(qualificationRound.spareIntegralsCodes);

      if (qualificationRound.numOfCompetitors > maxNumberOfCompetitors) {
        maxNumberOfCompetitors = qualificationRound.numOfCompetitors;
      }
    }

    for (var integralCode in spareIntegralCodes) {
      final latex = allIntegrals
          .firstWhere((integral) => integral.code == integralCode)
          .latexProblem;

      for (var i = 0; i < maxNumberOfCompetitors; i++) {
        commands.add(
          '\\singlet{$integralCode}{Tiebreaker}{}{${latex.transformed}}',
        );
      }
    }

    if (commands.isEmpty) {
      return null;
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/qualification_round_sheets.tex',
      displayFileName: 'DOPPELSEITIG_SW_qualifikation.tex',
    );
    file = file.makeReplacement(newText: commands.join('\n'));

    return file;
  }

  Future<TextFile?> _generateTests(
    BuildContext context, {
    required List<AgendaItemModelTest> tests,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<String> commands = [];

    for (var test in tests) {
      for (var competitorName in test.competitorNames) {
        commands.add(
          '\\coverSheet{$competitorName}',
        );

        var i = 0;

        for (var integralCode in test.integralsCodes) {
          final integral = allIntegrals.firstWhere(
            (integral) => integral.code == integralCode,
          );
          commands.add('\\hrulefill');
          commands.add(
            '\\singlet{${i + 1}}{${integral.latexProblem.transformed}}',
          );

          if (i % 3 == 2) {
            commands.add('\\hrulefill');
            commands.add('\\newpage');
          }

          i++;
        }

        if (i % 3 != 2) {
          commands.add('\\hrulefill');
        }

        commands.add('\\points{${test.numOfIntegrals}}');
      }
    }

    if (commands.isEmpty) {
      return null;
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/qualification_test.tex',
      displayFileName: 'DOPPELSEITIG_SW_qualifikations_test.tex',
    );
    file = file.makeReplacement(newText: commands.join('\n'));

    return file;
  }

  Future<TextFile> _generateIntegralsList(
    BuildContext context, {
    String eventName = 'Heidelberg Integration Bee 2024', //TODO
    required List<AgendaItemModelLiveCompetition> agendaItems,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<String> commands = [
      '\\mainTitle{$eventName}',
    ];

    for (var agendaItem in agendaItems) {
      switch (agendaItem.type) {
        case AgendaItemType.qualification:
          commands.add(
            '\\qualificationRoundTitle{${_transformTitle(agendaItem.title)}}',
          );
          break;
        case AgendaItemType.knockout:
          commands.add(
            '\\knockoutRoundTitle{${_transformTitle(agendaItem.title)}}',
          );
          break;
        default:
          throw Error();
      }

      // Regular integrals:
      for (var integralCode in agendaItem.integralsCodes) {
        final integral = allIntegrals.firstWhere(
          (integral) => integral.code == integralCode,
        );
        commands.add(
          '\\integral{${integral.code}}{${integral.latexProblemAndSolution.transformed}}',
        );
      }

      if (agendaItem.spareIntegralsCodes.isNotEmpty) {
        commands.add(
          '\\titleSpareIntegrals',
        );
      }

      // Spare integrals:
      for (var integralCode in agendaItem.spareIntegralsCodes) {
        final integral = allIntegrals.firstWhere(
          (integral) => integral.code == integralCode,
        );
        commands.add(
          '\\integral{${integral.code}}{${integral.latexProblemAndSolution.transformed}}',
        );
      }
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/integrals_list.tex',
      displayFileName: 'DOPPELSEITIG_SW_integral_liste.tex',
    );
    file = file.makeReplacement(newText: commands.join('\n'));

    return file;
  }

  String _transformTitle(String title) {
    return title.replaceAll('#', '\\#');
  }
}
