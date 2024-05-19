import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';
import 'package:integration_bee_helper/widgets/text_bubble.dart';

class IntegralCard extends StatefulWidget {
  final IntegralModel integral;

  const IntegralCard({
    super.key,
    required this.integral,
  });

  @override
  State<IntegralCard> createState() => _IntegralCardState();
}

class _IntegralCardState extends State<IntegralCard> {
  bool hasChanged = false;

  late String latexProblem;
  late String latexSolution;
  late String name;
  late IntegralType type;

  late TextEditingController problemController;
  late TextEditingController solutionController;
  late TextEditingController nameController;

  @override
  void initState() {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;
    name = widget.integral.name;
    type = widget.integral.type;

    problemController = TextEditingController(text: latexProblem);
    solutionController = TextEditingController(text: latexSolution);
    nameController = TextEditingController(text: name);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant IntegralCard oldWidget) {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;
    name = widget.integral.name;
    type = widget.integral.type;

    problemController.text = latexProblem;
    solutionController.text = latexSolution;
    nameController.text = name;

    hasChanged = false;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Column(
                    children: [
                      TextBubble(
                        color: widget.integral.alreadyUsed
                            ? Theme.of(context).colorScheme.error
                            : null,
                        textColor: widget.integral.alreadyUsed
                            ? Colors.white
                            : Colors.black,
                        text: 'Integral #${widget.integral.code}',
                      ),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name (optional)',
                          ),
                          textAlign: TextAlign.center,
                          controller: nameController,
                          onChanged: (v) => setState(() {
                            name = v;
                            hasChanged = true;
                          }),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ConfirmationDialog(
                            bypassConfirmation:
                                latexProblem == "" && latexSolution == "",
                            title:
                                'Do you really want to delete this integral?',
                            payload: () async {
                              try {
                                await IntegralsService()
                                    .deleteIntegral(widget.integral);
                              } on Exception catch (e) {
                                if (context.mounted) e.show(context);
                              }
                            },
                          ).launch(context);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.integral.code),
                          ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Code copied to clipboard'),
                              ),
                            );
                          });
                        },
                        icon: const Icon(Icons.copy),
                      ),
                      Flexible(child: Container()),
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Text('Spare Integral?'),
                      ),
                      Checkbox(
                        value: type == IntegralType.spare,
                        onChanged: (v) => setState(() {
                          type = (v ?? false)
                              ? IntegralType.spare
                              : IntegralType.regular;
                          hasChanged = true;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        LatexView(latex: latexProblem),
                        TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Problem (LaTeX)',
                          ),
                          controller: problemController,
                          onChanged: (v) => setState(() {
                            latexProblem = v;
                            hasChanged = true;
                          }),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        LatexView(latex: latexSolution),
                        TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Solution (LaTeX)',
                          ),
                          controller: solutionController,
                          onChanged: (v) => setState(() {
                            latexSolution = v;
                            hasChanged = true;
                          }),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (hasChanged)
                CancelSaveButtons(
                  onCancel: () {
                    setState(() {
                      hasChanged = false;
                      latexProblem = widget.integral.latexProblem;
                      latexSolution = widget.integral.latexSolution;
                      name = widget.integral.name;
                      problemController.text = latexProblem;
                      solutionController.text = latexSolution;
                      nameController.text = name;
                    });
                  },
                  onSave: () async {
                    await IntegralsService().editIntegral(
                      widget.integral,
                      latexProblem: latexProblem,
                      latexSolution: latexSolution,
                      name: name,
                      type: type,
                    );
                    setState(() => hasChanged = false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
