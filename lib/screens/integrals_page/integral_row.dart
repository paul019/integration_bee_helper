import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';

enum IntegralRowType { edit, select }

class IntegralRow extends StatelessWidget {
  final IntegralModel integral;
  final void Function()? onSelect;

  const IntegralRow({
    super.key,
    required this.integral,
    this.onSelect,
  });

  IntegralRowType get type => onSelect == null
      ? IntegralRowType.edit
      : IntegralRowType.select;

  @override
  Widget build(BuildContext context) {
    if (type == IntegralRowType.select) {
      return InkWell(
        onTap: onSelect,
        child: _buildRow(context),
      );
    } else {
      return _buildRow(context);
    }
  }

  Widget _buildRow(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Integral code:
            Column(
              children: [
                Text(
                  integral.code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Card(
                  child: SizedBox(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Icon(
                            integral.isSpareIntegral
                                ? Icons.check
                                : Icons.close,
                          ),
                          Text(
                            MyIntl.of(context).spareQuestionMark.toUpperCase(),
                            style: textStyle,
                          ),
                          Expanded(child: Container()),
                          //Divider(),
                          Icon(
                            integral.isAllocated ? Icons.check : Icons.close,
                          ),
                          Text(
                            MyIntl.of(context)
                                .allocatedQuestionMark
                                .toUpperCase(),
                            style: textStyle,
                          ),
                          Expanded(child: Container()),
                          Icon(
                            integral.alreadyUsed ? Icons.check : Icons.close,
                          ),
                          Text(
                            MyIntl.of(context).usedQuestionMark.toUpperCase(),
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 4),

            // Problem:
            Expanded(
              child: Card(
                child: LatexView(latex: integral.latexProblem),
              ),
            ),

            const SizedBox(width: 4),

            // Solution:
            Expanded(
              child: Card(
                child: LatexView(latex: integral.latexSolution),
              ),
            ),

            const SizedBox(width: 8),

            // Edit button:
            if (type == IntegralRowType.edit)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),

            // Delete button:
            if (type == IntegralRowType.edit)
              IconButton(
                onPressed: integral.agendaItemIds.isEmpty
                    ? () {
                        ConfirmationDialog(
                          positiveText: MyIntl.of(context).yes,
                          negativeText: MyIntl.of(context).cancel,
                          bypassConfirmation: integral.latexProblem.raw == "" &&
                              integral.latexSolution.raw == "",
                          title: MyIntl.of(context)
                              .doYouReallyWantToDeleteThisIntegral,
                          payload: () async {
                            try {
                              await IntegralsService().deleteIntegral(integral);
                            } on Exception catch (e) {
                              if (context.mounted) e.show(context);
                            }
                          },
                        ).launch(context);
                      }
                    : null,
                icon: const Icon(Icons.delete_outline),
              ),

            // Arrow:
            if (type == IntegralRowType.select)
              const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ],
    );
  }
}
