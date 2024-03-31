// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/core/app_export.dart';

/// This class defines the variables used in the [team_analytics_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class TeamAnalyticsModel extends Equatable {
  TeamAnalyticsModel({this.dropdownItemList = const []}) {}

  List<SelectionPopupModel> dropdownItemList;

  TeamAnalyticsModel copyWith({List<SelectionPopupModel>? dropdownItemList}) {
    return TeamAnalyticsModel(
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
    );
  }

  @override
  List<Object?> get props => [dropdownItemList];
}
