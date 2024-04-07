import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';
import 'package:mina_s_application5/presentation/list_tab_container_screen/cubit/list_tap_container_cubit.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';

import '../../../general_data.dart';
import '../../../widgets/custom_search_view.dart';
import '../models/listone_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class ListoneItemWidget extends StatefulWidget {
  ListoneItemWidget(
    this.locationModel, {
    required this.isPm,
    required this.isVisitCreated,
    required this.isQuestionSubmitted,
    required this.visitId,
    Key? key,
  }) : super(
          key: key,
        );

  LocationModel locationModel;
  bool isPm;
  bool isVisitCreated;
  bool isQuestionSubmitted;
  int visitId;

  @override
  State<ListoneItemWidget> createState() => _ListoneItemWidgetState();
}

class _ListoneItemWidgetState extends State<ListoneItemWidget> {
  //
  String groupValue = "normal";
  //
  @override
  Widget build(BuildContext context) {
    final List<String> temp = widget.locationModel.name.split('_');
    final specialization = temp.first;
    final name = temp.last;
    //
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        InkWell(
          onTap: () async {
            // GeneralData.selectedRepId = widget.locationModel.rep.id!;
            // GeneralData.selectedVisitId = widget.locationModel.id;
            if (!widget.isVisitCreated) {
              final isCreated =
                  await BlocProvider.of<ListTabContainerCubit>(context)
                      .creteVisit(
                widget.locationModel.id!,
                widget.locationModel.type,
              );

              return;
            }
            if (!widget.isQuestionSubmitted) {
              NavigatorService.pushNamed(
                AppRoutes.questionsScreen,
                arguments: {
                  'type': groupValue,
                  // 'medicalRepName': widget.locationModel.rep.firstName,
                },
              );
              return;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 8.v,
            ),
            decoration: widget.isPm
                ? AppDecoration.fillBlue.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  )
                : AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
            child: Padding(
              padding: EdgeInsets.only(top: 3.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        "${name}",
                        // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                        // listoneItemModelObj.elgawyHospital!,
                        style: CustomTextStyles.labelLargeSFProTextBluegray900,
                      ),
                      Spacer(),
                      Visibility(
                        visible: widget.isPm,
                        child: Text(
                          "${specialization}",
                          // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                          // listoneItemModelObj.elgawyHospital!,
                          style: TextStyle(
                            fontSize: 12.fSize,
                            color: appTheme.orange300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.v),
                  /* Row(
                    children: [
                      Icon(
                        Icons.accessibility,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        "${widget.locationModel.rep.firstName}",
                        // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                        // listoneItemModelObj.elgawyHospital!,
                        style: CustomTextStyles.labelLargeSFProTextBluegray900,
                      ),
                    ],
                  ),*/
                  SizedBox(height: 5.v),
                  Row(
                    children: [
                      // CustomImageView(
                      //   imagePath: ImageConstant.imgMapMarker,
                      //   height: 10.adaptSize,
                      //   width: 10.adaptSize,
                      //   margin: EdgeInsets.only(bottom: 2.v),
                      // ),
                      Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "${widget.locationModel.address}",
                          // listoneItemModelObj.nasrCityOne!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.v),
                  widget.isVisitCreated && !widget.isQuestionSubmitted
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RadioItemWidget(
                              title: "Normal",
                              value: "normal",
                              groupValue: groupValue,
                              onTap: () {
                                setState(() {
                                  groupValue = "normal";
                                });
                              },
                              onChange: (_) {
                                setState(() {
                                  groupValue = "normal";
                                });
                              },
                            ),
                            RadioItemWidget(
                              title: "Flash",
                              value: "flash",
                              groupValue: groupValue,
                              onTap: () {
                                setState(() {
                                  groupValue = "flash";
                                });
                              },
                              onChange: (_) {
                                setState(() {
                                  groupValue = "flash";
                                });
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
/*
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // GeneralData.selectedRepId =
                          //     widget.locationModel.rep.id!;
                          // GeneralData.selectedVisitId = widget.locationModel.id;
                          NavigatorService.pushNamed(
                            AppRoutes.questionsScreen,
                            arguments: {'type': 'normal'},
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.h,
                            vertical: 3.v,
                          ),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 9.adaptSize,
                                width: 9.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                                decoration: BoxDecoration(
                                  color: appTheme.lightGreenA700,
                                  borderRadius: BorderRadius.circular(
                                    4.h,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: Text(
                                  "Normal",
                                  // listoneItemModelObj.normal!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // GeneralData.selectedRepId =
                          //     widget.locationModel.rep.id!;
                          // GeneralData.selectedVisitId = widget.locationModel.id;
                          NavigatorService.pushNamed(
                            AppRoutes.questionsScreen,
                            arguments: {'type': 'flash'},
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 37.v),
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.h,
                            vertical: 3.v,
                          ),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder3,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 9.adaptSize,
                                width: 9.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                                decoration: BoxDecoration(
                                  color: appTheme.orange300,
                                  borderRadius: BorderRadius.circular(
                                    4.h,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: Text(
                                  "Flash",
                                  // listoneItemModelObj.flash!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
*/
                ],
              ),
            ),
          ),
        ),
        //TODO: ###################################
        Visibility(
          visible: widget.isQuestionSubmitted,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 2.v),
            child: Icon(
              Icons.check_circle,
              size: 30.h,
              color: appTheme.lightGreenA700.withOpacity(0.60),
              // color: Colors.greenAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class RadioItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Function onTap;
  final Function onChange;
  const RadioItemWidget(
      {required this.title,
      required this.value,
      required this.groupValue,
      required this.onTap,
      required this.onChange,
      key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(5.v),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.v),
          border: Border.all(
            color: appTheme.orange300,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: (String? value) {
                onChange(value);
              },
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8.h),
              child: Text(title,
                  style: CustomTextStyles.labelLargeSFProTextBluegray900),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../../../general_data.dart';
import '../models/listone_item_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class ListoneItemWidget extends StatefulWidget {
  ListoneItemWidget(
    this.visitModel, {
    required this.isPm,
    Key? key,
  }) : super(
          key: key,
        );

  VisitModel visitModel;
  bool isPm;

  @override
  State<ListoneItemWidget> createState() => _ListoneItemWidgetState();
}

class _ListoneItemWidgetState extends State<ListoneItemWidget> {
  //
  String groupValue = "normal";
  //
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            GeneralData.selectedRepId = widget.visitModel.rep.id!;
            GeneralData.selectedVisitId = widget.visitModel.id;
            NavigatorService.pushNamed(
              AppRoutes.questionsScreen,
              arguments: {
                'type': groupValue,
                'medicalRepName': widget.visitModel.rep.firstName,
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 8.v,
            ),
            decoration: widget.isPm
                ? AppDecoration.fillBlue.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  )
                : AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
            child: Padding(
              padding: EdgeInsets.only(top: 3.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        "${widget.visitModel.location.name}",
                        // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                        // listoneItemModelObj.elgawyHospital!,
                        style: CustomTextStyles.labelLargeSFProTextBluegray900,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.v),
                  Row(
                    children: [
                      Icon(
                        Icons.accessibility,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Text(
                        "${widget.visitModel.rep.firstName}",
                        // "${visitModel.rep.firstName} ${visitModel.rep.lastName}",
                        // listoneItemModelObj.elgawyHospital!,
                        style: CustomTextStyles.labelLargeSFProTextBluegray900,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.v),
                  Row(
                    children: [
                      // CustomImageView(
                      //   imagePath: ImageConstant.imgMapMarker,
                      //   height: 10.adaptSize,
                      //   width: 10.adaptSize,
                      //   margin: EdgeInsets.only(bottom: 2.v),
                      // ),
                      Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "${widget.visitModel.location.address}",
                          // listoneItemModelObj.nasrCityOne!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RadioItemWidget(
                        title: "Normal",
                        value: "normal",
                        groupValue: groupValue,
                        onTap: () {
                          setState(() {
                            groupValue = "normal";
                          });
                        },
                        onChange: (_) {
                          setState(() {
                            groupValue = "normal";
                          });
                        },
                      ),
                      RadioItemWidget(
                        title: "Flash",
                        value: "flash",
                        groupValue: groupValue,
                        onTap: () {
                          setState(() {
                            groupValue = "flash";
                          });
                        },
                        onChange: (_) {
                          setState(() {
                            groupValue = "flash";
                          });
                        },
                      ),
                    ],
                  ),
 Row(
                    children: [
                      InkWell(
                        onTap: () {
                          GeneralData.selectedRepId = widget.visitModel.rep.id!;
                          GeneralData.selectedVisitId = widget.visitModel.id;
                          NavigatorService.pushNamed(
                            AppRoutes.questionsScreen,
                            arguments: {'type': 'normal'},
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.h,
                            vertical: 3.v,
                          ),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 9.adaptSize,
                                width: 9.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                                decoration: BoxDecoration(
                                  color: appTheme.lightGreenA700,
                                  borderRadius: BorderRadius.circular(
                                    4.h,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: Text(
                                  "Normal",
                                  // listoneItemModelObj.normal!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          GeneralData.selectedRepId = widget.visitModel.rep.id!;
                          GeneralData.selectedVisitId = widget.visitModel.id;
                          NavigatorService.pushNamed(
                            AppRoutes.questionsScreen,
                            arguments: {'type': 'flash'},
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 37.v),
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.h,
                            vertical: 3.v,
                          ),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder3,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 9.adaptSize,
                                width: 9.adaptSize,
                                margin: EdgeInsets.symmetric(vertical: 1.v),
                                decoration: BoxDecoration(
                                  color: appTheme.orange300,
                                  borderRadius: BorderRadius.circular(
                                    4.h,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.h),
                                child: Text(
                                  "Flash",
                                  // listoneItemModelObj.flash!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.visitModel.isQuestionSubmitted,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Icon(
              Icons.check_circle,
              size: 40.h,
              color: appTheme.lightGreenA700.withOpacity(0.60),
              // color: Colors.greenAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class RadioItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Function onTap;
  final Function onChange;
  const RadioItemWidget(
      {required this.title,
      required this.value,
      required this.groupValue,
      required this.onTap,
      required this.onChange,
      key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(5.v),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.v),
          border: Border.all(
            color: appTheme.orange300,
          ),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: (String? value) {
                onChange(value);
              },
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8.h),
              child: Text(title,
                  style: CustomTextStyles.labelLargeSFProTextBluegray900),
            ),
          ],
        ),
      ),
    );
  }
}
*/
