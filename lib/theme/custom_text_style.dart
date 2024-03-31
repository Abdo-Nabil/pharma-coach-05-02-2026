import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/utils/size_utils.dart';
import 'package:mina_s_application5/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyMediumGray400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray400,
      );
  static get bodyMediumOnPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodySmall12 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 12.fSize,
      );
  static get bodySmallAmber700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.amber700,
        fontSize: 12.fSize,
      );
  static get bodySmallAmber7008 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.amber700,
        fontSize: 8.fSize,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallBlack90012 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
        fontSize: 12.fSize,
      );
  static get bodySmallBluegray900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray900,
        fontSize: 12.fSize,
      );
  static get bodySmallGray300 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray300,
        fontSize: 8.fSize,
      );
  static get bodySmallGray30001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray30001,
        fontSize: 8.fSize,
      );
  static get bodySmallGray400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray400,
      );
  static get bodySmallGray40012 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray400,
        fontSize: 12.fSize,
      );
  static get bodySmallGray400_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray400,
      );
  static get bodySmallGray500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray500,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodySmallOnPrimary9 => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 9.fSize,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w300,
      );
  static get bodySmallStylishSecondaryContainer =>
      theme.textTheme.bodySmall!.stylish.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontSize: 11.fSize,
      );
  static get bodySmall_1 => theme.textTheme.bodySmall!;
  static get bodySmallff63656a => theme.textTheme.bodySmall!.copyWith(
        color: Color(0XFF63656A),
        fontSize: 11.fSize,
      );
  // Label text style
  static get labelLargeSFProTextBlack900 =>
      theme.textTheme.labelLarge!.sFProText.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get labelLargeSFProTextBluegray900 =>
      theme.textTheme.labelLarge!.sFProText.copyWith(
        color: appTheme.blueGray900,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeSFProTextBluegray900SemiBold =>
      theme.textTheme.labelLarge!.sFProText.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w600,
      );
  static get labelLargeSFProTextff017cba =>
      theme.textTheme.labelLarge!.sFProText.copyWith(
        color: Color(0XFF017CBA),
      );
  static get labelMediumGray400 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray400,
      );
  // Title text style
  static get titleLargeAmber700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.amber700,
        fontWeight: FontWeight.w800,
      );
  static get titleLargeBluegray900 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBluegray900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBluegray900SemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray900,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallSemiBold => theme.textTheme.titleSmall!.copyWith(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
      );
}

extension on TextStyle {
  TextStyle get sFProText {
    return copyWith(
      fontFamily: 'SF Pro Text',
    );
  }

  TextStyle get sulphurPoint {
    return copyWith(
      fontFamily: 'Sulphur Point',
    );
  }

  TextStyle get stylish {
    return copyWith(
      fontFamily: 'Stylish',
    );
  }
}
