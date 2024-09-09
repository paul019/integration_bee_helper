import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_card.dart';
import 'package:integration_bee_helper/screens/integrals_page/integrals_add_bulk_dialog.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/widgets/loading_screen.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';
import 'package:provider/provider.dart';

enum IntegralTypeFilter {
  all,
  regular,
  spare;

  String label(BuildContext context) {
    switch (this) {
      case IntegralTypeFilter.all:
        return MyIntl.of(context).allIntegralTypes;
      case IntegralTypeFilter.regular:
        return MyIntl.of(context).regularIntegrals;
      case IntegralTypeFilter.spare:
        return MyIntl.of(context).spareIntegrals;
    }
  }
}

enum IntegralAllocationFilter {
  all,
  allocated,
  unallocated;

  String label(BuildContext context) {
    switch (this) {
      case IntegralAllocationFilter.all:
        return MyIntl.of(context).allIntegrals;
      case IntegralAllocationFilter.allocated:
        return MyIntl.of(context).allocatedIntegrals;
      case IntegralAllocationFilter.unallocated:
        return MyIntl.of(context).unallocatedIntegrals;
    }
  }
}

enum IntegralUsageFilter {
  all,
  used,
  unused;

  String label(BuildContext context) {
    switch (this) {
      case IntegralUsageFilter.all:
        return MyIntl.of(context).allIntegrals;
      case IntegralUsageFilter.used:
        return MyIntl.of(context).usedIntegrals;
      case IntegralUsageFilter.unused:
        return MyIntl.of(context).unusedIntegrals;
    }
  }
}

class IntegralsPage extends StatefulWidget {
  const IntegralsPage({super.key});

  @override
  State<IntegralsPage> createState() => _IntegralsPageState();
}

class _IntegralsPageState extends State<IntegralsPage> {
  IntegralTypeFilter? integralTypeFilter = IntegralTypeFilter.all;
  IntegralAllocationFilter? integralAllocationFilter =
      IntegralAllocationFilter.all;
  IntegralUsageFilter? integralUsageFilter = IntegralUsageFilter.all;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IntegralModel>?>.value(
        initialData: null,
        value: IntegralsService().onIntegralsChanged,
        builder: (context, snapshot) {
          final integrals = Provider.of<List<IntegralModel>?>(context);

          if (integrals == null) {
            return const LoadingScreen();
          }

          final filteredIntegrals = integrals.where((integral) {
            if (integralTypeFilter == IntegralTypeFilter.regular &&
                integral.type != IntegralType.regular) {
              return false;
            }

            if (integralTypeFilter == IntegralTypeFilter.spare &&
                integral.type != IntegralType.spare) {
              return false;
            }

            if (integralAllocationFilter ==
                    IntegralAllocationFilter.allocated &&
                integral.agendaItemIds.isEmpty) {
              return false;
            }

            if (integralAllocationFilter ==
                    IntegralAllocationFilter.unallocated &&
                integral.agendaItemIds.isNotEmpty) {
              return false;
            }

            if (integralUsageFilter == IntegralUsageFilter.used &&
                integral.alreadyUsed == false) {
              return false;
            }

            if (integralUsageFilter == IntegralUsageFilter.unused &&
                integral.alreadyUsed == true) {
              return false;
            }

            return true;
          }).toList();

          return Scaffold(
            floatingActionButton: _noFiltersApplied
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: () => IntegralsAddBulkDialog.launch(context),
                        child: const Icon(Icons.list),
                      ),
                      const SizedBox(height: 16),
                      FloatingActionButton(
                        onPressed: () => IntegralsService()
                            .addIntegral(currentIntegrals: integrals),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  )
                : null,
            body: integrals.isEmpty
                ? Center(child: Text(MyIntl.of(context).noIntegralsYet))
                : ListView.builder(
                    itemCount: filteredIntegrals.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildFilterRow();
                      } else if (index == filteredIntegrals.length + 1) {
                        if (filteredIntegrals.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Text(MyIntl.of(context).noIntegralsMatchTheFilter),
                            ),
                          );
                        } else {
                          return const SizedBox(height: 100);
                        }
                      }

                      final integral = filteredIntegrals[index - 1];

                      return MaxWidthWrapper(
                        child: IntegralCard(
                          integral: integral,
                        ),
                      );
                    },
                  ),
          );
        });
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<IntegralTypeFilter>(
            value: integralTypeFilter,
            onChanged: (v) => setState(() => integralTypeFilter = v),
            items: IntegralTypeFilter.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.label(context)),
                    ))
                .toList(),
          ),
          const VerticalSeparator(),
          DropdownButton<IntegralAllocationFilter>(
            value: integralAllocationFilter,
            onChanged: (v) => setState(() => integralAllocationFilter = v),
            items: IntegralAllocationFilter.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.label(context)),
                    ))
                .toList(),
          ),
          const VerticalSeparator(),
          DropdownButton<IntegralUsageFilter>(
            value: integralUsageFilter,
            onChanged: (v) => setState(() => integralUsageFilter = v),
            items: IntegralUsageFilter.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.label(context)),
                    ))
                .toList(),
          ),
          const VerticalSeparator(),
          TextButton(
            onPressed: () => setState(() {
              integralTypeFilter = IntegralTypeFilter.all;
              integralAllocationFilter = IntegralAllocationFilter.all;
              integralUsageFilter = IntegralUsageFilter.all;
            }),
            child: Text(MyIntl.of(context).resetFilters),
          ),
        ],
      ),
    );
  }

  bool get _noFiltersApplied =>
      integralTypeFilter == IntegralTypeFilter.all &&
      integralAllocationFilter == IntegralAllocationFilter.all &&
      integralUsageFilter == IntegralUsageFilter.all;
}
