part of 'export_documents_service.dart';

extension GenerateIntegralsList on ExportDocumentsService {
  Future<TextFile> _generateIntegralsList(
    BuildContext context, {
    required String eventName,
    required List<AgendaItemModelLiveCompetition> agendaItems,
    required List<IntegralModel> allIntegrals,
    required String filename,
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
        if (integral.name != '' || integral.youtubeVideoId != '') {
          final parts = [
            integral.name,
            integral.youtubeVideoId != '' ? 'mit Video' : '',
          ].deleteEmptyEntries();

          commands.add(
            '\\integralName{${parts.join(' -- ')}}',
          );
        }
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
        if (integral.name != '') {
          commands.add(
            '\\integralName{${integral.name}}',
          );
        }
      }
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/integrals_list.tex',
      displayFileName: 'DOPPELSEITIG_SW_integral_liste.tex',
    );
    file = file
        .makeReplacement(
            oldText: '<babel-language>', newText: MyIntl.of(context).latexBabelLanguage)
        .makeReplacement(
            oldText: '<title>', newText: MyIntl.of(context).integralListConfidential)
        .makeReplacement(
            oldText: '<qualification-round>',
            newText: MyIntl.of(context).qualificationRound)
        .makeReplacement(
            oldText: '<knockout-round>', newText: MyIntl.of(context).knockoutRound)
        .makeReplacement(
            oldText: '<spare-integrals>', newText: MyIntl.of(context).spareIntegrals)
        .makeReplacement(newText: commands.join('\n'));

    return file;
  }
}
