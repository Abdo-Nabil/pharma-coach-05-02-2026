import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/questions_screen/widgets/block_question_item.dart';

import '../../../core/utils/image_constant.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../cubit/questions_cubit.dart';
import '../models/category_model.dart';

class BlockBuildCategoryWithQuestions extends StatelessWidget {
  final CategoryModel categoryModel;
  const BlockBuildCategoryWithQuestions({
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
          final temp = index;
          return BlockQuestionItem(
            questionModel: categoryModel.questions[index],
            onAnswer: (answer) {
              int index = BlocProvider.of<QuestionsCubit>(context)
                  .answers
                  .indexWhere((element) =>
                      element.categoryId ==
                          categoryModel.questions[temp].categoryId &&
                      element.questionId == categoryModel.questions[temp].id);
              //
              if (index == -1) {
                BlocProvider.of<QuestionsCubit>(context).answers.add(answer);
              } else {
                BlocProvider.of<QuestionsCubit>(context).answers[index] =
                    answer;
              }
            },
          );
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
