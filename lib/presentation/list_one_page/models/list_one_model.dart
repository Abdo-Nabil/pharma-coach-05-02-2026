// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import 'listone_item_model.dart';

/// This class defines the variables used in the [list_one_page],
/// and is typically used to hold data that is passed between different parts of the application.
class ListOneModel extends Equatable {
  ListOneModel({this.listoneItemList = const []}) {}

  List<ListoneItemModel> listoneItemList;

  ListOneModel copyWith({List<ListoneItemModel>? listoneItemList}) {
    return ListOneModel(
      listoneItemList: listoneItemList ?? this.listoneItemList,
    );
  }

  @override
  List<Object?> get props => [listoneItemList];
}
