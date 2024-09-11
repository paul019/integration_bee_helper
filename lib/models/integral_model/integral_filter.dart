import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';

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

  bool match(IntegralModel integral) {
    switch (this) {
      case IntegralTypeFilter.all:
        return true;
      case IntegralTypeFilter.regular:
        return integral.type == IntegralType.regular;
      case IntegralTypeFilter.spare:
        return integral.type == IntegralType.spare;
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

  bool match(IntegralModel integral) {
    switch (this) {
      case IntegralAllocationFilter.all:
        return true;
      case IntegralAllocationFilter.allocated:
        return integral.agendaItemIds.isNotEmpty;
      case IntegralAllocationFilter.unallocated:
        return integral.agendaItemIds.isEmpty;
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

  bool match(IntegralModel integral) {
    switch (this) {
      case IntegralUsageFilter.all:
        return true;
      case IntegralUsageFilter.used:
        return integral.alreadyUsed;
      case IntegralUsageFilter.unused:
        return !integral.alreadyUsed;
    }
  }
}