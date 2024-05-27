import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/basic_models/latex_expression.dart';
import 'package:integration_bee_helper/models/integral_model/integral_prototype.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class IntegralsAddBulkDialog extends StatefulWidget {
  final Function(List<String>) onAdd;

  const IntegralsAddBulkDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<IntegralsAddBulkDialog> createState() => _IntegralsAddBulkDialogState();

  static void launch(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return IntegralsAddBulkDialog(
          onAdd: (codes) => _launchSuccessDialog(context, codes: codes),
        );
      },
    );
  }

  static void _launchSuccessDialog(
    BuildContext context, {
    required List<String> codes,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PointerInterceptor(
          child: AlertDialog(
            title: const Text('Integrals added'),
            content: Text('Codes: ${codes.join(', ')}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: codes.join(',')),
                  ).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Codes copied to clipboard'),
                      ),
                    );
                  });
                },
                child: const Text('Copy codes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IntegralsAddBulkDialogState extends State<IntegralsAddBulkDialog> {
  String rawText = '';
  List<String> formattedLines = [];
  late TextEditingController rawTextController;
  IntegralType type = IntegralType.regular;

  @override
  void initState() {
    rawTextController = TextEditingController(text: '');

    super.initState();
  }

  List<String> _format(String rawText) {
    return rawText
        .replaceAll('\\item', '')
        .replaceAll('\$', '')
        .replaceAll('\\begin{align*}', '')
        .replaceAll('\\begin{align}', '')
        .replaceAll('\\begin{equation*}', '')
        .replaceAll('\\begin{equation}', '')
        .replaceAll('\\end{align*}', '')
        .replaceAll('\\end{align}', '')
        .replaceAll('\\end{equation*}', '')
        .replaceAll('\\end{equation}', '')
        .replaceAll('\\e', 'e')
        .replaceAll('\\dd x', '\\dd{x}')
        .split('\n')
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  List<IntegralPrototype> _toIntegralList() {
    List<IntegralPrototype> integrals = [];

    for (var line in formattedLines) {
      final parts = line.split('\\name');
      var name = parts.length > 1
          ? parts[1].replaceAll('{', '').replaceAll('}', '').trim()
          : '';

      if(name.isNotEmpty && name[0] == '(') {
        name = name.substring(1, name.length - 1);
      }
      if(name.isNotEmpty && name[name.length-1] == ')') {
        name = name.substring(0, name.length - 1);
      }


      final parts2 = parts[0].split(' = ');
      final problem = parts2[0];
      final solution = parts2.getRange(1, parts2.length).join(' = ');

      integrals.add(IntegralPrototype(
        latexProblem: LatexExpression(problem),
        latexSolution: LatexExpression(solution),
        type: type,
        name: name,
        youtubeVideoId: '',
      ));
    }

    return integrals;
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: AlertDialog(
        title: const Text('Import integrals'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Import',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tournament tree',
                        ),
                        controller: rawTextController,
                        onChanged: (v) => setState(() {
                          rawText = v;
                          formattedLines = _format(rawText);
                        }),
                        maxLines: 19,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 500,
                  width: 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 450,
                        child: SingleChildScrollView(
                          child: Text(
                            formattedLines.indexed
                                .map((e) => '${e.$1 + 1}. ${e.$2}')
                                .join('\n\n'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text('Spare Integrals?'),
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final integrals = _toIntegralList();
                final codes =
                    await IntegralsService().addBulk(integrals: integrals);
                if (context.mounted) Navigator.pop(context);
                widget.onAdd(codes);
              } on Exception catch (e) {
                if (context.mounted) e.show(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
