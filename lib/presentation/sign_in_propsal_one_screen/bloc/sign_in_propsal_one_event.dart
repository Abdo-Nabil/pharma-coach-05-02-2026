// ignore_for_file: must_be_immutable

part of 'sign_in_propsal_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///SignInPropsalOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
@immutable
abstract class SignInPropsalOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the SignInPropsalOne widget is first created.
class SignInPropsalOneInitialEvent extends SignInPropsalOneEvent {
  @override
  List<Object?> get props => [];
}

///Event that is dispatched when the user calls the {{baseUrl}}/login API.
class CreateLoginEvent extends SignInPropsalOneEvent {
  CreateLoginEvent({this.onCreateLoginEventSuccess});

  Function? onCreateLoginEventSuccess;

  @override
  List<Object?> get props => [
        onCreateLoginEventSuccess,
      ];
}

///Event for changing password visibility
class ChangePasswordVisibilityEvent extends SignInPropsalOneEvent {
  ChangePasswordVisibilityEvent({required this.value});

  bool value;

  @override
  List<Object?> get props => [
        value,
      ];
}
