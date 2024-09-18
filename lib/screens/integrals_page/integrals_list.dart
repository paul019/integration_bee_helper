import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model/integral_filter.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/screens/integrals_page/integral_row.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:integration_bee_helper/widgets/loading_screen.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:integration_bee_helper/widgets/vertical_separator.dart';
import 'package:provider/provider.dart';

class IntegralsList extends StatefulWidget {
  final void Function(String integralCode)? onSelect;
  final List<String> excludeIntegralsCodes;

  const IntegralsList({
    super.key,
    this.onSelect,
    this.excludeIntegralsCodes = const [],
  });

  @override
  State<IntegralsList> createState() => _IntegralsListState();
}

class _IntegralsListState extends State<IntegralsList> {
  IntegralTypeFilter integralTypeFilter = IntegralTypeFilter.all;
  IntegralAllocationFilter integralAllocationFilter =
      IntegralAllocationFilter.all;
  IntegralUsageFilter integralUsageFilter = IntegralUsageFilter.all;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<IntegralModel>?>.value(
        initialData: null,
        value: IntegralsService().onIntegralsChanged,
        builder: (context, snapshot) {
          var integrals = Provider.of<List<IntegralModel>?>(context);

          if (integrals == null) {
            return const LoadingScreen();
          }

          integrals = integrals.where((integral) {
            return !widget.excludeIntegralsCodes.contains(integral.code);
          }).toList();

          final filteredIntegrals = integrals.where((integral) {
            return integralTypeFilter.match(integral) &&
                integralAllocationFilter.match(integral) &&
                integralUsageFilter.match(integral);
          }).toList();

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxWidth: 850),
                child: _buildFilterRow(),
              ),
              if (filteredIntegrals.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(MyIntl.of(context).noIntegralsMatchTheFilter),
                  ),
                ),
              if (filteredIntegrals.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredIntegrals.length,
                    separatorBuilder: (context, index) =>
                        const MaxWidthWrapper(child: Divider()),
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      bottom: 100.0,
                    ),
                    itemBuilder: (context, index) {
                      final integral = filteredIntegrals[index];

                      return MaxWidthWrapper(
                        child: IntegralRow(
                          integral: integral,
                          onSelect: widget.onSelect != null
                              ? () => widget.onSelect!(integral.code)
                              : null,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        });
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<IntegralTypeFilter>(
            value: integralTypeFilter,
            onChanged: (v) =>
                setState(() => integralTypeFilter = v ?? integralTypeFilter),
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
            onChanged: (v) => setState(
                () => integralAllocationFilter = v ?? integralAllocationFilter),
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
            onChanged: (v) =>
                setState(() => integralUsageFilter = v ?? integralUsageFilter),
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
}
