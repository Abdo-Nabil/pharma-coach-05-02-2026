import 'package:flutter/material.dart';
import '../presentation/on_boarding_screen/on_boarding_screen.dart';
import '../presentation/sign_in_propsal_one_screen/sign_in_propsal_one_screen.dart';
import '../presentation/home_container_screen/home_container_screen.dart';
import '../presentation/list_tab_container_screen/list_tab_container_screen.dart';
import '../presentation/questions_screen/questions_screen.dart';
import '../presentation/final_quest_screen/final_quest_screen.dart';
import '../presentation/calendar_container_screen/calendar_container_screen.dart';
import '../presentation/analytics_tab_container_screen/analytics_tab_container_screen.dart';
import '../presentation/team_analytics_screen/team_analytics_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String onBoardingScreen = '/on_boarding_screen';

  static const String signInPropsalOneScreen = '/sign_in_propsal_one_screen';

  static const String homePage = '/home_page';

  static const String homeContainerScreen = '/home_container_screen';

  static const String listPage = '/list_page';

  static const String listTabContainerScreen = '/list_tab_container_screen';

  static const String listOnePage = '/list_one_page';

  static const String questionsScreen = '/questions_screen';

  static const String finalQuestScreen = '/final_quest_screen';

  static const String calendarContainerScreen = '/calendar_container_screen';

  static const String analyticsPage = '/analytics_page';

  static const String analyticsTabContainerScreen =
      '/analytics_tab_container_screen';

  static const String teamAnalyticsScreen = '/team_analytics_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        onBoardingScreen: OnBoardingScreen.builder,
        signInPropsalOneScreen: SignInPropsalOneScreen.builder,
        homeContainerScreen: HomeContainerScreen.builder,
        listTabContainerScreen: ListTabContainerScreen.builder,
        questionsScreen: QuestionsScreen.builder,
        finalQuestScreen: FinalQuestScreen.builder,
        calendarContainerScreen: CalendarContainerScreen.builder,
        analyticsTabContainerScreen: AnalyticsTabContainerScreen.builder,
        teamAnalyticsScreen: TeamAnalyticsScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: OnBoardingScreen.builder
      };
}
