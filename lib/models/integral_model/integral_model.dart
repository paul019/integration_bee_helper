import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';

class IntegralModel {
  final String? id;
  final String uid;
  final String code;
  final DateTime createdAt;
  final String latexProblem;
  final String latexSolution;
  final IntegralType type;
  final String name;
  final bool alreadyUsed;

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
        latexProblem: json['latexProblem'],
        latexSolution: json['latexSolution'],
        type: IntegralType.fromString(json['type']),
        name: json['name'] ?? '',
        alreadyUsed: json['alreadyUsed'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'code': code,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'latexProblem': latexProblem,
        'latexSolution': latexSolution,
        'type': type.id,
        'name': name,
        'alreadyUsed': alreadyUsed,
      };

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('integrals');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id!);
}
