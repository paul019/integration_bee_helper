import 'package:flutter/material.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_list.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class IntegralSelectionDialog extends StatelessWidget {
  final void Function(String integralCode) onIntegralSelected;
  final List<String> excludeIntegralsCodes;

  const IntegralSelectionDialog({
    super.key,
    required this.onIntegralSelected,
    this.excludeIntegralsCodes = const [],
  });

  static void launch({
    required BuildContext context,
    required void Function(String integralCode) onIntegralSelected,
    List<String> excludeIntegralsCodes = const [],
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return IntegralSelectionDialog(
          onIntegralSelected: onIntegralSelected,
          excludeIntegralsCodes: excludeIntegralsCodes,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: AlertDialog(
        title: Text(MyIntl.of(context).selectIntegral),
        content: SizedBox(
          width: 850,
          height: 500,
          child: IntegralsList(
            onSelect: (code) {
              onIntegralSelected(code);
              Navigator.pop(context);
            },
            excludeIntegralsCodes: excludeIntegralsCodes,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(MyIntl.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
