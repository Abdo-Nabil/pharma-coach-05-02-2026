import 'package:mina_s_application5/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTrailingIconbuttonOne extends StatelessWidget {
  AppbarTrailingIconbuttonOne({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 32.adaptSize,
          width: 32.adaptSize,
          decoration: IconButtonStyleHelper.fillOnPrimary,
          child: CustomImageView(
            imagePath: ImageConstant.imgUsers,
          ),
        ),
      ),
    );
  }
}
