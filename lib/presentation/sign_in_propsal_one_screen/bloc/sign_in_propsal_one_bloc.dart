import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:mina_s_application5/presentation/sign_in_propsal_one_screen/models/sign_in_propsal_one_model.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_resp.dart';
import 'package:mina_s_application5/data/models/loginUser/post_login_user_req.dart';
import 'dart:async';
import 'package:mina_s_application5/data/repository/repository.dart';
part 'sign_in_propsal_one_event.dart';
part 'sign_in_propsal_one_state.dart';

/// A bloc that manages the state of a SignInPropsalOne according to the event that is dispatched to it.
class SignInPropsalOneBloc
    extends Bloc<SignInPropsalOneEvent, SignInPropsalOneState> {
  SignInPropsalOneBloc(SignInPropsalOneState initialState)
      : super(initialState) {
    on<SignInPropsalOneInitialEvent>(_onInitialize);
    on<ChangePasswordVisibilityEvent>(_changePasswordVisibility);
    on<CreateLoginEvent>(_callLoginUser);
  }

  final _repository = Repository();

  var postLoginUserResp = PostLoginUserResp();

  _changePasswordVisibility(
    ChangePasswordVisibilityEvent event,
    Emitter<SignInPropsalOneState> emit,
  ) {
    emit(state.copyWith(
      isShowPassword: event.value,
    ));
  }

  /// Calls the {{baseUrl}}/login API and triggers a [CreateLoginEvent] event on the [SignInPropsalOneBloc] bloc.
  ///
  /// The [BuildContext] parameter represents current [BuildContext]
  _onInitialize(
    SignInPropsalOneInitialEvent event,
    Emitter<SignInPropsalOneState> emit,
  ) async {
    emit(state.copyWith(
      userNameController: TextEditingController(),
      passwordController: TextEditingController(),
      isShowPassword: true,
    ));
    add(
      CreateLoginEvent(
        onCreateLoginEventSuccess: () {
          _onLoginUserEventSuccess(

          );
        },
      ),
    );
    // NavigatorService.popAndPushNamed(
    //   AppRoutes.homeContainerScreen,
   // );
  }

  /// Calls [{{baseUrl}}/login] with the provided event and emits the state.
  ///
  /// The [CreateLoginEvent] parameter is used for handling event data
  /// The [emit] parameter is used for emitting the state
  ///
  /// Throws an error if an error occurs during the API call process.
  FutureOr<void> _callLoginUser(
    CreateLoginEvent event,
    Emitter<SignInPropsalOneState> emit,
  ) async {
    var postLoginUserReq = PostLoginUserReq();
    await _repository.loginUser(
      headers: {},
      requestData: postLoginUserReq.toJson(),
    ).then((value) async {
      postLoginUserResp = value;
      _onLoginUserSuccess(value, emit);
      event.onCreateLoginEventSuccess?.call();
    }).onError((error, stackTrace) {
      //implement error call
      _onLoginUserError();
    });
  }

  void _onLoginUserSuccess(
    PostLoginUserResp resp,
    Emitter<SignInPropsalOneState> emit,
  ) {}
  void _onLoginUserError() {
    //implement error method body...
  }
  void _onLoginUserEventSuccess() {}
}
