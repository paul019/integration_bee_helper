import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_selection_dialog.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';
import 'package:integration_bee_helper/widgets/wrap_list.dart';

class IntegralsRow extends StatefulWidget {
  final String title;
  final bool enabled;
  final List<String> integralsCodes;
  final List<String> excludeIntegralsCodesForAddition;
  final Future Function(List<String> integralsCodes) editIntegrals;
  final int? maxNumberOfIntegrals;

  const IntegralsRow({
    super.key,
    required this.title,
    required this.enabled,
    required this.integralsCodes,
    required this.excludeIntegralsCodesForAddition,
    required this.editIntegrals,
    this.maxNumberOfIntegrals,
  });

  @override
  State<IntegralsRow> createState() => _IntegralsRowState();
}

class _IntegralsRowState extends State<IntegralsRow> {
  final List<String> fetchedIntegralsCodes = [];
  final List<IntegralModel> integrals = [];

  bool get maxNumberOfIntegralsReached =>
      widget.maxNumberOfIntegrals != null &&
      widget.integralsCodes.length >= widget.maxNumberOfIntegrals!;

  void getIntegrals() {
    final codesToFetch = <String>[];

    for (var code in widget.integralsCodes) {
      if (!fetchedIntegralsCodes.contains(code)) {
        codesToFetch.add(code);
        fetchedIntegralsCodes.add(code);
      }
    }

    if (codesToFetch.isNotEmpty) {
      IntegralsService().getIntegralsByCodes(codes: codesToFetch).then((value) {
        if (context.mounted) {
          setState(() {
            integrals.addAll(value);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getIntegrals();

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: WrapList<String>(
            showAdd: !maxNumberOfIntegralsReached,
            items: widget.integralsCodes,
            itemBuilder: (context, index, item) {
              IntegralModel? integral;

              try {
                integral = integrals.firstWhere(
                  (element) => element.code == item,
                );
              } catch (e) {}

              return BasicWrapListItem(
                item: integral != null
                    ? LatexView(latex: integral.latexProblem)
                    : Text(item),
                showRemove: true,
                onRemove: widget.enabled
                    ? () async {
                        final integralsCodes = [...widget.integralsCodes];
                        integralsCodes.removeAt(index);

                        try {
                          await widget.editIntegrals(
                            integralsCodes,
                          );
                        } on Exception catch (e) {
                          if (context.mounted) e.show(context);
                        }
                      }
                    : null,
                showControls: widget.integralsCodes.length > 1,
                onMoveUp: (widget.enabled && index != 0)
                    ? () async {
                        final integralsCodes = [...widget.integralsCodes];
                        final temp = integralsCodes[index];
                        integralsCodes[index] = integralsCodes[index - 1];
                        integralsCodes[index - 1] = temp;

                        try {
                          await widget.editIntegrals(
                            integralsCodes,
                          );
                        } on Exception catch (e) {
                          if (context.mounted) e.show(context);
                        }
                      }
                    : null,
                onMoveDown: (widget.enabled &&
                        index != widget.integralsCodes.length - 1)
                    ? () async {
                        final integralsCodes = [...widget.integralsCodes];
                        final temp = integralsCodes[index];
                        integralsCodes[index] = integralsCodes[index + 1];
                        integralsCodes[index + 1] = temp;

                        try {
                          await widget.editIntegrals(
                            integralsCodes,
                          );
                        } on Exception catch (e) {
                          if (context.mounted) e.show(context);
                        }
                      }
                    : null,
              );
            },
            onAdd: widget.enabled
                ? () {
                    IntegralSelectionDialog.launch(
                      context: context,
                      excludeIntegralsCodes:
                          widget.excludeIntegralsCodesForAddition,
                      onIntegralSelected: (codes) async {
                        final integralsCodes = [...widget.integralsCodes];
                        integralsCodes.add(codes);

                        try {
                          await widget.editIntegrals(
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
