import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';

class LogoView extends StatelessWidget {
  final Size size;
  final bool transitionMode;
  final SettingsModel? settings;

  const LogoView({
    super.key,
    required this.size,
    this.transitionMode = false,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topRight,
      child: AnimatedPadding(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        padding: transitionMode
            ? EdgeInsets.symmetric(
                vertical: (1080 - 750) / 2 * p,
                horizontal: (1920 - 750) / 2 * p,
              )
            : EdgeInsets.only(
                top: 25 * p,
                left: (1920 - 150 - 25) * p,
                right: 25 * p,
              ),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (settings?.logoUrl != null) {
      return Image.network(settings!.logoUrl!);
    } else {
      return Image.asset('assets/images/logo.png');
    }
  }
}
