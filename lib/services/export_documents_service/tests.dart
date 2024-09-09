part of 'export_documents_service.dart';

extension GenerateTests on ExportDocumentsService {
  Future<TextFile?> _generateTests(
    BuildContext context, {
    required List<AgendaItemModelTest> tests,
    required List<IntegralModel> allIntegrals,
  }) async {
    final List<String> commands = [];

    for (var test in tests) {
      for (var competitorName in test.competitorNames) {
        commands.add(
          '\\coverSheet{${test.title}}{${test.remarksFormatted}}{$competitorName}',
        );

        var i = 0;

        for (var integralCode in test.integralsCodes) {
          final integral = allIntegrals.firstWhere(
            (integral) => integral.code == integralCode,
          );
          commands.add('\\hrulefill');
          commands.add(
            '\\singlet{${i + 1}}{${integral.latexProblem.transformed}}{${integral.name}}',
          );

          if (i % 3 == 2) {
            commands.add('\\hrulefill');
            commands.add('\\newpage');
          }

          i++;
        }

        if ((i - 1) % 3 != 2) {
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
    file = file
        .makeReplacement(
            oldText: '<exercise>', newText: MyIntl.of(context).exerciseNumberPrint)
        .makeReplacement(
            oldText: '<instruction-text>',
            newText: MyIntl.of(context).turnAroundWhenInstructed)
        .makeReplacement(
            oldText: '<competition-title>',
            newText: 'Heidelberg Integration Bee 2024')
        .makeReplacement(
            oldText: '<remarks>', newText: MyIntl.of(context).remarksOnTheTest)
        .makeReplacement(oldText: '<good-luck>', newText: MyIntl.of(context).goodLuck)
        .makeReplacement(newText: commands.join('\n'));

    return file;
  }
}
