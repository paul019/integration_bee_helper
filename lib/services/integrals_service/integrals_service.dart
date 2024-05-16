import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/models/integral_model/integral_level.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';

class IntegralsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get _uid => _firebaseAuth.currentUser!.uid;
  final _random = Random();

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
        .where('uid', isEqualTo: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_integralListFromFirebase);
  }

  Stream<List<IntegralModel>> get onUsedIntegralsChanged {
    return _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('alreadyUsed', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_integralListFromFirebase);
  }

  Future<IntegralModel> getIntegral({required String code}) async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    return _integralFromFirebase(response.docs.first)!;
  }

  Future<List<IntegralModel>> getUnusedIntegrals() async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('alreadyUsed', isEqualTo: false)
        .get();

    return _integralListFromFirebase(response);
  }

  void addIntegral({required List<IntegralModel> currentIntegrals}) async {
    // Create integral:
    final integral = IntegralModel(
      uid: _uid,
      code: _createIntegralCode(currentIntegrals: currentIntegrals),
      createdAt: DateTime.now(),
      latexProblem: "",
      latexSolution: "",
      level: IntegralLevel.standard,
      type: IntegralType.regular,
      name: "",
      alreadyUsed: false,
    );

    // Add integral:
    await IntegralModel.collection.add(integral.toJson());
  }

  String _createIntegralCode({required List<IntegralModel> currentIntegrals}) {
    String code = "";
    while (code == "") {
      final randomNumber = _random.nextInt(10000);
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

    return code;
  }

  Future deleteIntegral(IntegralModel integral) async {
    await integral.reference.delete();
  }

  Future editIntegral(
    IntegralModel integral, {
    required String latexProblem,
    required String latexSolution,
    required IntegralLevel level,
    required String name,
  }) async {
    await integral.reference.update({
      'latexProblem': latexProblem,
      'latexSolution': latexSolution,
      'level': level.id,
      'name': name,
    });
  }

  Future setIntegralToUsed(IntegralModel integral) async {
    await integral.reference.update({
      'alreadyUsed': true,
    });
  }

  Future resetUsedIntegrals(List<IntegralModel> integrals) async {
    for (var integral in integrals) {
      await integral.reference.update({
        'alreadyUsed': false,
      });
    }
  }
}
