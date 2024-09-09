part of 'export_documents_service.dart';

extension GenerateTestsSolutions on ExportDocumentsService {
  Future<TextFile?> _generateTestsSolutions(
    BuildContext context, {
    String eventName = 'Heidelberg Integration Bee 2024', //TODO
    required List<AgendaItemModelTest> tests,
    required List<IntegralModel> allIntegrals,
  }) async {
    if (tests.isEmpty) {
      return null;
    }

    final List<String> commands = [
      '\\mainTitle{$eventName}',
    ];

    for (var test in tests) {
      if (tests.length > 1) {
        commands.add(
          '\\testTitle{${_transformTitle(test.title)}}',
        );
      }

      // Regular integrals:
      for (var (i, integralCode) in test.integralsCodes.indexed) {
        final integral = allIntegrals.firstWhere(
          (integral) => integral.code == integralCode,
        );
        commands.add(
          '\\integral{${i + 1}}{${integral.latexProblemAndSolution.transformed}}{${integral.name}}',
        );
      }
    }

    var file = await TextFile.fromAsset(
      context,
      assetFileName: 'latex/qualification_test_solutions.tex',
      displayFileName: 'DOPPELSEITIG_SW_qualifikations_test_loesung.tex',
    );
    file = file
        .makeReplacement(
            oldText: '<qualification-test-solutions>',
            newText: MyIntl.S.qualificationTestSolutions)
        .makeReplacement(
            oldText: '<exercise>', newText: MyIntl.S.exerciseNumberPrint)
        .makeReplacement(newText: commands.join('\n'));

    return file;
  }
}
