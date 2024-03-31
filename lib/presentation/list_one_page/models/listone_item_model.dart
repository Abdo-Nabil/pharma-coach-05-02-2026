import '../../../core/app_export.dart';

/// This class is used in the [listone_item_widget] screen.
class ListoneItemModel {
  ListoneItemModel({
    this.elgawyHospital,
    this.nasrCityOne,
    this.normal,
    this.flash,
    this.id,
  }) {
    elgawyHospital = elgawyHospital ?? "Elgawy Hospital";
    nasrCityOne = nasrCityOne ?? "Nasr city 1";
    normal = normal ?? "Normal";
    flash = flash ?? "Flash";
    id = id ?? "";
  }

  String? elgawyHospital;

  String? nasrCityOne;

  String? normal;

  String? flash;

  String? id;
}
