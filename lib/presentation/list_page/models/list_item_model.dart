import '../../../core/app_export.dart';

/// This class is used in the [list_item_widget] screen.
class ListItemModel {
  ListItemModel({
    this.marwaMohamedEldeeb,
    this.brickNasrCity,
    this.normal,
    this.paediatrics,
    this.flash,
    this.id,
  }) {
    marwaMohamedEldeeb = marwaMohamedEldeeb ?? "Marwa Mohamed Eldeeb  ";
    brickNasrCity = brickNasrCity ?? "Brick1 Nasr City";
    normal = normal ?? "Normal";
    paediatrics = paediatrics ?? "Paediatrics";
    flash = flash ?? "Flash";
    id = id ?? "";
  }

  String? marwaMohamedEldeeb;

  String? brickNasrCity;

  String? normal;

  String? paediatrics;

  String? flash;

  String? id;
}
