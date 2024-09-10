import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';

class SettingsModel {
  final String uid;
  final TournamentTreeModel tournamentTree;
  final String languageCode;
  final bool screensSwitched;

  static const availableLanguages = ['en', 'de'];

  SettingsModel({
    required this.uid,
    required this.tournamentTree,
    required this.languageCode,
    required this.screensSwitched,
  });

  factory SettingsModel.fromJson(
    Map<String, dynamic> json, {
    required String uid,
  }) {
    return SettingsModel(
      uid: uid,
      tournamentTree: TournamentTreeModel.decode(json['tournamentTree']),
      languageCode: json['languageCode'] ?? 'en',
      screensSwitched: json['screensSwitched'] ?? false,
    );
  }

  static Map<String, dynamic> get minimalJson => {
        'tournamentTree': '',
        'languageCode': 'en',
        'screensSwitched': false,
      };

  // Getters:
  Locale get locale => Locale(languageCode);

  // Firebase:
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('settings');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(uid);
}
