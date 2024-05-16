import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/integral_model/integral_level.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/services/basic_services/latex_transformer.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';

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

  late IntegralLevel level;

  late TextEditingController problemController;
  late TextEditingController solutionController;
  late TextEditingController nameController;

  @override
  void initState() {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;
    name = widget.integral.name;

    level = widget.integral.level;

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

    level = widget.integral.level;

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
                      Text(
                        'Integral #${widget.integral.code}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                          if (latexProblem == "" && latexSolution == "") {
                             IntegralsService().deleteIntegral(widget.integral);
                            return;
                          }

                          ConfirmationDialog(
                            title:
                                'Do you really want to delete this integral?',
                            payload: () =>
                                 IntegralsService().deleteIntegral(widget.integral),
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
                      DropdownButtonHideUnderline(
                        child: DropdownButton<IntegralLevel>(
                          value: level,
                          onChanged: (IntegralLevel? v) => setState(() {
                            level = v!;
                            hasChanged = true;
                            FocusScope.of(context).unfocus();
                          }),
                          items: IntegralLevel.values
                              .map<DropdownMenuItem<IntegralLevel>>(
                                  (IntegralLevel v) {
                            return DropdownMenuItem<IntegralLevel>(
                              value: v,
                              child: Text(v.name),
                            );
                          }).toList(),
                        ),
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
                        SizedBox(
                          height: 150,
                          child: TeXView(
                            child: TeXViewDocument(
                              LatexTransformer.transform(latexProblem),
                              style:
                                  const TeXViewStyle.fromCSS('padding: 5px;'),
                            ),
                          ),
                        ),
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
                        SizedBox(
                          height: 150,
                          child: TeXView(
                            child: TeXViewDocument(
                              LatexTransformer.transform(latexSolution),
                              style:
                                  const TeXViewStyle.fromCSS('padding: 5px;'),
                            ),
                          ),
                        ),
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
                      level = widget.integral.level;
                      problemController.text = latexProblem;
                      solutionController.text = latexSolution;
                      nameController.text = name;
                    });
                  },
                  onSave: () async {
                    await  IntegralsService().editIntegral(
                      widget.integral,
                      latexProblem: latexProblem,
                      latexSolution: latexSolution,
                      level: level,
                      name: name,
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
