import '../../../core/app_export.dart';

/// This class is used in the [home_item_widget] screen.
class HomeItemModel {
  HomeItemModel({
    this.tareqFares,
    this.oneMillionTwoHundredFiftyTwoTh,
    this.id,
  }) {
    tareqFares = tareqFares ?? "Tareq Fares ";
    oneMillionTwoHundredFiftyTwoTh =
        oneMillionTwoHundredFiftyTwoTh ?? "12 - 5 - 2024";
    id = id ?? "";
  }

  String? tareqFares;

  String? oneMillionTwoHundredFiftyTwoTh;

  String? id;
}
