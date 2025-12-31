import 'package:flutter/material.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/intended_visit_model.dart';

import '../../core/app_export.dart';
import '../../general_helper.dart';
import '../calendar_container_screen/models/rep_model.dart';
import 'add_medical_rep_dialog.dart';
import 'cubit/add_medical_rep_cubit.dart';

class RepDialogItem extends StatelessWidget {
  final TinyRepModel repModel;
  final bool isNSM;
  const RepDialogItem({required this.repModel, required this.isNSM, Key? key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // await BlocProvider.of<AddMedicalRepCubit>(context)
        //     .getRepLocations(repModel.id);
        if (isNSM) {
          // repModel.id is DM id in this case because NSM is selecting DM
          GeneralData.selectedDistrictManager = repModel.id;
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AddMedicalRepDialog.builder(context, isNSM: false);
            },
          );
        } else {
          await BlocProvider.of<AddMedicalRepCubit>(context)
              .addIntendedVisit(IntendedVisitModel(
            districtManagerId: GeneralData.selectedDistrictManager,
            repName: repModel.username,
            stringDate:
                GeneralHelper.formatDateForApi(GeneralData.selectedDate),
            repId: repModel.id,
            endOfTheDayClicked: false,
          ));
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 16.h,
          right: 10.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 6.h,
          vertical: 4.v,
        ),
        decoration: AppDecoration.fillGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder3,
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.v, horizontal: 6.h),
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 6.h),
              Expanded(
                child: Text(
                  "${repModel.username}",
                  // "lbl_ahmed_essam".tr,
                  style: CustomTextStyles.bodySmallBlack90012,
                ),
              ),
              // CustomImageView(
              //   imagePath: ImageConstant.imgCheckedBox,
              //   height: 24.adaptSize,
              //   width: 24.adaptSize,
              //   margin: EdgeInsets.symmetric(vertical: 3.v),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
