// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'list_item_model.dart';

/// This class defines the variables used in the [list_page],
/// and is typically used to hold data that is passed between different parts of the application.
class ListModel extends Equatable {
  ListModel({this.listItemList = const []}) {}

  List<ListItemModel> listItemList;

  ListModel copyWith({List<ListItemModel>? listItemList}) {
    return ListModel(
      listItemList: listItemList ?? this.listItemList,
    );
  }

  @override
  List<Object?> get props => [listItemList];
}
