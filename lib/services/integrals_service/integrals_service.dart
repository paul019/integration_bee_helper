import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/current_integral_wrapper.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_prototype.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/agenda_items_service/agenda_items_service.dart';

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
        .orderBy('createdAt')
        .snapshots()
        .map(_integralListFromFirebase);
  }

  Stream<CurrentIntegralWrapper>? onCurrentIntegralChanged({
    required String? integralCode,
  }) {
    if (integralCode == null) return null;

    return _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('code', isEqualTo: integralCode)
        .limit(1)
        .snapshots()
        .map(
          (res) =>
              res.docs.isEmpty ? null : _integralFromFirebase(res.docs.first),
        )
        .map((item) => CurrentIntegralWrapper(item));
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

  Future<List<IntegralModel>> getIntegralsByCodes({required List<String> codes}) async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('code', whereIn: codes)
        .get();

    final unsortedList = _integralListFromFirebase(response);
    final List<IntegralModel> sortedList = [];

    for (var code in codes) {
      for (var integral in unsortedList) {
        if (integral.code == code) {
          sortedList.add(integral);
          break;
        }
      }
    }

    return sortedList;
  }

  Future<List<IntegralModel>> getAllIntegrals() async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .get();

    return _integralListFromFirebase(response);
  }

  Future<List<IntegralModel>> getUsedIntegrals() async {
    final response = await _firestore
        .collection('integrals')
        .where('uid', isEqualTo: _uid)
        .where('alreadyUsed', isEqualTo: true)
        .get();

    return _integralListFromFirebase(response);
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
      latexProblem: LatexExpression(""),
      latexSolution: LatexExpression(""),
      type: IntegralType.regular,
      name: "",
      alreadyUsed: false,
      agendaItemIds: [],
      youtubeVideoId: "",
    );

    // Add integral:
    await IntegralModel.collection.add(integral.toJson());
  }

  Future<List<String>> addBulk({required List<IntegralPrototype> integrals}) async {
    final currentIntegrals = await getAllIntegrals();
    final batch = _firestore.batch();

    final List<String> integralCodes = [];
    var i = 0;

    for (var integralPrototype in integrals) {
      final code = _createIntegralCode(currentIntegrals: currentIntegrals);
      integralCodes.add(code);

      final IntegralModel integral = IntegralModel(
        uid: _uid,
        code: code,
        createdAt: DateTime.now().add(Duration(seconds: i)),
        latexProblem: integralPrototype.latexProblem,
        latexSolution: integralPrototype.latexSolution,
        type: integralPrototype.type,
        name: integralPrototype.name,
        alreadyUsed: false,
        agendaItemIds: [],
        youtubeVideoId: integralPrototype.youtubeVideoId,
      );

      currentIntegrals.add(integral);

      batch.set(IntegralModel.collection.doc(), integral.toJson());

      i++;
    }

    await batch.commit();
    return integralCodes;
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
    // Check if integral is used in an agenda item:
    final agendaItem =
        await AgendaItemsService().getAgendaItemByIntegralCode(integral.code);
    if (agendaItem != null) {
      throw Exception(
        'Integral is used in agenda item number ${agendaItem.orderIndex + 1}. For this reason, it cannot be deleted.',
      );
    }

    await integral.reference.delete();
  }

  Future editIntegral(
    IntegralModel integral, {
    required LatexExpression latexProblem,
    required LatexExpression latexSolution,
    required String name,
    required IntegralType type,
    required String youtubeVideoId,
  }) async {
    await integral.reference.update({
      'latexProblem': latexProblem.raw,
      'latexSolution': latexSolution.raw,
      'name': name,
      'type': type.id,
      'youtubeVideoId': youtubeVideoId,
    });
  }

  Future setIntegralToUsed(String code) async {
    final integral = await getIntegral(code: code);

    await integral.reference.update({
      'alreadyUsed': true,
    });
  }

  Future resetUsedIntegrals(WriteBatch batch) async {
    final integrals = await getUsedIntegrals();

    for (var integral in integrals) {
      batch.update(integral.reference, {
        'alreadyUsed': false,
      });
    }
  }
}
