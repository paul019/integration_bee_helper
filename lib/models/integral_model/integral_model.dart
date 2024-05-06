import 'package:cloud_firestore/cloud_firestore.dart';

class IntegralModel {
  final String? id;
  final String uid;
  final String code;
  final DateTime createdAt;
  final String latexProblem;
  final String latexSolution;
  final IntegralLevel level;
  final String name;
  final bool alreadyUsedAsSpareIntegral;

  IntegralModel({
    this.id,
    required this.uid,
    required this.code,
    required this.createdAt,
    required this.latexProblem,
    required this.latexSolution,
    required this.level,
    required this.name,
    required this.alreadyUsedAsSpareIntegral,
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
        level: IntegralLevel.fromString(json['level']),
        name: json['name'] ?? '',
        alreadyUsedAsSpareIntegral: json['alreadyUsedAsSpareIntegral'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'code': code,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'latexProblem': latexProblem,
        'latexSolution': latexSolution,
        'level': level.id,
        'name': name,
        'alreadyUsedAsSpareIntegral': alreadyUsedAsSpareIntegral,
      };

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('integrals');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id!);
}

enum IntegralLevel {
  bachelor('bachelor'),
  master('master');

  static IntegralLevel standard = IntegralLevel.bachelor;

  const IntegralLevel(this.id);
  final String id;

  factory IntegralLevel.fromString(String id) {
    var level = bachelor;

    for (var element in IntegralLevel.values) {
      if (id == element.id) {
        level = element;
      }
    }

    return level;
  }
}