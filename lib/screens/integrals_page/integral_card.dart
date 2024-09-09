import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
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

  late LatexExpression latexProblem;
  late LatexExpression latexSolution;
  late String name;
  late IntegralType type;
  late String youtubeVideoId;

  late TextEditingController problemController;
  late TextEditingController solutionController;
  late TextEditingController nameController;
  late TextEditingController youtubeVideoIdController;

  @override
  void initState() {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;
    name = widget.integral.name;
    type = widget.integral.type;
    youtubeVideoId = widget.integral.youtubeVideoId;

    problemController = TextEditingController(text: latexProblem.raw);
    solutionController = TextEditingController(text: latexSolution.raw);
    nameController = TextEditingController(text: name);
    youtubeVideoIdController = TextEditingController(text: youtubeVideoId);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant IntegralCard oldWidget) {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;
    name = widget.integral.name;
    type = widget.integral.type;
    youtubeVideoId = widget.integral.youtubeVideoId;

    problemController.text = latexProblem.raw;
    solutionController.text = latexSolution.raw;
    nameController.text = name;
    youtubeVideoIdController.text = youtubeVideoId;

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
                        text: MyIntl.of(context)
                            .integralNumber(widget.integral.code),
                      ),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).nameOptional,
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
                        onPressed: widget.integral.agendaItemIds.isEmpty
                            ? () {
                                ConfirmationDialog(
                                  bypassConfirmation: latexProblem.raw == "" &&
                                      latexSolution.raw == "",
                                  title: MyIntl.of(context)
                                      .doYouReallyWantToDeleteThisIntegral,
                                  payload: () async {
                                    try {
                                      await IntegralsService()
                                          .deleteIntegral(widget.integral);
                                    } on Exception catch (e) {
                                      if (context.mounted) e.show(context);
                                    }
                                  },
                                ).launch(context);
                              }
                            : null,
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.integral.code),
                          ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    MyIntl.of(context).codeCopiedToClipboard),
                              ),
                            );
                          });
                        },
                        icon: const Icon(Icons.copy),
                      ),
                      Flexible(child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child:
                            Text(MyIntl.of(context).spareIntegralQuestionMark),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).problemLatex,
                          ),
                          controller: problemController,
                          onChanged: (v) => setState(() {
                            latexProblem = LatexExpression(v);
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: MyIntl.of(context).solutionLatex,
                          ),
                          controller: solutionController,
                          onChanged: (v) => setState(() {
                            latexSolution = LatexExpression(v);
                            hasChanged = true;
                          }),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      MyIntl.of(context).youtubeVideoID,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: MyIntl.of(context).youtubeVideoIDOptional,
                      ),
                      controller: youtubeVideoIdController,
                      onChanged: (v) => setState(() {
                        youtubeVideoId = v;
                        hasChanged = true;
                      }),
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
                      problemController.text = latexProblem.raw;
                      solutionController.text = latexSolution.raw;
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
                      youtubeVideoId: youtubeVideoId,
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
