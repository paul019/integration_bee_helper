import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/integral_model/current_integral_wrapper.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/integral_code_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/integral_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/names_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/timer_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/widgets/title_view.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:provider/provider.dart';

class PresentationScreenQualification extends StatefulWidget {
  final AgendaItemModelQualification activeAgendaItem;
  final Size size;
  final bool isPreview;

  const PresentationScreenQualification({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    required this.isPreview,
  });

  @override
  State<PresentationScreenQualification> createState() =>
      _PresentationScreenQualificationState();
}

class _PresentationScreenQualificationState
    extends State<PresentationScreenQualification> {
  String agendaItemId = '';

  String get uid => widget.activeAgendaItem.uid;
  ProblemPhase get problemPhase => widget.activeAgendaItem.problemPhase;
  List<String> get integralsCodes => widget.activeAgendaItem.integralsCodes;
  List<String> get spareIntegralsCodes =>
      widget.activeAgendaItem.spareIntegralsCodes;
  String? get currentIntegralCode =>
      widget.activeAgendaItem.currentIntegralCode;

  String? get problemName {
    if (widget.activeAgendaItem.currentIntegralType == IntegralType.regular) {
      return null;
    } else {
      return MyIntl.of(context).extraExerciseNumber(
        1,
        widget.activeAgendaItem.spareIntegralsProgress! + 1,
      );
    }
  }

  DateTime? get timerStopsAt => widget.activeAgendaItem.timer.timerStopsAt;

  Duration? get pausedTimerDuration =>
      widget.activeAgendaItem.timer.pausedTimerDuration;

  void initialize() async {
    agendaItemId = widget.activeAgendaItem.id;

    setState(() {});
  }

  @override
  void initState() {
    initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (agendaItemId != widget.activeAgendaItem.id) {
      initialize();
    }

    // final p = size.width / 1920.0;

    return StreamProvider<CurrentIntegralWrapper>.value(
        initialData: CurrentIntegralWrapper(null),
        value: IntegralsService().onCurrentIntegralChanged(
          integralCode: widget.activeAgendaItem.currentIntegralCode,
        ),
        builder: (context, snapshot) {
          final integralWrapper = Provider.of<CurrentIntegralWrapper>(context);
          final currentIntegral = integralWrapper.integral;

          return Stack(
            alignment: Alignment.center,
            children: [
              TimerView(
                activeAgendaItem: widget.activeAgendaItem,
                size: widget.size,
                isPreview: widget.isPreview,
              ),
              IntegralView(
                currentIntegral: currentIntegral,
                problemPhase: problemPhase,
                problemName: problemName,
                size: widget.size,
              ),
              IntegralCodeView(
                code: currentIntegralCode ?? '',
                size: widget.size,
              ),
              TitleView(
                title: widget.activeAgendaItem.title,
                size: widget.size,
              ),
              NamesView(
                competitorNames: widget.activeAgendaItem.competitorNames,
                problemName:
                    problemName ?? MyIntl.of(context).exerciseNumber(1),
                size: widget.size,
              ),
            ],
          );
        });
  }
}
