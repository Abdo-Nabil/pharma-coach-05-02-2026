// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'calendarcontainer_item_model.dart';

/// This class defines the variables used in the [calendar_container_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class CalendarContainerModel extends Equatable {
  CalendarContainerModel({this.calendarcontainerItemList = const []}) {}

  List<CalendarcontainerItemModel> calendarcontainerItemList;

  CalendarContainerModel copyWith(
      {List<CalendarcontainerItemModel>? calendarcontainerItemList}) {
    return CalendarContainerModel(
      calendarcontainerItemList:
          calendarcontainerItemList ?? this.calendarcontainerItemList,
    );
  }

  @override
  List<Object?> get props => [calendarcontainerItemList];
}
