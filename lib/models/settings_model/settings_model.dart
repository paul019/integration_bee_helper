import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';

class SettingsModel {
  final String uid;
  final TournamentTreeModel tournamentTree;

  SettingsModel({
    required this.uid,
    required this.tournamentTree,
  });

  factory SettingsModel.fromJson(
    Map<String, dynamic> json, {
    required String uid,
  }) {
    return SettingsModel(
      uid: uid,
      tournamentTree: TournamentTreeModel.decode(json['tournamentTree']),
    );
  }

  static Map<String, dynamic> get minimalJson => {
        'tournamentTree': '',
      };

  // Firebase:
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('settings');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(uid);
}
