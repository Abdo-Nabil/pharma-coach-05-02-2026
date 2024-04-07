import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/questions_screen/cubit/questions_cubit.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/category_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';
import 'package:mina_s_application5/widgets/custom_icon_button.dart';
import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_leading_image.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'package:mina_s_application5/widgets/custom_text_form_field.dart';
import 'models/question_model.dart';
import 'models/questions_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/questions_bloc.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key})
      : super(
          key: key,
        );

  // static Widget builder(BuildContext context) {
  //   return BlocProvider<QuestionsBloc>(
  //     create: (context) => QuestionsBloc(QuestionsState(
  //       questionsModelObj: QuestionsModel(),
  //     ))
  //       ..add(QuestionsInitialEvent()),
  //     child: QuestionsScreen(),
  //   );
  // }
  static Widget builder(BuildContext context) {
    return BlocProvider<QuestionsCubit>(
      create: (context) => QuestionsCubit(ApiClient()),
      child: QuestionsScreen(),
    );
  }

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  //
  late String questionType;
  late String medicalRepName;

  //
  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    questionType = routeArgs['type'];
    // medicalRepName = routeArgs['medicalRepName'];
    BlocProvider.of<QuestionsCubit>(context)
        .getQuestionCategories(questionType);
    super.didChangeDependencies();
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: BlocBuilder<QuestionsCubit, QuestionsState>(
          builder: (context, state) {
            if (state is QuestionsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is QuestionsSuccess) {
              return SizedBox(
                width: SizeUtils.width,
                child: Container(
                  margin: EdgeInsets.only(bottom: 5.v),
                  padding: EdgeInsets.symmetric(horizontal: 14.h),
                  child: Column(
                    children: [
                      /*
                      AnotherStepper(
                        stepperDirection: Axis.horizontal,
                        activeIndex: 0,
                        barThickness: 1,
                        inverted: true,
                        stepperList: [
                          StepperData(),
                          StepperData(
                            iconWidget: SizedBox(
                              height: 12.adaptSize,
                              width: 12.adaptSize,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 12.adaptSize,
                                      width: 12.adaptSize,
                                      decoration: BoxDecoration(
                                        color: appTheme.teal50,
                                        borderRadius: BorderRadius.circular(
                                          6.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomImageView(
                                    imagePath: ImageConstant.imgGroup36959,
                                    height: 12.adaptSize,
                                    width: 12.adaptSize,
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StepperData(),
                        ],
                      ),
*/
                      SizedBox(height: 24.v),
                      Expanded(
                        child: ListView.separated(
                          itemCount: BlocProvider.of<QuestionsCubit>(context)
                              .questionsCategories
                              .length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 16.v);
                          },
                          itemBuilder: (context, index) {
                            final questions =
                                BlocProvider.of<QuestionsCubit>(context)
                                    .questionsCategories;
                            return BuildCategoryWithQuestions(
                                categoryModel: questions[index]);
                          },
                        ),
                      ),
                      SizedBox(height: 12.v),
                      SizedBox(height: 8.v),
                      Visibility(
                          visible: BlocProvider.of<QuestionsCubit>(context)
                              .questionsCategories
                              .isNotEmpty,
                          child: _buildSubmit(context)),
                      SizedBox(height: 15.v),
                    ],
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

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      // leading: AppbarLeadingImage(
      //   imagePath: ImageConstant.imgArrowLeft,
      //   margin: EdgeInsets.only(
      //     left: 16.h,
      //     top: 4.v,
      //     bottom: 3.v,
      //   ),
      // ),
      centerTitle: true,
      title: Text(
        // "$medicalRepName - $questionType",
        "$questionType",
        style: CustomTextStyles.titleSmallBlack900,
      ),
      // title: AppbarTitle(
      //   text: "msg_medical_rep_s_name".tr,
      // ),
    );
  }

  /// Section Widget
  Widget _buildSubmit(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_submit".tr,
      onPressed: () async {
        if (!BlocProvider.of<QuestionsCubit>(context)
            .areAllQuestionsAnswered()) {
          ProgressDialogUtils.showWarningDialog(
              context, 'Keep Note!', 'Some questions were not answered');
          return;
        }
        ProgressDialogUtils.showProgressDialog(isCancellable: false);
        //
        final isSuccess = await BlocProvider.of<QuestionsCubit>(context)
            .submitQuestionAnswers();
        //
        ProgressDialogUtils.hideProgressDialog();
        ProgressDialogUtils.showSubmitSuccessDialog(context);
        //
        // if (isSuccess) {
        //   ProgressDialogUtils.hideProgressDialog();
        //   ProgressDialogUtils.showSubmitSuccessDialog(context);
        // } else {
        //   ProgressDialogUtils.hideProgressDialog();
        //   ProgressDialogUtils.showErrorDialog(context);
        // }
      },
    );
  }
}

class QuestionItem extends StatefulWidget {
  final QuestionModel questionModel;
  const QuestionItem({required this.questionModel});

