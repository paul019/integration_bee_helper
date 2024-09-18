import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/latex_view.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class IntegralAddDialog extends StatefulWidget {
  final IntegralModel? integral;

  const IntegralAddDialog({
    super.key,
    this.integral,
  });

  @override
  State<IntegralAddDialog> createState() => _IntegralAddDialogState();

  static void launch({
    required BuildContext context,
    IntegralModel? integral,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return IntegralAddDialog(integral: integral);
      },
    );
  }
}

class _IntegralAddDialogState extends State<IntegralAddDialog> {
  late LatexExpression latexProblem;
  late LatexExpression latexSolution;
  late String name;
  late String youtubeVideoId;

  late TextEditingController latexProblemController;
  late TextEditingController latexSolutionController;
  late TextEditingController nameController;
  late TextEditingController youtubeVideoIdController;

  late IntegralType type;

  @override
  void initState() {
    if (widget.integral != null) {
      latexProblem = widget.integral!.latexProblem;
      latexSolution = widget.integral!.latexSolution;
      name = widget.integral!.name;
      youtubeVideoId = widget.integral!.youtubeVideoId;
      type = widget.integral!.type;
    } else {
      latexProblem = LatexExpression('');
      latexSolution = LatexExpression('');
      name = '';
      youtubeVideoId = '';
      type = IntegralType.regular;
    }

    latexProblemController = TextEditingController(text: latexProblem.raw);
    latexSolutionController = TextEditingController(text: latexSolution.raw);
    nameController = TextEditingController(text: name);
    youtubeVideoIdController = TextEditingController(text: youtubeVideoId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: AlertDialog(
        title: Text(
          widget.integral != null
              ? MyIntl.of(context).editIntegral
              : MyIntl.of(context).addIntegral,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name:
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: MyIntl.of(context).nameOptional,
              ),
              controller: nameController,
              onChanged: (v) => setState(() {
                name = v;
              }),
            ),

            // Youtube video ID:
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: MyIntl.of(context).youtubeVideoIDOptional,
              ),
              controller: youtubeVideoIdController,
              onChanged: (v) => setState(() {
                youtubeVideoId = v;
              }),
            ),

            Row(
              children: [
                // Latex problem:
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          width: 400,
                          height: 150,
                          alignment: Alignment.center,
                          child: LatexView(latex: latexProblem),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: MyIntl.of(context).problemLatex,
                        ),
                        controller: latexProblemController,
                        onChanged: (v) => setState(() {
                          latexProblem = LatexExpression(v);
                        }),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                // Latex solution:
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          width: 400,
                          height: 150,
                          alignment: Alignment.center,
                          child: LatexView(latex: latexSolution),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: MyIntl.of(context).solutionLatex,
                        ),
                        controller: latexSolutionController,
                        onChanged: (v) => setState(() {
                          latexSolution = LatexExpression(v);
                        }),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Spare integral:
            Row(
              children: [
                Checkbox(
                  value: type == IntegralType.spare,
                  onChanged: (v) => setState(() {
                    type = (v ?? false)
                        ? IntegralType.spare
                        : IntegralType.regular;
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(MyIntl.of(context).spareIntegralQuestionMark),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(MyIntl.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              if (widget.integral != null) {
                // Update integral
                await IntegralsService().editIntegral(
                  widget.integral!,
                  latexProblem: latexProblem,
                  latexSolution: latexSolution,
                  name: name,
                  type: type,
                  youtubeVideoId: youtubeVideoId,
                );
              } else {
                // Add integral
                await IntegralsService().addIntegral(
                  latexProblem: latexProblem,
                  latexSolution: latexSolution,
                  name: name,
                  type: type,
                  youtubeVideoId: youtubeVideoId,
                );
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              widget.integral != null
                  ? MyIntl.of(context).confirm
                  : MyIntl.of(context).add,
            ),
          ),
        ],
      ),
    );
  }
}
