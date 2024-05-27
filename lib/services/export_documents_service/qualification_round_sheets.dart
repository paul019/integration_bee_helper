part of 'export_documents_service.dart';

extension GenerateQualificationRoundSheets on ExportDocumentsService{
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
}