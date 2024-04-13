import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/presentation/final_quest_screen/final_quest_screen.dart';
import 'package:mina_s_application5/presentation/questions_screen/cubit/questions_cubit.dart';
import 'package:mina_s_application5/presentation/questions_screen/last_question/last_question_screen.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/category_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/models/question_answer_model.dart';
import 'package:mina_s_application5/presentation/questions_screen/widgets/block_build_category_with_questions.dart';
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
  late int visitId;
  late String medicalRepName;

  //
  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    questionType = routeArgs['type'];
    visitId = routeArgs['visitId'];
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
                            return BlockBuildCategoryWithQuestions(
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
            .areAllBlockQuestionsAnswered()) {
          ProgressDialogUtils.showWarningDialog(
              context, 'Keep Note!', 'Some questions were not answered');
          return;
        }

        ProgressDialogUtils.showNextStepDialog(
          context,
          onNextVisit: () {
            BlocProvider.of<QuestionsCubit>(context)
                .submitQuestionAnswersLocally(visitId);
            Navigator.pop(context);
            NavigatorService.pushReplacementNamed(
              AppRoutes.listTabContainerScreen,
            );
          },
          onEndOfTheDay: () {
            //
            BlocProvider.of<QuestionsCubit>(context)
                .submitQuestionAnswersLocally(visitId);
            //
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) {
                return BlocProvider.value(
                  value: BlocProvider.of<QuestionsCubit>(context),
                  child: LastQuestionScreen(),
                );
              }),
            );
          },
        );
        // ProgressDialogUtils.showProgressDialog(isCancellable: false);
        //
        // final isSuccess = await BlocProvider.of<QuestionsCubit>(context)
        //     .submitQuestionAnswers(visitId);
        // //
        // ProgressDialogUtils.hideProgressDialog();
        // ProgressDialogUtils.showSubmitSuccessDialog(context);
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

/////////////////////////////////////////////////////////////

/*import 'package:awesome_dialog/awesome_dialog.dart';
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
  late int visitId;
  late String medicalRepName;

  //
  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    questionType = routeArgs['type'];
    visitId = routeArgs['visitId'];
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
                      */