  @override
  State<QuestionItem> createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem>
    with AutomaticKeepAliveClientMixin {
  bool? isTrue;
  @override
  Widget build(BuildContext context) {
    //
    _saveAnswer(bool isTrue) {
      final answer = QuestionAnswerModel(
          categoryId: widget.questionModel.categoryId,
          questionId: widget.questionModel.id,
          answer: isTrue ? 1 : 0);
      //
      int index = BlocProvider.of<QuestionsCubit>(context).answers.indexWhere(
          (element) =>
              element.categoryId == widget.questionModel.categoryId &&
              element.questionId == widget.questionModel.id);
      //
      if (index == -1) {
        BlocProvider.of<QuestionsCubit>(context).answers.add(answer);
      } else {
        BlocProvider.of<QuestionsCubit>(context).answers[index] = answer;
      }
    }

    //
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.0.v),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 7.v,
            ),
            decoration: AppDecoration.fillBlue.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 9.v,
                      bottom: 8.v,
                    ),
                    child: Text(
                      widget.questionModel.body,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: appTheme.blueGray900,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Spacer(),
                //////////////////////////////////////////////
                GestureDetector(
                  onTap: () {
                    isTrue = true;
                    _saveAnswer(isTrue!);
                    setState(() {});
                  },
                  child: CustomIconButton(
                    height: 35.adaptSize,
                    width: 35.adaptSize,
                    padding: EdgeInsets.all(5.h),
                    decoration: (isTrue == null || isTrue == false)
                        ? IconButtonStyleHelper.outlineLightGreenATL8
                        : IconButtonStyleHelper.outlineLightGreenA,
                    child: CustomImageView(
                      imagePath: (isTrue == null || isTrue == false)
                          ? ImageConstant.imgCheckLightGreenA70002
                          : ImageConstant.imgCheck,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isTrue = false;
                    _saveAnswer(isTrue!);
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.h,
                      right: 3.h,
                    ),
                    child: CustomIconButton(
                      height: 35.adaptSize,
                      width: 35.adaptSize,
                      padding: EdgeInsets.all(5.h),
                      decoration: (isTrue == null || isTrue == true)
                          ? IconButtonStyleHelper.outlineOnPrimaryContainer
                          : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
                      // decoration:
                      //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
                      child: CustomImageView(
                        // imagePath: ImageConstant.imgXOnprimary,
                        imagePath: (isTrue == null || isTrue == true)
                            ? ImageConstant.imgX
                            : ImageConstant.imgXOnprimary,
                      ),
                    ),
                  ),
                ),
                //////////////////////////////////////////////
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/////////////////////////////////////////////////////////////

class BuildCategoryWithQuestions extends StatelessWidget {
  final CategoryModel categoryModel;
  const BuildCategoryWithQuestions({
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          onPressed: () {
            ProgressDialogUtils.showCategoryInfo(context, categoryModel.id);
          },
          height: 40.v,
          text: categoryModel.title,
          rightIcon: Container(
            margin: EdgeInsets.only(left: 30.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgInforectangleTeal50,
              height: 24.adaptSize,
              width: 24.adaptSize,
            ),
          ),
          buttonStyle: CustomButtonStyles.fillPrimaryTL12,
          buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
        ),
        SizedBox(height: 10.v),
        ...List.generate(categoryModel.questions.length, (index) {
          return QuestionItem(questionModel: categoryModel.questions[index]);
        }),

        // Expanded(
        //     child: ListView.builder(
        //   itemCount: 5,
        //   itemBuilder: (context, index) {
        //     return QuestionItem();
        //   },
        // ))
      ],
    );
  }
}

// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
// import 'package:mina_s_application5/widgets/custom_icon_button.dart';
// import 'package:mina_s_application5/widgets/app_bar/custom_app_bar.dart';
// import 'package:mina_s_application5/widgets/app_bar/appbar_leading_image.dart';
// import 'package:mina_s_application5/widgets/app_bar/appbar_title.dart';
// import 'package:another_stepper/widgets/another_stepper.dart';
// import 'package:another_stepper/dto/stepper_data.dart';
// import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
// import 'package:mina_s_application5/widgets/custom_text_form_field.dart';
// import 'models/questions_model.dart';
// import 'package:flutter/material.dart';
// import 'package:mina_s_application5/core/app_export.dart';
// import 'bloc/questions_bloc.dart';
//
// class QuestionsScreen extends StatefulWidget {
//   const QuestionsScreen({Key? key})
//       : super(
//           key: key,
//         );
//
//   static Widget builder(BuildContext context) {
//     return BlocProvider<QuestionsBloc>(
//       create: (context) => QuestionsBloc(QuestionsState(
//         questionsModelObj: QuestionsModel(),
//       ))
//         ..add(QuestionsInitialEvent()),
//       child: QuestionsScreen(),
//     );
//   }
//
//   @override
//   State<QuestionsScreen> createState() => _QuestionsScreenState();
// }
//
// class _QuestionsScreenState extends State<QuestionsScreen> {
//   //
//   late String questionType;
//   @override
//   void didChangeDependencies() {
//     final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
//     questionType = routeArgs['type'];
//     super.didChangeDependencies();
//   }
//
//   //
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: _buildAppBar(context),
//         body: SizedBox(
//           width: SizeUtils.width,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(top: 16.v),
//             child: Container(
//               margin: EdgeInsets.only(bottom: 5.v),
//               padding: EdgeInsets.symmetric(horizontal: 14.h),
//               child: Column(
//                 children: [
//                   AnotherStepper(
//                     stepperDirection: Axis.horizontal,
//                     activeIndex: 0,
//                     barThickness: 1,
//                     inverted: true,
//                     stepperList: [
//                       StepperData(),
//                       StepperData(
//                         iconWidget: SizedBox(
//                           height: 12.adaptSize,
//                           width: 12.adaptSize,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: Container(
//                                   height: 12.adaptSize,
//                                   width: 12.adaptSize,
//                                   decoration: BoxDecoration(
//                                     color: appTheme.teal50,
//                                     borderRadius: BorderRadius.circular(
//                                       6.h,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               CustomImageView(
//                                 imagePath: ImageConstant.imgGroup36959,
//                                 height: 12.adaptSize,
//                                 width: 12.adaptSize,
//                                 alignment: Alignment.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       StepperData(),
//                     ],
//                   ),
//                   SizedBox(height: 24.v),
//                   _buildPharmacyFeedback(context),
//                   SizedBox(height: 12.v),
//                   Padding(
//                     padding: EdgeInsets.only(left: 1.h),
//                     child: _buildSetsmartcallobjectives(
//                       context,
//                       setsmartcallobjectives: "msg_rate_stock_our".tr,
//                     ),
//                   ),
//                   SizedBox(height: 23.v),
//                   _buildPreCallPlanning(context),
//                   SizedBox(height: 4.v),
//                   _buildReviewCustomer(context),
//                   SizedBox(height: 4.v),
//                   Padding(
//                     padding: EdgeInsets.only(left: 1.h),
//                     child: _buildSetsmartcallobjectives(
//                       context,
//                       setsmartcallobjectives:
//                           "msg_set_smart_call_objectives".tr,
//                     ),
//                   ),
//                   SizedBox(height: 8.v),
//                   _buildOpeningRapport(context),
//                   SizedBox(height: 15.v),
//                   _buildFriendlyGreeting(context),
//                   SizedBox(height: 17.v),
//                   Padding(
//                     padding: EdgeInsets.only(left: 2.h),
//                     child: _buildSetsmartcallobjectives(
//                       context,
//                       setsmartcallobjectives: "lbl_ice_breaker".tr,
//                     ),
//                   ),
//                   SizedBox(height: 4.v),
//                   Padding(
//                     padding: EdgeInsets.only(left: 2.h),
//                     child: _buildSetsmartcallobjectives(
//                       context,
//                       setsmartcallobjectives: "msg_specific_patient".tr,
//                     ),
//                   ),
//                   SizedBox(height: 8.v),
//                   _buildUncoveringNeeds(context),
//                   SizedBox(height: 15.v),
//                   _buildAskingInsightful(context),
//                   SizedBox(height: 14.v),
//                   _buildActivelistening(context),
//                   SizedBox(height: 8.v),
//                   _buildPositioningBrandBenefits(context),
//                   SizedBox(height: 15.v),
//                   _buildLinkProductFeatureS(context),
//                   SizedBox(height: 28.v),
//                   _buildHighlightEmotional(context),
//                   SizedBox(height: 21.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_proper_use_of_e_detaling".tr,
//                     ),
//                   ),
//                   SizedBox(height: 15.v),
//                   _buildClosing(context),
//                   SizedBox(height: 15.v),
//                   _buildSummarizeOnThe(context),
//                   SizedBox(height: 28.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_ask_for_specific".tr,
//                     ),
//                   ),
//                   SizedBox(height: 18.v),
//                   _buildBridgingToNextProducts(context),
//                   SizedBox(height: 11.v),
//                   _buildPatientProfile(context),
//                   SizedBox(height: 23.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_link_product_feature_s".tr,
//                     ),
//                   ),
//                   SizedBox(height: 23.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_ask_for_commitment".tr,
//                     ),
//                   ),
//                   SizedBox(height: 15.v),
//                   _buildReminderProduct(context),
//                   SizedBox(height: 19.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_made_an_effective".tr,
//                     ),
//                   ),
//                   SizedBox(height: 20.v),
//                   _buildPostCallAnalysis(context),
//                   SizedBox(height: 11.v),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     child: _buildAskForSpecific(
//                       context,
//                       askForSpecific: "msg_mr_self_assessment".tr,
//                     ),
//                   ),
//                   SizedBox(height: 23.v),
//                   _buildSubmit(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Section Widget
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//       leadingWidth: 40.h,
//       // leading: AppbarLeadingImage(
//       //   imagePath: ImageConstant.imgArrowLeft,
//       //   margin: EdgeInsets.only(
//       //     left: 16.h,
//       //     top: 4.v,
//       //     bottom: 3.v,
//       //   ),
//       // ),
//       centerTitle: true,
//       title: AppbarTitle(
//         text: "msg_medical_rep_s_name".tr,
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildPharmacyFeedback(BuildContext context) {
//     return Container(
//       width: 343.h,
//       margin: EdgeInsets.only(
//         left: 1.h,
//         right: 3.h,
//       ),
//       padding: EdgeInsets.symmetric(
//         horizontal: 9.h,
//         vertical: 8.v,
//       ),
//       decoration: AppDecoration.fillPrimary.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder10,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: Padding(
//               padding: EdgeInsets.only(left: 97.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 3.v),
//                     child: Text(
//                       "msg_pharmacy_feedback".tr,
//                       style: CustomTextStyles.bodyMediumOnPrimary,
//                     ),
//                   ),
//                   CustomImageView(
//                     imagePath: ImageConstant.imgInfoRectangle,
//                     height: 24.adaptSize,
//                     width: 24.adaptSize,
//                     margin: EdgeInsets.only(left: 72.h),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 4.v),
//           Container(
//             width: 305.h,
//             margin: EdgeInsets.only(
//               left: 9.h,
//               right: 10.h,
//             ),
//             child: Text(
//               "msg_the_rep_can_get".tr,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: CustomTextStyles.bodySmallOnPrimary9,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildPreCallPlanning(BuildContext context) {
//     return CustomElevatedButton(
//       height: 40.v,
//       text: "msg_pre_call_planning".tr,
//       rightIcon: Container(
//         margin: EdgeInsets.only(left: 30.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgInforectangleTeal50,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.fillPrimaryTL12,
//       buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildReviewCustomer(BuildContext context) {
//     return Container(
//       width: 345.h,
//       margin: EdgeInsets.only(left: 1.h),
//       padding: EdgeInsets.symmetric(
//         horizontal: 12.h,
//         vertical: 11.v,
//       ),
//       decoration: AppDecoration.fillOnPrimary.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder10,
//       ),
//       child: SizedBox(
//         width: 190.h,
//         child: Text(
//           "msg_review_customer".tr,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: theme.textTheme.bodyMedium,
//         ),
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildOpeningRapport(BuildContext context) {
//     return CustomElevatedButton(
//       height: 40.v,
//       text: "msg_opening_rapport".tr,
//       rightIcon: Container(
//         margin: EdgeInsets.only(left: 30.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgInforectangleTeal50,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.fillPrimaryTL12,
//       buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildFriendlyGreeting(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 177.h,
//                 child: Text(
//                   "msg_friendly_greeting".tr,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodyMedium,
//                 ),
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   isTrue = true;
//                   setState(() {});
//                 },
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == false)
//                       ? IconButtonStyleHelper.outlineLightGreenATL8
//                       : IconButtonStyleHelper.outlineLightGreenA,
//                   child: CustomImageView(
//                     imagePath: (isTrue == null || isTrue == false)
//                         ? ImageConstant.imgCheckLightGreenA70002
//                         : ImageConstant.imgCheck,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   isTrue = false;
//                   setState(() {});
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: 8.h,
//                     right: 3.h,
//                   ),
//                   child: CustomIconButton(
//                     height: 35.adaptSize,
//                     width: 35.adaptSize,
//                     padding: EdgeInsets.all(5.h),
//                     decoration: (isTrue == null || isTrue == true)
//                         ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                         : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     // decoration:
//                     //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     child: CustomImageView(
//                       // imagePath: ImageConstant.imgXOnprimary,
//                       imagePath: (isTrue == null || isTrue == true)
//                           ? ImageConstant.imgX
//                           : ImageConstant.imgXOnprimary,
//                     ),
//                   ),
//                 ),
//               ),
//               // SizedBox(
//               //   height: 35.adaptSize,
//               //   width: 35.adaptSize,
//               //   child: Stack(
//               //     alignment: Alignment.center,
//               //     children: [
//               //       Align(
//               //         alignment: Alignment.center,
//               //         child: Container(
//               //           height: 35.adaptSize,
//               //           width: 35.adaptSize,
//               //           decoration: BoxDecoration(
//               //             borderRadius: BorderRadius.circular(
//               //               8.h,
//               //             ),
//               //             border: Border.all(
//               //               color: appTheme.lightGreenA70001,
//               //               width: 1.h,
//               //             ),
//               //           ),
//               //         ),
//               //       ),
//               //       CustomImageView(
//               //         imagePath: ImageConstant.imgCheckLightGreenA70002,
//               //         height: 24.adaptSize,
//               //         width: 24.adaptSize,
//               //         alignment: Alignment.center,
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.only(left: 8.h),
//               //   child: CustomIconButton(
//               //     height: 35.adaptSize,
//               //     width: 35.adaptSize,
//               //     padding: EdgeInsets.all(5.h),
//               //     child: CustomImageView(
//               //       imagePath: ImageConstant.imgX,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildUncoveringNeeds(BuildContext context) {
//     return CustomElevatedButton(
//       height: 40.v,
//       text: "msg_uncovering_needs".tr,
//       rightIcon: Container(
//         margin: EdgeInsets.only(left: 30.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgInforectangleTeal50,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.fillPrimaryTL12,
//       buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildAskingInsightful(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(builder: (context, setState) {
//       return Padding(
//         padding: EdgeInsets.only(
//           left: 13.h,
//           right: 16.h,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 182.h,
//               child: Text(
//                 "msg_asking_insightful".tr,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {
//                 isTrue = true;
//                 setState(() {});
//               },
//               child: CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: (isTrue == null || isTrue == false)
//                     ? IconButtonStyleHelper.outlineLightGreenATL8
//                     : IconButtonStyleHelper.outlineLightGreenA,
//                 child: CustomImageView(
//                   imagePath: (isTrue == null || isTrue == false)
//                       ? ImageConstant.imgCheckLightGreenA70002
//                       : ImageConstant.imgCheck,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 isTrue = false;
//                 setState(() {});
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 8.h,
//                   right: 3.h,
//                 ),
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == true)
//                       ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                       : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   // decoration:
//                   //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   child: CustomImageView(
//                     // imagePath: ImageConstant.imgXOnprimary,
//                     imagePath: (isTrue == null || isTrue == true)
//                         ? ImageConstant.imgX
//                         : ImageConstant.imgXOnprimary,
//                   ),
//                 ),
//               ),
//             ),
//             // CustomIconButton(
//             //   height: 35.adaptSize,
//             //   width: 35.adaptSize,
//             //   padding: EdgeInsets.all(5.h),
//             //   child: CustomImageView(
//             //     imagePath: ImageConstant.imgCheckLightGreenA70002,
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 8.h),
//             //   child: _buildX(context),
//             // ),
//           ],
//         ),
//       );
//     });
//   }
//
//   /// Section Widget
//   Widget _buildActivelistening(BuildContext context) {
//     return BlocSelector<QuestionsBloc, QuestionsState, TextEditingController?>(
//       selector: (state) => state.activelisteningController,
//       builder: (context, activelisteningController) {
//         return CustomTextFormField(
//           controller: activelisteningController,
//           hintText: "msg_active_listening".tr,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 12.h,
//             vertical: 16.v,
//           ),
//           borderDecoration: TextFormFieldStyleHelper.fillOnPrimary,
//           fillColor: theme.colorScheme.onPrimary,
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildPositioningBrandBenefits(BuildContext context) {
//     return BlocSelector<QuestionsBloc, QuestionsState, TextEditingController?>(
//       selector: (state) => state.positioningBrandBenefitsController,
//       builder: (context, positioningBrandBenefitsController) {
//         return CustomTextFormField(
//           controller: positioningBrandBenefitsController,
//           hintText: "msg_positioning_brand".tr,
//           suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 8.v, 10.h, 8.v),
//             child: CustomImageView(
//               imagePath: ImageConstant.imgInforectangleTeal50,
//               height: 24.adaptSize,
//               width: 24.adaptSize,
//             ),
//           ),
//           suffixConstraints: BoxConstraints(
//             maxHeight: 40.v,
//           ),
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildLinkProductFeatureS(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 178.h,
//                 child: Text(
//                   "msg_link_product_feature_s".tr,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodyMedium,
//                 ),
//               ),
//               Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   isTrue = true;
//                   setState(() {});
//                 },
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == false)
//                       ? IconButtonStyleHelper.outlineLightGreenATL8
//                       : IconButtonStyleHelper.outlineLightGreenA,
//                   child: CustomImageView(
//                     imagePath: (isTrue == null || isTrue == false)
//                         ? ImageConstant.imgCheckLightGreenA70002
//                         : ImageConstant.imgCheck,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   isTrue = false;
//                   setState(() {});
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: 8.h,
//                     right: 3.h,
//                   ),
//                   child: CustomIconButton(
//                     height: 35.adaptSize,
//                     width: 35.adaptSize,
//                     padding: EdgeInsets.all(5.h),
//                     decoration: (isTrue == null || isTrue == true)
//                         ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                         : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     // decoration:
//                     //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     child: CustomImageView(
//                       // imagePath: ImageConstant.imgXOnprimary,
//                       imagePath: (isTrue == null || isTrue == true)
//                           ? ImageConstant.imgX
//                           : ImageConstant.imgXOnprimary,
//                     ),
//                   ),
//                 ),
//               ),
//               // SizedBox(
//               //   height: 35.adaptSize,
//               //   width: 35.adaptSize,
//               //   child: Stack(
//               //     alignment: Alignment.center,
//               //     children: [
//               //       Align(
//               //         alignment: Alignment.center,
//               //         child: Container(
//               //           height: 35.adaptSize,
//               //           width: 35.adaptSize,
//               //           decoration: BoxDecoration(
//               //             borderRadius: BorderRadius.circular(
//               //               8.h,
//               //             ),
//               //             border: Border.all(
//               //               color: appTheme.lightGreenA70001,
//               //               width: 1.h,
//               //             ),
//               //           ),
//               //         ),
//               //       ),
//               //       CustomImageView(
//               //         imagePath: ImageConstant.imgCheckLightGreenA70002,
//               //         height: 24.adaptSize,
//               //         width: 24.adaptSize,
//               //         alignment: Alignment.center,
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.only(left: 8.h),
//               //   child: CustomIconButton(
//               //     height: 35.adaptSize,
//               //     width: 35.adaptSize,
//               //     padding: EdgeInsets.all(5.h),
//               //     child: CustomImageView(
//               //       imagePath: ImageConstant.imgX,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildHighlightEmotional(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(builder: (context, setState) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 142.h,
//               child: Text(
//                 "msg_highlight_emotional".tr,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {
//                 isTrue = true;
//                 setState(() {});
//               },
//               child: CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: (isTrue == null || isTrue == false)
//                     ? IconButtonStyleHelper.outlineLightGreenATL8
//                     : IconButtonStyleHelper.outlineLightGreenA,
//                 child: CustomImageView(
//                   imagePath: (isTrue == null || isTrue == false)
//                       ? ImageConstant.imgCheckLightGreenA70002
//                       : ImageConstant.imgCheck,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 isTrue = false;
//                 setState(() {});
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 8.h,
//                   right: 3.h,
//                 ),
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == true)
//                       ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                       : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   // decoration:
//                   //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   child: CustomImageView(
//                     // imagePath: ImageConstant.imgXOnprimary,
//                     imagePath: (isTrue == null || isTrue == true)
//                         ? ImageConstant.imgX
//                         : ImageConstant.imgXOnprimary,
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: 35.adaptSize,
//             //   width: 35.adaptSize,
//             //   child: Stack(
//             //     alignment: Alignment.center,
//             //     children: [
//             //       Align(
//             //         alignment: Alignment.center,
//             //         child: Container(
//             //           height: 35.adaptSize,
//             //           width: 35.adaptSize,
//             //           decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(
//             //               8.h,
//             //             ),
//             //             border: Border.all(
//             //               color: appTheme.lightGreenA70001,
//             //               width: 1.h,
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //       CustomImageView(
//             //         imagePath: ImageConstant.imgCheckLightGreenA70002,
//             //         height: 24.adaptSize,
//             //         width: 24.adaptSize,
//             //         alignment: Alignment.center,
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 8.h),
//             //   child: CustomIconButton(
//             //     height: 35.adaptSize,
//             //     width: 35.adaptSize,
//             //     padding: EdgeInsets.all(5.h),
//             //     child: CustomImageView(
//             //       imagePath: ImageConstant.imgX,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       );
//     });
//   }
//
//   /// Section Widget
//   Widget _buildClosing(BuildContext context) {
//     return BlocSelector<QuestionsBloc, QuestionsState, TextEditingController?>(
//       selector: (state) => state.closingController,
//       builder: (context, closingController) {
//         return CustomTextFormField(
//           controller: closingController,
//           hintText: "lbl_closing".tr,
//           suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 8.v, 10.h, 8.v),
//             child: CustomImageView(
//               imagePath: ImageConstant.imgInforectangleTeal50,
//               height: 24.adaptSize,
//               width: 24.adaptSize,
//             ),
//           ),
//           suffixConstraints: BoxConstraints(
//             maxHeight: 40.v,
//           ),
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildSummarizeOnThe(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(builder: (context, setState) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 180.h,
//               child: Text(
//                 "msg_summarize_on_the".tr,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {
//                 isTrue = true;
//                 setState(() {});
//               },
//               child: CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: (isTrue == null || isTrue == false)
//                     ? IconButtonStyleHelper.outlineLightGreenATL8
//                     : IconButtonStyleHelper.outlineLightGreenA,
//                 child: CustomImageView(
//                   imagePath: (isTrue == null || isTrue == false)
//                       ? ImageConstant.imgCheckLightGreenA70002
//                       : ImageConstant.imgCheck,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 isTrue = false;
//                 setState(() {});
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 8.h,
//                   right: 3.h,
//                 ),
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == true)
//                       ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                       : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   // decoration:
//                   //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   child: CustomImageView(
//                     // imagePath: ImageConstant.imgXOnprimary,
//                     imagePath: (isTrue == null || isTrue == true)
//                         ? ImageConstant.imgX
//                         : ImageConstant.imgXOnprimary,
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: 35.adaptSize,
//             //   width: 35.adaptSize,
//             //   child: Stack(
//             //     alignment: Alignment.center,
//             //     children: [
//             //       Align(
//             //         alignment: Alignment.center,
//             //         child: Container(
//             //           height: 35.adaptSize,
//             //           width: 35.adaptSize,
//             //           decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(
//             //               8.h,
//             //             ),
//             //             border: Border.all(
//             //               color: appTheme.lightGreenA70001,
//             //               width: 1.h,
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //       CustomImageView(
//             //         imagePath: ImageConstant.imgCheckLightGreenA70002,
//             //         height: 24.adaptSize,
//             //         width: 24.adaptSize,
//             //         alignment: Alignment.center,
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 8.h),
//             //   child: CustomIconButton(
//             //     height: 35.adaptSize,
//             //     width: 35.adaptSize,
//             //     padding: EdgeInsets.all(5.h),
//             //     child: CustomImageView(
//             //       imagePath: ImageConstant.imgX,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       );
//     });
//   }
//
//   /// Section Widget
//   Widget _buildBridgingToNextProducts(BuildContext context) {
//     return BlocSelector<QuestionsBloc, QuestionsState, TextEditingController?>(
//       selector: (state) => state.bridgingToNextProductsController,
//       builder: (context, bridgingToNextProductsController) {
//         return CustomTextFormField(
//           controller: bridgingToNextProductsController,
//           hintText: "msg_bridging_to_next".tr,
//           textInputAction: TextInputAction.done,
//           suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 8.v, 10.h, 8.v),
//             child: CustomImageView(
//               imagePath: ImageConstant.imgInforectangleTeal50,
//               height: 24.adaptSize,
//               width: 24.adaptSize,
//             ),
//           ),
//           suffixConstraints: BoxConstraints(
//             maxHeight: 40.v,
//           ),
//         );
//       },
//     );
//   }
//
//   /// Section Widget
//   Widget _buildPatientProfile(BuildContext context) {
//     bool? isTrue;
//     return StatefulBuilder(builder: (context, setState) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 15.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 9.v,
//                 bottom: 8.v,
//               ),
//               child: Text(
//                 "lbl_patient_profile".tr,
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {
//                 isTrue = true;
//                 setState(() {});
//               },
//               child: CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: (isTrue == null || isTrue == false)
//                     ? IconButtonStyleHelper.outlineLightGreenATL8
//                     : IconButtonStyleHelper.outlineLightGreenA,
//                 child: CustomImageView(
//                   imagePath: (isTrue == null || isTrue == false)
//                       ? ImageConstant.imgCheckLightGreenA70002
//                       : ImageConstant.imgCheck,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 isTrue = false;
//                 setState(() {});
//               },
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 8.h,
//                   right: 3.h,
//                 ),
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == true)
//                       ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                       : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   // decoration:
//                   //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   child: CustomImageView(
//                     // imagePath: ImageConstant.imgXOnprimary,
//                     imagePath: (isTrue == null || isTrue == true)
//                         ? ImageConstant.imgX
//                         : ImageConstant.imgXOnprimary,
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: 35.adaptSize,
//             //   width: 35.adaptSize,
//             //   child: Stack(
//             //     alignment: Alignment.center,
//             //     children: [
//             //       Align(
//             //         alignment: Alignment.center,
//             //         child: Container(
//             //           height: 35.adaptSize,
//             //           width: 35.adaptSize,
//             //           decoration: BoxDecoration(
//             //             borderRadius: BorderRadius.circular(
//             //               8.h,
//             //             ),
//             //             border: Border.all(
//             //               color: appTheme.lightGreenA70001,
//             //               width: 1.h,
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //       CustomImageView(
//             //         imagePath: ImageConstant.imgCheckLightGreenA70002,
//             //         height: 24.adaptSize,
//             //         width: 24.adaptSize,
//             //         alignment: Alignment.center,
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 8.h),
//             //   child: CustomIconButton(
//             //     height: 35.adaptSize,
//             //     width: 35.adaptSize,
//             //     padding: EdgeInsets.all(5.h),
//             //     child: CustomImageView(
//             //       imagePath: ImageConstant.imgX,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       );
//     });
//   }
//
//   /// Section Widget
//   Widget _buildReminderProduct(BuildContext context) {
//     return CustomElevatedButton(
//       height: 40.v,
//       text: "msg_reminder_product".tr,
//       rightIcon: Container(
//         margin: EdgeInsets.only(left: 30.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgInforectangleTeal50,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.fillPrimaryTL12,
//       buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildPostCallAnalysis(BuildContext context) {
//     return CustomElevatedButton(
//       height: 40.v,
//       text: "msg_post_call_analysis".tr,
//       rightIcon: Container(
//         margin: EdgeInsets.only(left: 30.h),
//         child: CustomImageView(
//           imagePath: ImageConstant.imgInforectangleTeal50,
//           height: 24.adaptSize,
//           width: 24.adaptSize,
//         ),
//       ),
//       buttonStyle: CustomButtonStyles.fillPrimaryTL12,
//       buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildSubmit(BuildContext context) {
//     return CustomElevatedButton(
//       text: "lbl_submit".tr,
//       onPressed: () async {
//         ProgressDialogUtils.showProgressDialog(isCancellable: false);
//         await Future.delayed(const Duration(seconds: 3));
//         ProgressDialogUtils.hideProgressDialog();
//         ProgressDialogUtils.showErrorDialog(context);
//       },
//     );
//   }
//
//   /// Common widget
//   Widget _buildSetsmartcallobjectives(
//     BuildContext context, {
//     required String setsmartcallobjectives,
//   }) {
//     bool? isTrue;
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: 12.h,
//             vertical: 7.v,
//           ),
//           decoration: AppDecoration.fillBlue.copyWith(
//             borderRadius: BorderRadiusStyle.roundedBorder10,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     top: 9.v,
//                     bottom: 8.v,
//                   ),
//                   child: Text(
//                     setsmartcallobjectives,
//                     style: theme.textTheme.bodyMedium!.copyWith(
//                       color: appTheme.blueGray900,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               // Spacer(),
//               //////////////////////////////////////////////
//               GestureDetector(
//                 onTap: () {
//                   isTrue = true;
//                   setState(() {});
//                 },
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   decoration: (isTrue == null || isTrue == false)
//                       ? IconButtonStyleHelper.outlineLightGreenATL8
//                       : IconButtonStyleHelper.outlineLightGreenA,
//                   child: CustomImageView(
//                     imagePath: (isTrue == null || isTrue == false)
//                         ? ImageConstant.imgCheckLightGreenA70002
//                         : ImageConstant.imgCheck,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   isTrue = false;
//                   setState(() {});
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: 8.h,
//                     right: 3.h,
//                   ),
//                   child: CustomIconButton(
//                     height: 35.adaptSize,
//                     width: 35.adaptSize,
//                     padding: EdgeInsets.all(5.h),
//                     decoration: (isTrue == null || isTrue == true)
//                         ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                         : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     // decoration:
//                     //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                     child: CustomImageView(
//                       // imagePath: ImageConstant.imgXOnprimary,
//                       imagePath: (isTrue == null || isTrue == true)
//                           ? ImageConstant.imgX
//                           : ImageConstant.imgXOnprimary,
//                     ),
//                   ),
//                 ),
//               ),
//               //////////////////////////////////////////////
//             ],
//           ),
//         );
//         return Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: 12.h,
//             vertical: 7.v,
//           ),
//           decoration: AppDecoration.fillBlue.copyWith(
//             borderRadius: BorderRadiusStyle.roundedBorder10,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     top: 9.v,
//                     bottom: 8.v,
//                   ),
//                   child: Text(
//                     setsmartcallobjectives,
//                     style: theme.textTheme.bodyMedium!.copyWith(
//                       color: appTheme.blueGray900,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               // Spacer(),
//               CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: IconButtonStyleHelper.outlineLightGreenATL8,
//                 child: CustomImageView(
//                   imagePath: ImageConstant.imgCheckLightGreenA70002,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: 8.h,
//                   right: 3.h,
//                 ),
//                 child: CustomIconButton(
//                   height: 35.adaptSize,
//                   width: 35.adaptSize,
//                   padding: EdgeInsets.all(5.h),
//                   ///////////////////////////////////////////////////////////////
//                   decoration:
//                       IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                   child: CustomImageView(
//                     imagePath: ImageConstant.imgXOnprimary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   /// Common widget
//   Widget _buildX(BuildContext context) {
//     return SizedBox(
//       height: 35.adaptSize,
//       width: 35.adaptSize,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CustomIconButton(
//             height: 35.adaptSize,
//             width: 35.adaptSize,
//             alignment: Alignment.center,
//             child: CustomImageView(),
//           ),
//           CustomImageView(
//             imagePath: ImageConstant.imgX,
//             height: 24.adaptSize,
//             width: 24.adaptSize,
//             alignment: Alignment.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Common widget
//   Widget _buildAskForSpecific(
//     BuildContext context, {
//     required String askForSpecific,
//   }) {
//     bool? isTrue;
//     return StatefulBuilder(builder: (context, setState) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 184.h,
//             child: Text(
//               askForSpecific,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: theme.textTheme.bodyMedium!.copyWith(
//                 color: appTheme.blueGray900,
//               ),
//             ),
//           ),
//           Spacer(),
//           GestureDetector(
//             onTap: () {
//               isTrue = true;
//               setState(() {});
//             },
//             child: CustomIconButton(
//               height: 35.adaptSize,
//               width: 35.adaptSize,
//               padding: EdgeInsets.all(5.h),
//               decoration: (isTrue == null || isTrue == false)
//                   ? IconButtonStyleHelper.outlineLightGreenATL8
//                   : IconButtonStyleHelper.outlineLightGreenA,
//               child: CustomImageView(
//                 imagePath: (isTrue == null || isTrue == false)
//                     ? ImageConstant.imgCheckLightGreenA70002
//                     : ImageConstant.imgCheck,
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               isTrue = false;
//               setState(() {});
//             },
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 8.h,
//                 right: 3.h,
//               ),
//               child: CustomIconButton(
//                 height: 35.adaptSize,
//                 width: 35.adaptSize,
//                 padding: EdgeInsets.all(5.h),
//                 decoration: (isTrue == null || isTrue == true)
//                     ? IconButtonStyleHelper.outlineOnPrimaryContainer
//                     : IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                 // decoration:
//                 //     IconButtonStyleHelper.outlineOnPrimaryContainerTL8,
//                 child: CustomImageView(
//                   // imagePath: ImageConstant.imgXOnprimary,
//                   imagePath: (isTrue == null || isTrue == true)
//                       ? ImageConstant.imgX
//                       : ImageConstant.imgXOnprimary,
//                 ),
//               ),
//             ),
//           ),
//           // CustomIconButton(
//           //   height: 35.adaptSize,
//           //   width: 35.adaptSize,
//           //   padding: EdgeInsets.all(5.h),
//           //   child: CustomImageView(
//           //     imagePath: ImageConstant.imgCheckLightGreenA70002,
//           //   ),
//           // ),
//           // Container(
//           //   height: 35.adaptSize,
//           //   width: 35.adaptSize,
//           //   margin: EdgeInsets.only(left: 8.h),
//           //   child: Stack(
//           //     alignment: Alignment.center,
//           //     children: [
//           //       CustomIconButton(
//           //         height: 35.adaptSize,
//           //         width: 35.adaptSize,
//           //         alignment: Alignment.center,
//           //         child: CustomImageView(),
//           //       ),
//           //       CustomImageView(
//           //         imagePath: ImageConstant.imgX,
//           //         height: 24.adaptSize,
//           //         width: 24.adaptSize,
//           //         alignment: Alignment.center,
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ],
//       );
//     });
//   }
// }
