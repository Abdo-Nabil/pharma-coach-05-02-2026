import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/cubit/calendar_cubit.dart';

import 'data/apiClient/api_client.dart';

class GeneralData {
  static String? userName;
  static String? token;
  static DateTime selectedDate = DateTime.now();
  static CalendarCubit calendarCubit = CalendarCubit(apiClient: ApiClient());
  static late int selectedRepId;
  static late int selectedVisitId;
}
