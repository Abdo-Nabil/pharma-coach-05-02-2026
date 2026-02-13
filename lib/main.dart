import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/dashboard_insights_cubit.dart';
import 'package:mina_s_application5/presentation/questions_screen/cubit/questions_cubit.dart';

import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init()
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocProvider(
          create: (context) => GeneralCubit(ApiClient()),
          child: BlocProvider(
            create: (context) => ThemeBloc(
              ThemeState(
                themeType: PrefUtils().getThemeData(),
              ),
            ),
            child: BlocProvider<QuestionsCubit>(
              create: (context) => QuestionsCubit(
                ApiClient(),
                BlocProvider.of<GeneralCubit>(context),
              ),
              child: BlocProvider<DashboardInsightsCubit>(
                create: (context) => DashboardInsightsCubit(
                  apiClient: ApiClient(),
                ),
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    return MaterialApp(
                      theme: theme,
                      title: 'Pharma Coach',
                      navigatorKey: NavigatorService.navigatorKey,
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: [
                        AppLocalizationDelegate(),
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      supportedLocales: [
                        Locale(
                          'en',
                          '',
                        ),
                      ],
                      initialRoute: AppRoutes.initialRoute,
                      routes: AppRoutes.routes,
                      // home: CalendarScreen(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
