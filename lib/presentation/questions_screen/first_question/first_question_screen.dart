import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/presentation/questions_screen/first_question/first_build_category_with_questions.dart';

import '../../../data/apiClient/api_client.dart';
import '../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../first_question/cubit/first_question_cubit.dart';
import '../questions_screen.dart';

class FirstQuestionScreen extends StatefulWidget {
  @override
  State<FirstQuestionScreen> createState() => _FirstQuestionScreenState();

  static Widget builder(BuildContext context) {
    return BlocProvider<FirstQuestionCubit>(
      create: (context) => FirstQuestionCubit(
          ApiClient(), BlocProvider.of<GeneralCubit>(context)),
      child: FirstQuestionScreen(),
    );
  }
}

class _FirstQuestionScreenState extends State<FirstQuestionScreen> {
  //
  //
  late String questionType;
  late int visitId;
  late int locationId;
  late String locationType;
  late String medicalRepName;

  //
/*  handleScreenData() async {
    if (visitId == -1) {
      //we need to create visit first
      final theVisitId = await BlocProvider.of<FirstQuestionCubit>(context)
          .getQuestionCategoriesAndCreateVisit(
              questionType, locationId, locationType);
      visitId = theVisitId;
    } else {
      BlocProvider.of<FirstQuestionCubit>(context)
          .getQuestionCategoriesForAlreadyCreatedVisit(questionType);
    }
  }*/

  handleScreenData() async {
    BlocProvider.of<FirstQuestionCubit>(context)
        .getSavedLocallyQuestions(questionType);
  }

  //
  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    questionType = routeArgs['type'];
    visitId = routeArgs['visitId'];
    locationId = routeArgs['locationId'];
    locationType = routeArgs['locationType'];
    // medicalRepName = routeArgs['medicalRepName'];
    handleScreenData();
    super.didChangeDependencies();
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: BlocBuilder<FirstQuestionCubit, FirstQuestionState>(
          builder: (context, state) {
            if (state is FirstQuestionsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FirstQuestionsSuccess) {
              return SizedBox(
                width: SizeUtils.width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16.v),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Column(
                      children: [
                        // AnotherStepper(
                        //   stepperDirection: Axis.horizontal,
                        //   activeIndex: 0,
                        //   barThickness: 1,
                        //   inverted: true,
                        //   stepperList: [
                        //     StepperData(),
                        //     StepperData(
                        //       iconWidget: SizedBox(
                        //         height: 12.adaptSize,
                        //         width: 12.adaptSize,
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Align(
                        //               alignment: Alignment.center,
                        //               child: Container(
                        //                 height: 12.adaptSize,
                        //                 width: 12.adaptSize,
                        //                 decoration: BoxDecoration(
                        //                   color: appTheme.teal50,
                        //                   borderRadius: BorderRadius.circular(
                        //                     6.h,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             CustomImageView(
                        //               imagePath: ImageConstant.imgGroup36958,
                        //               height: 12.adaptSize,
                        //               width: 12.adaptSize,
                        //               alignment: Alignment.center,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     StepperData(
                        //       iconWidget: SizedBox(
                        //         height: 12.adaptSize,
                        //         width: 12.adaptSize,
                        //         child: Stack(
                        //           alignment: Alignment.centerLeft,
                        //           children: [
                        //             Align(
                        //               alignment: Alignment.center,
                        //               child: Container(
                        //                 height: 12.adaptSize,
                        //                 width: 12.adaptSize,
                        //                 decoration: BoxDecoration(
                        //                   color: theme.colorScheme.primary,
                        //                   borderRadius: BorderRadius.circular(
                        //                     6.h,
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             Align(
                        //               alignment: Alignment.centerLeft,
                        //               child: Container(
                        //                 height: 6.adaptSize,
                        //                 width: 6.adaptSize,
                        //                 margin: EdgeInsets.only(left: 2.h),
                        //                 decoration: BoxDecoration(
                        //                   color: theme.colorScheme.onPrimary,
                        //                   borderRadius: BorderRadius.circular(
                        //                     3.h,
                        //                   ),
                        //                   border: Border.all(
                        //                     color: theme.colorScheme.onPrimary,
                        //                     width: 1.h,
                        //                   ),
                        //                   boxShadow: [
                        //                     BoxShadow(
                        //                       color: appTheme.gray50021,
                        //                       spreadRadius: 2.h,
                        //                       blurRadius: 2.h,
                        //                       offset: Offset(
                        //                         0,
                        //                         4,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 8.v),
                        FirstBuildCategoryWithQuestions(
                          categoryModel:
                              BlocProvider.of<FirstQuestionCubit>(context)
                                  .questionsCategories[0],
                        ),
                        SizedBox(height: 16.v),
                        CustomElevatedButton(
                          text: "lbl_submit".tr,
                          onPressed: () async {
                            final result =
                                BlocProvider.of<FirstQuestionCubit>(context)
                                    .areAllQuestionsAnswered();
                            if (result == false) {
                              ProgressDialogUtils.showWarningDialog(
                                  context,
                                  'Keep Note!',
                                  'Some questions were not answered');
                              return;
                            } else {
                              await BlocProvider.of<FirstQuestionCubit>(context)
                                  .submitFirstQuestion();
                              NavigatorService.popAndPushNamed(
                                AppRoutes.questionsScreen,
                                arguments: {
                                  'type': questionType,
                                  'visitId': -1,
                                  'locationId': locationId,
                                  'locationType': locationType,
                                  // 'medicalRepName': widget.locationModel.rep.firstName,
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  //
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 4.v,
          bottom: 3.v,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "$questionType" == "normal" ? "Normal" : "Flash",
      ),
    );
  }
}
