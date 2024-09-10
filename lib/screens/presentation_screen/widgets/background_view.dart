import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';

class BackgroundView extends StatelessWidget {
  final Size size;
  final SettingsModel? settings;

  const BackgroundView({
    super.key,
    required this.size,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (settings?.backgroundUrl != null) {
      return Image.network(
        settings!.backgroundUrl!,
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.24),
      );
    } else {
      return Image.asset(
        'assets/images/background.png',
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.24),
      );
    }
  }
}
