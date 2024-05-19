import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';

class IntegralModel {
  final String? id;
  final String uid;
  final String code;
  final DateTime createdAt;
  final LatexExpression latexProblem;
  final LatexExpression latexSolution;
  final IntegralType type;
  final String name;
  final bool alreadyUsed;
  final List<String> agendaItemIds;

  IntegralModel({
    this.id,
    required this.uid,
    required this.code,
    required this.createdAt,
    required this.latexProblem,
    required this.latexSolution,
    required this.type,
    required this.name,
    required this.alreadyUsed,
    required this.agendaItemIds,
  });

  factory IntegralModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) =>
      IntegralModel(
        id: id,
        uid: json['uid'],
        code: json['code'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        latexProblem: LatexExpression(json['latexProblem']),
        latexSolution: LatexExpression(json['latexSolution']),
        type: IntegralType.fromString(json['type']),
        name: json['name'] ?? '',
        alreadyUsed: json['alreadyUsed'] ?? false,
        agendaItemIds:
            (json['agendaItemIds'] as List).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'code': code,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'latexProblem': latexProblem.raw,
        'latexSolution': latexSolution.raw,
        'type': type.id,
        'name': name,
        'alreadyUsed': alreadyUsed,
        'agendaItemIds': agendaItemIds,
      };

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('integrals');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id!);

  LatexExpression get latexProblemAndSolution =>
      LatexExpression('${latexProblem.raw}=\\boxed{${latexSolution.raw}}');
}
