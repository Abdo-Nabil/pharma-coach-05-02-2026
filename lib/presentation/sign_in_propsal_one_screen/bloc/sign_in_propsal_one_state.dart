// ignore_for_file: must_be_immutable

part of 'sign_in_propsal_one_bloc.dart';

/// Represents the state of SignInPropsalOne in the application.
class SignInPropsalOneState extends Equatable {
  SignInPropsalOneState({
    this.userNameController,
    this.passwordController,
    this.isShowPassword = true,
    this.signInPropsalOneModelObj,
  });

  TextEditingController? userNameController;

  TextEditingController? passwordController;

  SignInPropsalOneModel? signInPropsalOneModelObj;

  bool isShowPassword;

  @override
  List<Object?> get props => [
        userNameController,
        passwordController,
        isShowPassword,
        signInPropsalOneModelObj,
      ];

  SignInPropsalOneState copyWith({
    TextEditingController? userNameController,
    TextEditingController? passwordController,
    bool? isShowPassword,
    SignInPropsalOneModel? signInPropsalOneModelObj,
  }) {
    return SignInPropsalOneState(
      userNameController: userNameController ?? this.userNameController,
      passwordController: passwordController ?? this.passwordController,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      signInPropsalOneModelObj:
          signInPropsalOneModelObj ?? this.signInPropsalOneModelObj,
    );
  }
}
