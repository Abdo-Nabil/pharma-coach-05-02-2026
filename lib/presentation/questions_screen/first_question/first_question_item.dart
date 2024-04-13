import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

import '../../../widgets/custom_icon_button.dart';
import '../models/question_answer_model.dart';
import '../models/question_model.dart';

class FirstQuestionItem extends StatefulWidget {
  final QuestionModel questionModel;
  final Function onAnswer;
  const FirstQuestionItem({
    required this.questionModel,
    required this.onAnswer,
  });

  @override
  State<FirstQuestionItem> createState() => _FirstQuestionItemState();
}

class _FirstQuestionItemState extends State<FirstQuestionItem>
    with AutomaticKeepAliveClientMixin {
  bool? isTrue;
  @override
  Widget build(BuildContext context) {
    //
    _saveAnswer(bool isTrue) async {
      final answer = QuestionAnswerModel(
          categoryId: widget.questionModel.categoryId,
          questionId: widget.questionModel.id,
          answer: isTrue ? 1 : 0);
      //
      await widget.onAnswer(answer);
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
              color: Colors.white,
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
