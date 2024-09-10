import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final _storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get _uid => _firebaseAuth.currentUser!.uid;

  void uploadImage({
    required XFile image,
    required Function(Exception) onError,
    required Function(String, String) onSuccess,
    String? filename,
  }) async {
    filename ??= getRandomString(10);

    final path = 'images/$_uid/$filename.png';
    final ref = _storageRef.child(path);

    try {
      await ref.putData(await image.readAsBytes());
      final url = await ref.getDownloadURL();
      onSuccess(path, url);
    } on Exception catch (e) {
      onError(e);
    }
  }

  void deleteImage({
    required String path,
    required Function(Exception) onError,
    required Function() onSuccess,
  }) async {
    final ref = _storageRef.child(path);

    try {
      await ref.delete();
      onSuccess();
    } on Exception catch (e) {
      onError(e);
    }
  }

  String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random random = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
