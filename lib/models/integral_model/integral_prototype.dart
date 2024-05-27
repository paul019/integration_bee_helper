import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';

class IntegralPrototype {
  final LatexExpression latexProblem;
  final LatexExpression latexSolution;
  final IntegralType type;
  final String name;
  final String youtubeVideoId;

  IntegralPrototype({
    required this.latexProblem,
    required this.latexSolution,
    required this.type,
    required this.name,
    required this.youtubeVideoId,
  });
}