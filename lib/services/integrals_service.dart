import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/integral_model.dart';

class IntegralsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final random = Random();
  final String uid;

  IntegralsService({required this.uid});

  IntegralModel? _integralFromFirebase(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    if (doc.data() != null) {
      return IntegralModel.fromJson(doc.data()!, id: doc.id);
    } else {
      return null;
    }
  }

  List<IntegralModel> _integralListFromFirebase(
    QuerySnapshot<Map<String, dynamic>> querySnapshot,
  ) {
    List<IntegralModel> list = [];

    for (var element in querySnapshot.docs) {
      final place = _integralFromFirebase(element);

      if (place != null) {
        list.add(place);
      }
    }

    return list;
  }

  Stream<List<IntegralModel>> get onIntegralsChanged {
    return _firestore
        .collection('integrals')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_integralListFromFirebase);
  }

  Future<IntegralModel> getIntegral({required String code}) async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: uid)
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    return _integralFromFirebase(response.docs.first)!;
  }

  void addIntegral({required List<IntegralModel> currentIntegrals}) async {
    // Find code for new integral:
    String code = "";
    while (code == "") {
      final randomNumber = random.nextInt(10000);
      code = randomNumber.toString();
      if (randomNumber < 10) {
        code = "0$code";
      }
      if (randomNumber < 100) {
        code = "0$code";
      }
      if (randomNumber < 1000) {
        code = "0$code";
      }

      for (var integral in currentIntegrals) {
        if (integral.code == code) {
          code = "";
          break;
        }
      }
    }

    // Create integral:
    final integral = IntegralModel(
      uid: uid,
      code: code,
      createdAt: DateTime.now(),
      latexProblem: "",
      latexSolution: "",
      level: IntegralLevel.standard,
    );

    // Add integral:
    await IntegralModel.collection.add(integral.toJson());
  }

  Future deleteIntegral(IntegralModel integral) async {
    await integral.reference.delete();
  }

  Future editIntegral(
    IntegralModel integral, {
    required String latexProblem,
    required String latexSolution,
    required IntegralLevel level,
  }) async {
    await integral.reference.update({
      'latexProblem': latexProblem,
      'latexSolution': latexSolution,
      'level': level.id,
    });
  }
}
