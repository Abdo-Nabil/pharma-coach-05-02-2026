// import 'package:flutter/material.dart';
// import 'package:mina_s_application5/core/app_export.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
//
// class CalendarScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: appTheme.gray100,
//         body: Padding(
//           padding: EdgeInsets.all(20.v),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20.v),
//                 Text(
//                   "lbl_calendar".tr,
//                   style: CustomTextStyles.titleLargeAmber700,
//                 ),
//                 SizedBox(height: 20.v),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.750,
//                   child: SfCalendar(
//                     view: CalendarView.month,
//                     dataSource: MeetingDataSource(_getDataSource()),
//                     monthViewSettings: MonthViewSettings(
//                       appointmentDisplayMode:
//                           MonthAppointmentDisplayMode.indicator,
//                       showAgenda: true,
//                       agendaStyle: AgendaStyle(
//                         dateTextStyle: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       // agendaViewHeight: 200,
//                       // agendaItemHeight: 100,
//                       showTrailingAndLeadingDates: true,
//                       monthCellStyle: MonthCellStyle(
//                         trailingDatesBackgroundColor: appTheme.gray300,
//                         // todayBackgroundColor: appTheme.gray100,
//                         leadingDatesBackgroundColor: appTheme.gray300,
//                       ),
//                     ),
//                     // appointmentTextStyle: TextStyle(
//                     //   color: Colors.black,
//                     // ),
//                     showNavigationArrow: true,
//                     selectionDecoration: BoxDecoration(
//                       border: Border.all(color: appTheme.amber700, width: 2),
//                     ),
//                     // appointmentBuilder: (s, a) {
//                     //   return Text("s");
//                     // },
// /*
//                     monthCellBuilder: (BuildContext context, details) {
//                       // Check if the current day has events
//                       if (details.appointments.isNotEmpty) {
//                         // If the day has events, return a container with a solid color
//                         return Container(
//                           color: appTheme.amber700, // Change color as needed
//                           child: Center(
//                             child: Text(
//                               details.date.day.toString(),
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         );
//                       } else {
//                         // If the day has no events, return the default cell
//                         return null;
//                       }
//                     },
// */
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<Meeting> _getDataSource() {
//     final List<Meeting> meetings = <Meeting>[];
//     final DateTime today = DateTime.now();
//     final DateTime startTime =
//         DateTime(today.year, today.month, today.day + 1, 9, 0, 0);
//     final DateTime endTime = startTime.add(const Duration(hours: 2));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, true));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, false));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, false));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, false));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, false));
//     meetings.add(
//         Meeting('Conference', startTime, endTime, appTheme.amber700, false));
//     return meetings;
//   }
// }
//
// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
//
//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }
// }
//
// class Meeting {
//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
//
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;
// }
//
//

import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/core/utils/progress_dialog_utils.dart';
import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/cubit/calendar_cubit.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: SfCalendar(
            view: CalendarView.month,
            // dataSource: MeetingDataSource(_getDataSource()),
            initialSelectedDate: GeneralData.selectedDate,
            onSelectionChanged: (details) {
              GeneralData.selectedDate = details.date!;
            },
            dataSource: MeetingDataSource(
                BlocProvider.of<CalendarCubit>(context, listen: true).meetings),
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              // showAgenda: true,
              // agendaStyle: AgendaStyle(
              //   dateTextStyle: Theme.of(context).textTheme.titleLarge,
              // ),
              // // agendaViewHeight: MediaQuery.of(context).size.height * 0.250,
              // agendaItemHeight: 90.v,
              showTrailingAndLeadingDates: true,
              monthCellStyle: MonthCellStyle(
                trailingDatesBackgroundColor: appTheme.gray300,
                // todayBackgroundColor: appTheme.gray100,
                leadingDatesBackgroundColor: appTheme.gray300,
              ),
            ),
            // appointmentTextStyle: TextStyle(
            //   color: Colors.black,
            // ),
            showNavigationArrow: true,
            selectionDecoration: BoxDecoration(
              border: Border.all(color: appTheme.amber700, width: 2),
            ),
            /* appointmentBuilder: (context, details) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                // child: Text(details.appointments.first.eventName.toString()),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.appointments.first.eventName,
                            style: TextStyle(
                              fontSize: 17.fSize,
                              color: appTheme.black900,
                            ),
                          ),
                          SizedBox(height: 4.v),
                          Text(
                            GeneralHelper.formatDateForDisplay1(details.date),
                            style: TextStyle(
                              fontSize: 15.fSize,
                              color: appTheme.gray500,
                            ),
                          ),
                          // .toString()

                          // Text(DateFormat.yMd('ar').  .toString()),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        BlocProvider.of<CalendarCubit>(context)
                            .removeIntendedVisit(details.date);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },*/
/*
                  monthCellBuilder: (BuildContext context, details) {
                    // Check if the current day has events
                    if (details.appointments.isNotEmpty) {
                      // If the day has events, return a container with a solid color
                      return Container(
                        color: appTheme.amber700, // Change color as needed
                        child: Center(
                          child: Text(
                            details.date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      // If the day has no events, return the default cell
                      return null;
                    }
                  },
*/
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.345,
          child: ListView.separated(
            itemCount: BlocProvider.of<CalendarCubit>(context)
                .everyRepIntendedVisits
                .length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 6.v);
            },
            itemBuilder: (context, index) {
              final everyRepIntendedVisits =
                  BlocProvider.of<CalendarCubit>(context, listen: true)
                      .everyRepIntendedVisits;
              return GestureDetector(
                onTap: () async {
                  //
                  ProgressDialogUtils.showRemoveIntendedVisitsDialog(
                      context,
                      everyRepIntendedVisits[index],
                      BlocProvider.of<CalendarCubit>(context));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  // child: Text(details.appointments.first.eventName.toString()),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  everyRepIntendedVisits[index][0].repName,
                                  style: TextStyle(
                                    fontSize: 17.fSize,
                                    color: appTheme.black900,
                                  ),
                                ),
                                SizedBox(
                                  width: 4.h,
                                ),
                                CircleAvatar(
                                  radius: 10.h,
                                  child: Text(
                                    everyRepIntendedVisits[index]
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12.fSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 4.v),
                            Row(
                              children: List.generate(
                                everyRepIntendedVisits[index].length,
                                (i) {
                                  return Expanded(
                                    child: Text(
                                      GeneralHelper.formatFromApiToDisplay(
                                          everyRepIntendedVisits[index][i]
                                              .stringDate),
                                      style: TextStyle(
                                        fontSize: 15.fSize,
                                        color: appTheme.gray500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            // .toString()

                            // Text(DateFormat.yMd('ar').  .toString()),
                          ],
                        ),
                      ),
                      //TODO: may be we might use it
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day + 1, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Ahmed Essam', startTime, endTime, appTheme.amber700, true));
    meetings.add(
        Meeting('Mona Ahmed', startTime, endTime, appTheme.amber700, false));
    meetings
        .add(Meeting('33333', startTime, endTime, appTheme.amber700, false));
    meetings
        .add(Meeting('44444', startTime, endTime, appTheme.amber700, false));
    meetings.add(Meeting('5555', startTime, endTime, appTheme.amber700, false));
    meetings
        .add(Meeting('66666', startTime, endTime, appTheme.amber700, false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
