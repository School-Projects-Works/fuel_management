import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/driver_model.dart';
import 'package:fuel_management/features/admin/dashboard/services/assignment_services.dart';

import '../data/assignment_model.dart';

class AssignmentFilter {
  List<AssignmentModel> items;
  List<AssignmentModel> filter;

  AssignmentFilter({
    required this.items,
    required this.filter,
  });

  AssignmentFilter copyWith({
    List<AssignmentModel>? items,
    List<AssignmentModel>? filter,
  }) {
    return AssignmentFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final assignmentsProvider =
    StateNotifierProvider<AssignmentsProvider, AssignmentFilter>((ref) {
  return AssignmentsProvider();
});

class AssignmentsProvider extends StateNotifier<AssignmentFilter> {
  AssignmentsProvider() : super(AssignmentFilter(items: [], filter: []));

  void setItems(List<AssignmentModel> items) {
    state = state.copyWith(items: items, filter: items);
  }

  void filterAssignments(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      final filter = state.items.where((element) {
        var driver = DriverModel.fromMap(element.driver);
        var car = CarModel.fromMap(element.car);
        return driver.name.toLowerCase().contains(query.toLowerCase()) ||
            driver.id.toLowerCase().contains(query.toLowerCase()) ||
            driver.phone.toLowerCase().contains(query.toLowerCase()) ||
            car.brand.toLowerCase().contains(query.toLowerCase()) ||
            car.model.toLowerCase().contains(query.toLowerCase()) ||
            car.registrationNumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: filter);
    }
  }

  void deleteAssignment(AssignmentModel assign) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting assignment');
    var results = await AssignmentServices.deleteAssignment(assign.id);
    if (results) {
      CustomDialogs.dismiss();
    }
  }

  void updateTrip(AssignmentModel copyWith) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Updating assignment');
    var result = await AssignmentServices.updateAssignment(copyWith);
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Assignment updated',type: DialogType.success);
    }else{
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to update assignment');
    }
  }
}
