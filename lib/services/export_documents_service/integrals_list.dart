part of 'export_documents_service.dart';

extension GenerateIntegralsList on ExportDocumentsService {
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
        if (integral.name != '') {
          commands.add(
            '\\integralName{${integral.name}}',
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
    file = file.makeReplacement(newText: commands.join('\n'));

    return file;
  }

  String _transformTitle(String title) {
    return title.replaceAll('#', '\\#');
  }
}
