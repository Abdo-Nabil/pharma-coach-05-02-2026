import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/rep_model.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/build_avg_analysis_widget.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/checkbox_widget.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/table_text.dart';
import 'package:mina_s_application5/presentation/team_analytics_screen/team_analytics_screen.dart';

import '../../core/utils/pref_utils.dart';
import '../../general_helper.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'build_rep_analysis_widget.dart';
import 'category_title_container.dart';
import 'cubit/avg_screen_cubit/avg_screen_cubit.dart';
import 'cubit/rep_analysis_cubit/rep_analysis_cubit.dart';
import 'expandable_row_for_month.dart';
import 'expandable_row_for_other.dart';

class AvgScreen extends StatefulWidget {
  final List<TinyRepModel> reps;
  const AvgScreen({required this.reps});

  @override
  State<AvgScreen> createState() => _AvgScreenState();
}

class _AvgScreenState extends State<AvgScreen> {
  //
  //
  final pref = PrefUtils();
  DateTime pickedDate = DateTime.now();
  late TextEditingController dateController = TextEditingController(
      text: GeneralHelper.formatDateForAvgScreen(pickedDate));
  //
  DateFilter dateFilter = DateFilter.month;
  //
  late int quarterNumber = GeneralHelper.getQuarter(pickedDate);
  late int selectedMonthIndex = pickedDate.month;

  //
  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  //
  @override
  void initState() {
    BlocProvider.of<AvgScreenCubit>(context).selectedMonthIndex =
        pickedDate.month - 1;
    BlocProvider.of<AvgScreenCubit>(context).selectedQuarter =
        GeneralHelper.getQuarter(pickedDate);
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    final selectedMonthIndex =
        BlocProvider.of<AvgScreenCubit>(context, listen: true)
            .selectedMonthIndex;
    final selectedQuarter =
        BlocProvider.of<AvgScreenCubit>(context, listen: true).selectedQuarter;
    //
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 4.v,
          ),
          child: Column(
            children: [
              // SizedBox(height: 16.v),
              Container(
                height: MediaQuery.of(context).size.height * 0.200,
                width: double.infinity,
                decoration: AppDecoration.fillBlue50.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder17,
                ),
                child: ListView.builder(
                  itemCount: widget.reps.length,
                  itemBuilder: (context, index) {
                    return CheckBoxWidget(
                        title: widget.reps[index].username,
                        onChange: () {
                          BlocProvider.of<AvgScreenCubit>(context)
                              .addOrRemoveMedicalRep(widget.reps[index].id);
                          //
                          if (BlocProvider.of<AvgScreenCubit>(context)
                              .selectedRepsIds
                              .isEmpty) {
                            return;
                          }
                          //
                          if (dateFilter == DateFilter.quarter) {
                            BlocProvider.of<AvgScreenCubit>(context)
                                .getAvgRepAnalysis(pickedDate,
                                    "q${GeneralHelper.getQuarter(pickedDate)}");
                            return;
                          }
                          //
                          BlocProvider.of<AvgScreenCubit>(context)
                              .getAvgRepAnalysis(pickedDate, dateFilter.name);
                        });
                  },
                ),
              ),
              SizedBox(height: 16.v),
              SizedBox(
                height: 48.v,
                // width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                    ),
                    onTap: () async {
                      final tempDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2080));
                      if (tempDate != null) {
                        //
                        pickedDate = tempDate;
                        dateController.text =
                            GeneralHelper.formatDateForAvgScreen(pickedDate);
                        //
                        BlocProvider.of<AvgScreenCubit>(context)
                            .getAvgRepAnalysis(pickedDate, dateFilter.name);
                        quarterNumber = GeneralHelper.getQuarter(pickedDate);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.v),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterButton(
                        label: 'Month',
                        isSelected: dateFilter.name == DateFilter.month.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.month;
                          });
                          BlocProvider.of<AvgScreenCubit>(context)
                              .getAvgRepAnalysis(pickedDate, dateFilter.name);
                        },
                      ),
                      FilterButton(
                        label: 'Quarter',
                        isSelected: dateFilter.name == DateFilter.quarter.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.quarter;
                          });
                          BlocProvider.of<AvgScreenCubit>(context)
                              .getAvgRepAnalysis(
                            pickedDate,
                            "q$quarterNumber",
                          );
                        },
                      ),
                      FilterButton(
                        label: 'YTD',
                        isSelected: dateFilter.name == DateFilter.year.name,
                        onTap: () {
                          setState(() {
                            dateFilter = DateFilter.year;
                          });
                          BlocProvider.of<AvgScreenCubit>(context)
                              .getAvgRepAnalysis(
                            pickedDate,
                            dateFilter.name,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.v),
              Visibility(
                visible: dateFilter == DateFilter.quarter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    return FilterButton(
                      label: "Q${index + 1}",
                      isSelected: selectedQuarter == index + 1,
                      onTap: () {
                        setState(() {
                          BlocProvider.of<AvgScreenCubit>(context)
                              .selectedQuarter = index + 1;
                        });
                        BlocProvider.of<AvgScreenCubit>(context)
                            .getAvgRepAnalysis(
                          pickedDate,
                          'q${index + 1}',
                        );
                      },
                    );
                  }),
                ),
              ),
              Visibility(
                visible: dateFilter == DateFilter.month,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(monthsList.length, (index) {
                      return FilterButton(
                        label: "${monthsList[index]}",
                        isSelected: selectedMonthIndex == index,
                        onTap: () {
                          setState(() {
                            BlocProvider.of<AvgScreenCubit>(context)
                                .selectedMonthIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
              Visibility(
                visible: dateFilter == DateFilter.quarter ||
                    dateFilter == DateFilter.month,
                child: SizedBox(height: 20.v),
              ),
              BlocProvider.of<AvgScreenCubit>(context).selectedRepsIds.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info,
                              color: appTheme.orange300,
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Please, select medical reps.',
                              style: TextStyle(fontSize: 20.fSize),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: BlocBuilder<AvgScreenCubit, AvgScreenState>(
                          builder: (context, state) {
                        //
                        if (state is AvgLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        //
                        else if (state is AvgNoAnalysis) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: appTheme.orange300,
                                  size: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No Analysis found!",
                                  style: TextStyle(fontSize: 20.fSize),
                                ),
                              ],
                            ),
                          );
                        }
                        ////
                        else if (state is AvgSuccess) {
                          return BuildAvgAnalysisWidget(
                            pickedDate: pickedDate,
                            dateFilter: dateFilter,
                          );
                        }
                        //
                        return Center(child: CircularProgressIndicator());
                      }),
                    ),
            ],
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      // appTheme.blue100
      leadingWidth: 30.h,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),

      height: 60.v,
      title: Row(
        children: [
          AppbarTitle(
            text: "Comparison",
            margin: EdgeInsets.only(left: 16.h),
          ),
        ],
      ),
      // actions: [
      //   AppbarTrailingIconbuttonOne(
      //     imagePath: ImageConstant.imgGoogleAnalyticsDeepOrange50,
      //     margin: EdgeInsets.only(
      //       left: 16.h,
      //       top: 2.v,
      //       right: 1.h,
      //     ),
      //   ),
      //   AppbarTrailingIconbutton(
      //     imagePath: ImageConstant.imgUsersOnprimary,
      //     margin: EdgeInsets.only(
      //       left: 6.h,
      //       top: 2.v,
      //       right: 17.h,
      //     ),
      //   ),
      // ],
    );
  }
}
