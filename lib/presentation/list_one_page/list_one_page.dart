import 'package:mina_s_application5/general_data.dart';
import 'package:mina_s_application5/widgets/custom_search_view.dart';
import '../../general_cubit/general_cubit.dart';
import '../list_tab_container_screen/cubit/list_tap_container_cubit.dart';
import 'widgets/listone_item_widget.dart';
import 'models/listone_item_model.dart';
import 'models/list_one_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/list_one_bloc.dart';

// ignore_for_file: must_be_immutable
class ListOnePage extends StatefulWidget {
  const ListOnePage({Key? key})
      : super(
          key: key,
        );

  @override
  ListOnePageState createState() => ListOnePageState();
  static Widget builder(BuildContext context) {
    return BlocProvider<ListOneBloc>(
      create: (context) => ListOneBloc(ListOneState(
        listOneModelObj: ListOneModel(),
      ))
        ..add(ListOneInitialEvent()),
      child: ListOnePage(),
    );
  }
}

class ListOnePageState extends State<ListOnePage>
    with AutomaticKeepAliveClientMixin<ListOnePage> {
  @override
  bool get wantKeepAlive => true;
  final searchController = TextEditingController();
  //
  @override
  void initState() {
    searchController.addListener(() {
      BlocProvider.of<ListTabContainerCubit>(context)
          .searchInPmLocations(searchController.text);
    });
    super.initState();
  }

  //
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillGray,
          child: Column(
            children: [
              SizedBox(height: 8.v),
              Expanded(child: _buildSearch(context)),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(
        children: [
          CustomSearchView(
            hintText: "lbl_search".tr,
            controller: searchController,
            // onChanged: (value) {
            //   BlocProvider.of<ListTabContainerCubit>(context)
            //       .searchInPmLocations(value);
            // },
          ),
          SizedBox(height: 8.v),
          BlocBuilder<ListTabContainerCubit, ListTapContainerState>(
            builder: (context, state) {
              if (state is ListTapContainerGetLocationsSuccessState) {
                final locations = state.pmLocations;

                return Expanded(
                  child: ListView.separated(
                    // physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    separatorBuilder: (
                      context,
                      index,
                    ) {
                      return SizedBox(
                        height: 4.v,
                      );
                    },
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final isVisitCreated =
                          BlocProvider.of<ListTabContainerCubit>(context)
                              .isVisitCreated(locations[index].id!);
                      final isQuestionSubmitted =
                          BlocProvider.of<ListTabContainerCubit>(context)
                              .isQuestionSubmitted(locations[index].id!);
                      // final visitIdIfFound =
                      //     BlocProvider.of<ListTabContainerCubit>(context)
                      //         .getVisitId(locations[index].id!);
                      return ListoneItemWidget(
                        locations[index],
                        isPm: true,
                        isVisitCreated: isVisitCreated,
                        isQuestionSubmitted: isQuestionSubmitted,
                        visitIdIfFound: -1,
                      );
                    },
                  ),
                );
              }
              return Container();
            },
          ),
          // BlocSelector<ListOneBloc, ListOneState, ListOneModel?>(
          //   selector: (state) => state.listOneModelObj,
          //   builder: (context, listOneModelObj) {
          //     return ListView.separated(
          //       physics: NeverScrollableScrollPhysics(),
          //       shrinkWrap: true,
          //       separatorBuilder: (
          //         context,
          //         index,
          //       ) {
          //         return SizedBox(
          //           height: 4.v,
          //         );
          //       },
          //       itemCount: listOneModelObj?.listoneItemList.length ?? 0,
          //       itemBuilder: (context, index) {
          //         ListoneItemModel model =
          //             listOneModelObj?.listoneItemList[index] ??
          //                 ListoneItemModel();
          //         return ListoneItemWidget(
          //           model,
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
