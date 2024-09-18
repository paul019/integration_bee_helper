import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_selection_dialog.dart';
import 'package:integration_bee_helper/widgets/wrap_list.dart';

class IntegralsRow extends StatelessWidget {
  final String title;
  final bool enabled;
  final List<String> integralsCodes;
  final Future Function(List<String> integralsCodes) editIntegrals;
  final int? maxNumberOfIntegrals;

  const IntegralsRow({
    super.key,
    required this.title,
    required this.enabled,
    required this.integralsCodes,
    required this.editIntegrals,
    this.maxNumberOfIntegrals,
  });

  bool get maxNumberOfIntegralsReached =>
      maxNumberOfIntegrals != null &&
      integralsCodes.length >= maxNumberOfIntegrals!;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: WrapList<String>(
            showAdd: !maxNumberOfIntegralsReached,
            items: integralsCodes,
            itemBuilder: (context, index, item) => BasicWrapListItem(
              item: Text(item),
              showRemove: true,
              onRemove: enabled
                  ? () async {
                      final integralsCodes = this.integralsCodes;
                      integralsCodes.removeAt(index);

                      try {
                        await editIntegrals(
                          integralsCodes,
                        );
                      } on Exception catch (e) {
                        if (context.mounted) e.show(context);
                      }
                    }
                  : null,
              showControls: integralsCodes.length > 1,
              onMoveUp: (enabled && index != 0)
                  ? () async {
                      final integralsCodes = this.integralsCodes;
                      final temp = integralsCodes[index];
                      integralsCodes[index] = integralsCodes[index - 1];
                      integralsCodes[index - 1] = temp;

                      try {
                        await editIntegrals(
                          integralsCodes,
                        );
                      } on Exception catch (e) {
                        if (context.mounted) e.show(context);
                      }
                    }
                  : null,
              onMoveDown: (enabled && index != integralsCodes.length - 1)
                  ? () async {
                      final integralsCodes = this.integralsCodes;
                      final temp = integralsCodes[index];
                      integralsCodes[index] = integralsCodes[index + 1];
                      integralsCodes[index + 1] = temp;

                      try {
                        await editIntegrals(
                          integralsCodes,
                        );
                      } on Exception catch (e) {
                        if (context.mounted) e.show(context);
                      }
                    }
                  : null,
            ),
            onAdd: enabled
                ? () {
                    IntegralSelectionDialog.launch(
                      context: context,
                      excludeIntegralsCodes: integralsCodes,
                      onIntegralSelected: (codes) async {
                        final integralsCodes = this.integralsCodes;
                        integralsCodes.add(codes);

                        try {
                          await editIntegrals(
                            integralsCodes,
                          );
                        } on Exception catch (e) {
                          if (context.mounted) e.show(context);
                        }
                      },
                    );
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
