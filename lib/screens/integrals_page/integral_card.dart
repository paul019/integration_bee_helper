import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';
import 'package:integration_bee_helper/widgets/confirmation_dialog.dart';

class IntegralCard extends StatefulWidget {
  final IntegralModel integral;
  final IntegralsService service;

  const IntegralCard({
    super.key,
    required this.integral,
    required this.service,
  });

  @override
  State<IntegralCard> createState() => _IntegralCardState();
}

class _IntegralCardState extends State<IntegralCard> {
  bool hasChanged = false;

  late String latexProblem;
  late String latexSolution;

  late IntegralLevel level;

  late TextEditingController problemController;
  late TextEditingController solutionController;

  @override
  void initState() {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;

    level = widget.integral.level;

    problemController = TextEditingController(text: latexProblem);
    solutionController = TextEditingController(text: latexSolution);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant IntegralCard oldWidget) {
    latexProblem = widget.integral.latexProblem;
    latexSolution = widget.integral.latexSolution;

    level = widget.integral.level;

    problemController.text = latexProblem;
    solutionController.text = latexSolution;

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
                  Text(
                    'Integral #${widget.integral.code}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (latexProblem == "" && latexSolution == "") {
                            widget.service.deleteIntegral(widget.integral);
                            return;
                          }
    
                          ConfirmationDialog(
                            title: 'Do you really want to delete this integral?',
                            payload: () =>
                                widget.service.deleteIntegral(widget.integral),
                          ).launch(context);
                        },
                        icon: const Icon(Icons.delete),
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
                          height: 100,
                          child: TeXView(
                            child: TeXViewDocument(
                              '\$\$$latexProblem\$\$',
                              style: const TeXViewStyle.fromCSS('padding: 5px;'),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: TeXView(
                            child: TeXViewDocument(
                              '\$\$$latexSolution\$\$',
                              style: const TeXViewStyle.fromCSS('padding: 5px;'),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (hasChanged) const Divider(),
              if (hasChanged)
                Row(
                  children: [
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            hasChanged = false;
                            latexProblem = widget.integral.latexProblem;
                            latexSolution = widget.integral.latexSolution;
                            level = widget.integral.level;
                            problemController.text = latexProblem;
                            solutionController.text = latexSolution;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        await widget.service.editIntegral(
                          widget.integral.id!,
                          latexProblem: latexProblem,
                          latexSolution: latexSolution,
                          level: level,
                        );
                        setState(() => hasChanged = false);
                      },
                      child: const Text('Save changes'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
