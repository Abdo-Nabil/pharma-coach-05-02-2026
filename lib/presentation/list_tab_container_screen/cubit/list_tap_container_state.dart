part of 'list_tap_container_cubit.dart';

abstract class ListTapContainerState extends Equatable {
  const ListTapContainerState();
}

class ListTapContainerInitial extends ListTapContainerState {
  @override
  List<Object> get props => [];
}

class ListTapContainerLoading extends ListTapContainerState {
  @override
  List<Object> get props => [];
}

class ListTapContainerGetLocationsSuccessState extends ListTapContainerState {
  final List<LocationModel> amLocations;
  final List<LocationModel> pmLocations;
  const ListTapContainerGetLocationsSuccessState({
    required this.amLocations,
    required this.pmLocations,
  });
  @override
  List<Object> get props => [identityHashCode(this)];
}
