import 'package:integration_bee_helper/services/basic_services/latex_transformer.dart';

class LatexExpression {
  final String raw;

  LatexExpression(this.raw);

  String get transformed => LatexTransformer.transform(raw);
  String get transformedWithDollarSigns => LatexTransformer.transformWithDollarSigns(raw);
}
