import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/data/apiClient/api_client.dart';
import 'package:mina_s_application5/general_cubit/general_cubit.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/dashboard_insights_cubit.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/home_cubit.dart';
import 'package:mina_s_application5/presentation/home_page/widgets/dashboard_insights_section.dart';
import 'package:mina_s_application5/widgets/app_bar/appbar_title_image.dart';

import '../../general_data.dart';
import 'widgets/home_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key})
      : super(
          key: key,
        );

  // static Widget builder(BuildContext context) {
  //   return BlocProvider<HomeBloc>(
  //     create: (context) => HomeBloc(HomeState(
  //       homeModelObj: HomeModel(),
  //     ))
  //       ..add(HomeInitialEvent()),
  //     child: HomePage(),
  //   );
  // }
  static Widget builder(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            apiClient: ApiClient(),
            generalCubit: BlocProvider.of<GeneralCubit>(context),
          ),
        ),
      ],
      child: HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // BlocProvider.of<HomeCubit>(context).getTodayVisits();
    // BlocProvider.of<HomeCubit>(context).getThisWeekVisits();
    BlocProvider.of<HomeCubit>(context).getThisWeekIntendedVisits();
    context
        .read<DashboardInsightsCubit>()
        .getDashboardInsights(isRefresh: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillGray,
          child: Column(
            children: [
              _buildPharcoCorpLogo(context),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                  ),
                  child: Column(
                    children: [
                      DashboardInsightsSection(),
                      SizedBox(height: 8.v),
                      _buildYourPlan(context),
                      SizedBox(height: 8.v),
                      Expanded(child: _buildHome(context))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPharcoCorpLogo(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.v, horizontal: 16.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*
          InkWell(
            onTap: () async {
              final shared = PrefUtils();
              await shared.clearToken();
              // shared.clearPreferencesData();
              NavigatorService.popAndPushNamed(
                AppRoutes.signInPropsalOneScreen,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.v),
              child: Column(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  Text(
                    "LogOut",
                  ),
                ],
              ),
            ),
          ),
          AppbarTrailingIconbutton(
            onTap: () {
              BlocProvider.of<GeneralCubit>(context).setBottomNavIndex(2);
            },
            imagePath: ImageConstant.imgCalendarText,
            margin: EdgeInsets.only(
              left: 16.h,
              right: 16.h,
              bottom: 3.v,
            ),
          ),
          */
          Container(
            width: 97.h,
            margin: EdgeInsets.only(left: 17.h),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "lbl_welcome_back".tr,
                    style: CustomTextStyles.bodySmallff63656a,
                  ),
                  TextSpan(
                    // text:
                    //     "${BlocProvider.of<SignInPropsalOneBloc>(context).postLoginUserResp.data!.email!.split("@").first}",
                    text: GeneralData.firstName,
                    // text: "lbl_hasnaa_ahmed".tr,
                    style:
                        CustomTextStyles.labelLargeSFProTextPrimaryColorScheme,
                  )
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          AppbarTitleImage(
            imagePath: ImageConstant.imgPharcoCorpLogo,
            margin: EdgeInsets.only(right: 16.h),
          ),

          // Spacer(),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildYourPlan(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.h,
        right: 1.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "lbl_your_plan".tr,
            style: CustomTextStyles.labelLargeSFProTextBluegray900SemiBold,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 2.v),
          //   child: Text(
          //     "lbl_show_all".tr,
          //     style: theme.textTheme.bodySmall,
          //   ),
          // )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHome(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.h),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          //
          if (state is HomeLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          //
          else if (state is HomeGetVisitsSuccess) {
            final intendedVisits =
                BlocProvider.of<HomeCubit>(context).intendedVisits;
            // Ensure list is scrollable for RefreshIndicator to work even if empty
            if (intendedVisits.isEmpty) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                      height: 200.v,
                      child: Center(
                          child: Text("No visits found for this week."))),
                ],
              );
            }
            return ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              // shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8.v,
                );
              },
              itemCount: intendedVisits.length,
              itemBuilder: (context, index) {
                return HomeItemWidget(intendedVisits[index]);
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
