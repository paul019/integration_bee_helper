import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';

class SettingsModel {
  final String uid;
  final TournamentTreeModel tournamentTree;
  final String languageCode;
  final bool screensSwitched;
  final String competitionName;
  final String? logoPath;
  final String? logoUrl;
  final String? backgroundPath;
  final String? backgroundUrl;

  static const availableLanguages = ['en', 'de'];

  SettingsModel({
    required this.uid,
    required this.tournamentTree,
    required this.languageCode,
    required this.screensSwitched,
    required this.competitionName,
    required this.logoPath,
    required this.logoUrl,
    required this.backgroundPath,
    required this.backgroundUrl,
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
      competitionName: json['competitionName'] ?? '',
      logoPath: json['logoPath'],
      logoUrl: json['logoUrl'],
      backgroundPath: json['backgroundPath'],
      backgroundUrl: json['backgroundUrl'],
    );
  }

  static Map<String, dynamic> get minimalJson => {
        'tournamentTree': '',
        'languageCode': 'en',
        'screensSwitched': false,
        'competitionName': '',
        'logoPath': null,
        'logoUrl': null,
        'backgroundPath': null,
        'backgroundUrl': null,
      };

  // Getters:
  Locale get locale => Locale(languageCode);

  // Firebase:
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('settings');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(uid);
}
