import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/add_medical_rep_dialog/rep_dialog_item.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/cubit/calendar_cubit.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/location_model.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/widgets/custom_search_view.dart';
import '../../general_data.dart';
import 'cubit/add_medical_rep_cubit.dart';
import 'location_dialog_item.dart';
import 'models/add_medical_rep_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/add_medical_rep_bloc.dart';

// ignore_for_file: must_be_immutable
class AddMedicalRepDialog extends StatefulWidget {
  const AddMedicalRepDialog({Key? key})
      : super(
          key: key,
        );

  // static Widget builder(BuildContext context) {
  //   return BlocProvider<AddMedicalRepBloc>(
  //     create: (context) => AddMedicalRepBloc(AddMedicalRepState(
  //       addMedicalRepModelObj: AddMedicalRepModel(),
  //     ))
  //       ..add(AddMedicalRepInitialEvent()),
  //     child: AddMedicalRepDialog(),
  //   );
  // }
  static Widget builder(BuildContext context) {
    return BlocProvider<AddMedicalRepCubit>(
      create: (context) => AddMedicalRepCubit(
        apiClient: ApiClient(),
        calendarCubit: GeneralData.calendarCubit,
      ),
      child: AddMedicalRepDialog(),
    );
  }

  @override
  State<AddMedicalRepDialog> createState() => _AddMedicalRepDialogState();
}

class _AddMedicalRepDialogState extends State<AddMedicalRepDialog> {
  //
  // bool isLoading = true;
  @override
  void initState() {
    BlocProvider.of<AddMedicalRepCubit>(context).getMedicalReps();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 313.h,
          padding: EdgeInsets.symmetric(
            horizontal: 13.h,
            vertical: 14.v,
          ),
          decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder17,
              color: Colors.white),
          child: Material(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(left: 84.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.v),
                          child: Text(
                            "lbl_add_medical_rep".tr,
                            style: CustomTextStyles.titleSmallBlack900,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgXBlueGray900,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                          margin: EdgeInsets.only(
                            left: 59.h,
                            bottom: 2.v,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.v),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 16.h,
                //     right: 8.h,
                //   ),
                //   child: BlocSelector<AddMedicalRepBloc, AddMedicalRepState,
                //       TextEditingController?>(
                //     selector: (state) => state.searchController,
                //     builder: (context, searchController) {
                //       return CustomSearchView(
                //         controller: searchController,
                //         hintText: "lbl_search".tr,
                //         borderDecoration: SearchViewStyleHelper.fillGray,
                //         fillColor: appTheme.gray100,
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(height: 8.v),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 16.h),
                //     child: Text(
                //       "lbl_recent".tr,
                //       style: CustomTextStyles.bodySmallPrimary,
                //     ),
                //   ),
                // ),
                // SizedBox(height: 3.v),

                BlocBuilder<AddMedicalRepCubit, AddMedicalRepState>(
                  builder: (context, state) {
                    if (state is AddMedicalRepLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is GetRepsSuccessState) {
                      final repList = BlocProvider.of<AddMedicalRepCubit>(
                        context,
                      ).reps;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: ListView.separated(
                          itemCount: repList.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5.v);
                          },
                          itemBuilder: (context, index) {
                            return RepDialogItem(repModel: repList[index]);
                          },
                        ),
                      );
                    } else if (state is GetLocationsSuccessState) {
                      final locations = BlocProvider.of<AddMedicalRepCubit>(
                        context,
                      ).locations;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: ListView.separated(
                          itemCount: locations.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5.v);
                          },
                          itemBuilder: (context, index) {
                            return LocationDialogItem(
                                locationModel: locations[index]);
                          },
                        ),
                      );
                    } else if (state is ShowSubmitState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Column(
                          children: <Widget>[
                            RadioListTile<String>(
                              title: const Text('AM'),
                              value: "am",
                              groupValue:
                                  BlocProvider.of<AddMedicalRepCubit>(context)
                                      .shift,
                              onChanged: (value) {
                                setState(() {
                                  BlocProvider.of<AddMedicalRepCubit>(context)
                                      .shift = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('PM'),
                              value: "pm",
                              groupValue:
                                  BlocProvider.of<AddMedicalRepCubit>(context)
                                      .shift,
                              onChanged: (value) {
                                setState(() {
                                  BlocProvider.of<AddMedicalRepCubit>(context)
                                      .shift = value!;
                                });
                              },
                            ),
                            // ListTile(
                            //   title: const Text('PM'),
                            //   leading: Radio<String>(
                            //     value: "pm",
                            //     groupValue:
                            //         BlocProvider.of<AddMedicalRepCubit>(context)
                            //             .shift,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         BlocProvider.of<AddMedicalRepCubit>(context)
                            //             .shift = value!;
                            //       });
                            //     },
                            //   ),
                            // ),
                            Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      fontSize: 18.fSize,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await BlocProvider.of<AddMedicalRepCubit>(
                                          context)
                                      .createVisit();
                                },
                              ),
                            ),
                            // RadioListTile<String>(
                            //   value: "PM",
                            //   groupValue:
                            //       BlocProvider.of<AddMedicalRepCubit>(context)
                            //           .shift,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       BlocProvider.of<AddMedicalRepCubit>(context)
                            //           .shift = value!;
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                      );
                    } else if (state is FinishSubmitState) {
                      Navigator.pop(context);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: 13.v),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
