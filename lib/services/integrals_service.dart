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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_integralListFromFirebase);
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
    await _firestore.collection('integrals').add(integral.toJson());
  }

  Future deleteIntegral(IntegralModel integral) async {
    await _firestore.collection('integrals').doc(integral.id!).delete();
  }

  Future editIntegral(
    String integralId, {
    required String latexProblem,
    required String latexSolution,
    required IntegralLevel level,
  }) async {
    await _firestore.collection('integrals').doc(integralId).update({
      'latexProblem': latexProblem,
      'latexSolution': latexSolution,
      'level': level.id,
    });
  }
}
