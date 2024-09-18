import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_add_dialog.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';
import 'package:integration_bee_helper/widgets/name_dialog.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';
import 'package:integration_bee_helper/widgets/wrap_list.dart';

enum IntegralRowType { edit, select }

class IntegralRow extends StatelessWidget {
  final IntegralModel integral;
  final void Function()? onSelect;

  const IntegralRow({
    super.key,
    required this.integral,
    this.onSelect,
  });

  IntegralRowType get type =>
      onSelect == null ? IntegralRowType.edit : IntegralRowType.select;

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First row:
              Card(
                child: SizedBox(
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          integral.code,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(integral.name),
                        ),
                        _buildIndicator(context, integral.isSpareIntegral,
                            MyIntl.of(context).spareQuestionMark),
                        const VerticalSeparator(),
                        _buildIndicator(context, integral.isAllocated,
                            MyIntl.of(context).allocatedQuestionMark),
                        const VerticalSeparator(),
                        _buildIndicator(context, integral.alreadyUsed,
                            MyIntl.of(context).usedQuestionMark),
                      ],
                    ),
                  ),
                ),
              ),

              // Second row:
              Row(
                children: [
                  // Problem:
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: LatexView(latex: integral.latexProblem),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Solution:
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Container(
                        height: 150,
                        alignment: Alignment.center,
                        child: LatexView(latex: integral.latexSolution),
                      ),
                    ),
                  ),
                ],
              ),
              if (type == IntegralRowType.edit || integral.tags.isNotEmpty)
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        MyIntl.of(context).tagsColon,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: WrapList<String>(
                        items: integral.tags,
                        itemBuilder: (context, index, item) =>
                            BasicWrapListItem(
                          item: Text(item),
                          showRemove: type == IntegralRowType.edit,
                          onRemove: () async {
                            final tags = [...integral.tags];
                            tags.removeAt(index);

                            try {
                              await IntegralsService()
                                  .editIntegral(integral, tags: tags);
                            } on Exception catch (e) {
                              if (context.mounted) e.show(context);
                            }
                          },
                        ),
                        showAdd: type == IntegralRowType.edit,
                        onAdd: () {
                          NameDialog.show(
                            context: context,
                            title: MyIntl.of(context).addTag,
                            hintText: MyIntl.of(context).tag,
                            onConfirm: (tag) async {
                              final tags = [...integral.tags];
                              tags.add(tag);

                              try {
                                await IntegralsService()
                                    .editIntegral(integral, tags: tags);
                              } on Exception catch (e) {
                                if (context.mounted) e.show(context);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Edit button:
        if (type == IntegralRowType.edit)
          IconButton(
            onPressed: () => IntegralAddDialog.launch(
              context: context,
              integral: integral,
            ),
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
        if (type == IntegralRowType.select) const Icon(Icons.arrow_forward_ios),
      ],
    );
  }

  Widget _buildIndicator(BuildContext context, bool value, String name) {
    return SizedBox(
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(value ? Icons.check : Icons.close),
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
