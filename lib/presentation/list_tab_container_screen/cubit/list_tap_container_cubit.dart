import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mina_s_application5/general_helper.dart';

import '../../../data/apiClient/api_client.dart';
import '../../calendar_container_screen/models/vsit_model.dart';

part 'list_tap_container_state.dart';

class ListTabContainerCubit extends Cubit<ListTapContainerState> {
  final ApiClient apiClient;

  ListTabContainerCubit(this.apiClient) : super(ListTapContainerInitial());

  List<VisitModel> amVisits = [];
  List<VisitModel> pmVisits = [];

  getAmAndPmVisits() async {
    emit(ListTapContainerLoading());
    final visits = await apiClient.getVisits(
        'day', GeneralHelper.formatDateForApi(DateTime.now()));
    for (int i = 0; i < visits.length; i++) {
      if (visits[i].shift == "AM") {
        amVisits.add(visits[i]);
      } else if (visits[i].shift == "PM") {
        pmVisits.add(visits[i]);
      }
    }
    emit(ListTapContainerGetVisitSuccessState());
  }
}
