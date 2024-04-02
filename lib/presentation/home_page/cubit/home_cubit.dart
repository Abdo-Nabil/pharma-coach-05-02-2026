import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/general_helper.dart';
import 'package:mina_s_application5/presentation/calendar_container_screen/models/vsit_model.dart';

import '../../../data/apiClient/api_client.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiClient apiClient;
  HomeCubit({required this.apiClient}) : super(HomeInitial());

  List<VisitModel> visits = [];

  getTodayVisits() async {
    emit(HomeLoadingState());
    visits = await apiClient.getVisits(
        "day", GeneralHelper.formatDateForApi(DateTime.now()));
    emit(HomeGetVisitsSuccess());
  }
}
