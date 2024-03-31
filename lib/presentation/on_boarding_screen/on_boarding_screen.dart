import 'package:mina_s_application5/widgets/custom_icon_button.dart';
import 'models/on_boarding_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/on_boarding_bloc.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<OnBoardingBloc>(
      create: (context) => OnBoardingBloc(OnBoardingState(
        onBoardingModelObj: OnBoardingModel(),
      ))
        ..add(OnBoardingInitialEvent()),
      child: OnBoardingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: theme.colorScheme.onPrimary,
            body: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 44.h,
                vertical: 118.v,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 34,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgPharcoCorpLogo,
                    height: 97.v,
                    alignment: Alignment.centerRight,
                  ),
                  Spacer(
                    flex: 65,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 40.adaptSize,
                          width: 40.adaptSize,
                          padding: EdgeInsets.all(6.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgAmriya,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 40.adaptSize,
                            width: 40.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgEuropean,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 40.adaptSize,
                            width: 40.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgPharcoPharmaceutical,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 40.adaptSize,
                            width: 40.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgTechno,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.h),
                          child: CustomIconButton(
                            height: 40.adaptSize,
                            width: 40.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgPharcoB,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
