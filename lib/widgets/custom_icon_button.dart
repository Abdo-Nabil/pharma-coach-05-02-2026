import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: appTheme.orange300,
                  borderRadius: BorderRadius.circular(7.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineLightGreenA => BoxDecoration(
        color: appTheme.lightGreenA70002,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: appTheme.lightGreenA70001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineLightGreenATL8 => BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: appTheme.lightGreenA70001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimaryContainerTL8 => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(
          color: theme.colorScheme.onPrimaryContainer,
          width: 1.h,
        ),
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(7.h),
      );
}
