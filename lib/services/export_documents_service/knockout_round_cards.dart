part of 'export_documents_service.dart';

extension GenerateKnockoutRoundCards on ExportDocumentsService {
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
      partialCommands.add('{Empty}{}');
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
}
