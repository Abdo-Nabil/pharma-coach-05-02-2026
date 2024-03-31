import '../../../core/app_export.dart';

/// This class is used in the [calendarcontainer_item_widget] screen.
class CalendarcontainerItemModel {
  CalendarcontainerItemModel({
    this.ahmedEssam,
    this.widget,
    this.sun,
    this.th,
    this.id,
  }) {
    ahmedEssam = ahmedEssam ?? "Ahmed Essam";
    widget = widget ?? "2";
    sun = sun ?? "Sun 20-5-2024";
    th = th ?? "Th 26-5-2024";
    id = id ?? "";
  }

  String? ahmedEssam;

  String? widget;

  String? sun;

  String? th;

  String? id;
}
