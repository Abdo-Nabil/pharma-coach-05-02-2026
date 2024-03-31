import 'package:mina_s_application5/core/utils/validation_functions.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/widgets/custom_text_form_field.dart';
import 'package:mina_s_application5/widgets/custom_elevated_button.dart';
import 'models/sign_in_propsal_one_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/sign_in_propsal_one_bloc.dart';

// ignore_for_file: must_be_immutable
class SignInPropsalOneScreen extends StatelessWidget {
  SignInPropsalOneScreen({Key? key})
      : super(
          key: key,
        );

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return BlocProvider<SignInPropsalOneBloc>(
      create: (context) => SignInPropsalOneBloc(SignInPropsalOneState(
        signInPropsalOneModelObj: SignInPropsalOneModel(),
      ))
        ..add(SignInPropsalOneInitialEvent()),
      child: SignInPropsalOneScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 28.h,
                  vertical: 18.v,
                ),
                child: Column(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgPharcoCorpLogo,
                      height: 95.v,
                    ),
                    SizedBox(height: 33.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "lbl_welcome".tr,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    SizedBox(height: 10.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "msg_login_to_your_account".tr,
                        style: CustomTextStyles.bodySmall12,
                      ),
                    ),
                    SizedBox(height: 6.v),
                    BlocSelector<SignInPropsalOneBloc, SignInPropsalOneState,
                        TextEditingController?>(
                      selector: (state) => state.userNameController,
                      builder: (context, userNameController) {
                        return CustomTextFormField(
                          controller: userNameController,
                          hintText: "lbl_username".tr,
                          hintStyle: CustomTextStyles.bodySmallGray40012,
                          validator: (value) {
                            if (!isText(value)) {
                              return "err_msg_please_enter_valid_text".tr;
                            }
                            return null;
                          },
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 9.h,
                            vertical: 15.v,
                          ),
                          borderDecoration:
                              TextFormFieldStyleHelper.outlineBlueGray,
                          fillColor: theme.colorScheme.onPrimary,
                        );
                      },
                    ),
                    SizedBox(height: 16.v),
                    BlocBuilder<SignInPropsalOneBloc, SignInPropsalOneState>(
                      builder: (context, state) {
                        return CustomTextFormField(
                          controller: state.passwordController,
                          hintText: "lbl_password".tr,
                          hintStyle: CustomTextStyles.bodySmallGray40012,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          suffix: InkWell(
                            onTap: () {
                              context.read<SignInPropsalOneBloc>().add(
                                  ChangePasswordVisibilityEvent(
                                      value: !state.isShowPassword));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 11.v, 11.h, 10.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgEye,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                              ),
                            ),
                          ),
                          suffixConstraints: BoxConstraints(
                            maxHeight: 45.v,
                          ),
                          validator: (value) {
                            if (value == null ||
                                (!isValidPassword(value, isRequired: true))) {
                              return "err_msg_please_enter_valid_password".tr;
                            }
                            return null;
                          },
                          obscureText: state.isShowPassword,
                          contentPadding: EdgeInsets.only(
                            left: 9.h,
                            top: 15.v,
                            bottom: 15.v,
                          ),
                          borderDecoration:
                              TextFormFieldStyleHelper.outlineBlueGray,
                          fillColor: theme.colorScheme.onPrimary,
                        );
                      },
                    ),
                    SizedBox(height: 19.v),
                    BlocBuilder<SignInPropsalOneBloc, SignInPropsalOneState>(
                      builder: (context, state) {
                        return  CustomElevatedButton(
                          text: "lbl_sign_in".tr,
                          buttonStyle: CustomButtonStyles.fillPrimary,
                          onPressed: (){
                            print(state.userNameController?.text.toString());
                            ApiClient().loginUser(state.userNameController!.text.toString(),state.passwordController!.text.toString());

                          },
                        );
                      },
                    ),

                    SizedBox(height: 5.v)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
