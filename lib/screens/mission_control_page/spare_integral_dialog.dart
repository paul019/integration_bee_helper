import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SpareIntegralDialog extends StatefulWidget {
  final List<IntegralModel> potentialSpareIntegrals;
  final void Function(IntegralModel) onChoose;

  const SpareIntegralDialog({
    super.key,
    required this.potentialSpareIntegrals,
    required this.onChoose,
  });

  @override
  State<SpareIntegralDialog> createState() => _SpareIntegralDialogState();

  static Future<void> launch(
    BuildContext context, {
    required List<IntegralModel> potentialSpareIntegrals,
    required Function(IntegralModel) onChoose,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => PointerInterceptor(
        child: SpareIntegralDialog(
          potentialSpareIntegrals: potentialSpareIntegrals,
          onChoose: onChoose,
        ),
      ),
    );
  }
}

class _SpareIntegralDialogState extends State<SpareIntegralDialog> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(MyIntl.of(context).chooseASpareIntegral),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  var newIndex = selectedIndex - 1;
                  if (newIndex < 0) {
                    newIndex = widget.potentialSpareIntegrals.length - 1;
                  }
                  setState(() => selectedIndex = newIndex);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Container(
                width: 500,
                height: 150,
                alignment: Alignment.center,
                child: LatexView(
                  latex: widget
                      .potentialSpareIntegrals[selectedIndex].latexProblem,
                ),
              ),
              IconButton(
                onPressed: () {
                  var newIndex = selectedIndex + 1;
                  if (newIndex >= widget.potentialSpareIntegrals.length) {
                    newIndex = 0;
                  }
                  setState(() => selectedIndex = newIndex);
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          Text(
            MyIntl.of(context).integralNumber(
                widget.potentialSpareIntegrals[selectedIndex].code),
          ),
          Text(
            '${selectedIndex + 1} of ${widget.potentialSpareIntegrals.length}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MyIntl.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            widget.onChoose(widget.potentialSpareIntegrals[selectedIndex]);
            Navigator.of(context).pop();
          },
          child:  Text(MyIntl.of(context).choose),
        ),
      ],
    );
  }
}
