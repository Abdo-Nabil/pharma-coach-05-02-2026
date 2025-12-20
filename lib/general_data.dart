import 'package:mina_s_application5/presentation/calendar_container_screen/cubit/calendar_cubit.dart';

import 'data/models/loginUser/post_login_user_resp.dart';

class GeneralData {
  static String? userName;
  static String? token;
  static UserType? userType;
  static DateTime selectedDate = DateTime.now();
  static late CalendarCubit calendarCubit;
  static late int selectedRepId;
  // static late int selectedVisitId;
}
