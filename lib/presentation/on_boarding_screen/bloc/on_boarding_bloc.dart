import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/presentation/on_boarding_screen/models/on_boarding_model.dart';

import '/core/app_export.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

/// A bloc that manages the state of a OnBoarding according to the event that is dispatched to it.
class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc(OnBoardingState initialState) : super(initialState) {
    on<OnBoardingInitialEvent>(_onInitialize);
  }

  _onInitialize(
    OnBoardingInitialEvent event,
    Emitter<OnBoardingState> emit,
  ) async {
    Future.delayed(const Duration(milliseconds: 3000), () {
      //
      final pref = PrefUtils();
      final token = pref.getLoginToken();
      //
      if (token == null) {
        NavigatorService.popAndPushNamed(
          AppRoutes.signInPropsalOneScreen,
        );
      } else {
        final username = pref.getUsername();
        final firstName = pref.getFirstName();
        final userType = pref.getUserType();
        GeneralData.token = token;
        GeneralData.userName = username;
        GeneralData.firstName = firstName;
        GeneralData.userType = userType;
        NavigatorService.popAndPushNamed(
          AppRoutes.homeContainerScreen,
        );
      }
    });
  }
}
