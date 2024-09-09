import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/list_extension.dart';
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
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

part 'knockout_round_cards.dart';
part 'qualification_round_sheets.dart';
part 'tests.dart';
part 'integrals_list.dart';
part 'tests_solutions.dart';

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

    futures.add(_generateTestsSolutions(
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

  String _transformTitle(String title) {
    return title.replaceAll('#', '\\#');
  }
}
