import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';
import 'package:integration_bee_helper/services/basic_services/storage_service.dart';

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

  Stream<SettingsModel?> onSettingsChanged(String uid) {
    return SettingsModel.collection
        .doc(uid)
        .snapshots()
        .map(_settingsFromFirebase);
  }

  Future createSettings({required String uid}) async {
    await SettingsModel.collection.doc(uid).set(SettingsModel.minimalJson);
  }

  Future edit({
    TournamentTreeModel? tournamentTree,
    String? languageCode,
    bool? screensSwitched,
    String? competitionName,
  }) async {
    await SettingsModel.collection.doc(_uid).update({
          "tournamentTree": tournamentTree?.encode(),
          "languageCode": languageCode,
          "screensSwitched": screensSwitched,
          "competitionName": competitionName,
        }.deleteNullEntries());
  }

  void uploadLogo({
    required XFile image,
    required Function(Exception) onError,
  }) {
    StorageService().uploadImage(
      image: image,
      filename: 'logo',
      onError: onError,
      onSuccess: (path, url) {
        SettingsModel.collection
            .doc(_uid)
            .update({"logoPath": path, "logoUrl": url});
      },
    );
  }

  void deleteLogo({
    required String path,
    required Function(Exception) onError,
  }) {
    StorageService().deleteImage(
      path: path,
      onError: onError,
      onSuccess: () {
        SettingsModel.collection
            .doc(_uid)
            .update({"logoPath": null, "logoUrl": null});
      },
    );
  }

  void uploadBackground({
    required XFile image,
    required Function(Exception) onError,
  }) {
    StorageService().uploadImage(
      image: image,
      filename: 'background',
      onError: onError,
      onSuccess: (path, url) {
        SettingsModel.collection
            .doc(_uid)
            .update({"backgroundPath": path, "backgroundUrl": url});
      },
    );
  }

  void deleteBackground({
    required String path,
    required Function(Exception) onError,
  }) {
    StorageService().deleteImage(
      path: path,
      onError: onError,
      onSuccess: () {
        SettingsModel.collection
            .doc(_uid)
            .update({"backgroundPath": null, "backgroundUrl": null});
      },
    );
  }
}
