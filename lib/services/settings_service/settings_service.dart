import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';

class SettingsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get _uid => _firebaseAuth.currentUser!.uid;

  SettingsModel? _settingsFromFirebase(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    if (doc.data() != null) {
      return SettingsModel.fromJson(doc.data()!, uid: doc.id);
    } else {
      return null;
    }
  }

  Stream<SettingsModel?> get onSettingsChanged {
    return SettingsModel.collection
        .doc(_uid)
        .snapshots()
        .map(_settingsFromFirebase);
  }

  Future createSettings({required String uid}) async {
    await SettingsModel.collection.doc(uid).set(SettingsModel.minimalJson);
  }

  Future edit({
    TournamentTreeModel? tournamentTree,
  }) async {
    await SettingsModel.collection.doc(_uid).update({
          "tournamentTree": tournamentTree?.encode(),
        }.deleteNullEntries());
  }
}
