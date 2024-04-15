import 'package:mina_s_application5/presentation/list_one_page/widgets/listone_item_widget.dart';
import 'package:mina_s_application5/presentation/list_tab_container_screen/cubit/list_tap_container_cubit.dart';
import 'package:mina_s_application5/widgets/custom_search_view.dart';
import '../../general_cubit/general_cubit.dart';
import '../../general_data.dart';
import 'widgets/list_item_widget.dart';
import 'models/list_item_model.dart';
import 'models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'bloc/list_bloc.dart';

// ignore_for_file: must_be_immutable
class ListPage extends StatefulWidget {
  const ListPage({Key? key})
      : super(
          key: key,
        );

  @override
  ListPageState createState() => ListPageState();
  static Widget builder(BuildContext context) {
    return BlocProvider<ListBloc>(
      create: (context) => ListBloc(ListState(
        listModelObj: ListModel(),
      ))
        ..add(ListInitialEvent()),
      child: ListPage(),
    );
  }
}

class ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin<ListPage> {
  @override
  bool get wantKeepAlive => true;
  //
  final searchController = TextEditingController();
  //
  @override
  void initState() {
    searchController.addListener(() {
      BlocProvider.of<ListTabContainerCubit>(context)
          .searchInAmLocations(searchController.text);
    });
    super.initState();
  }

  //
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //
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
              Expanded(child: _buildFlash(context)),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFlash(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      child: Column(
        children: [
          CustomSearchView(
            hintText: "lbl_search".tr,
            controller: searchController,
            // onChanged: (value) {
            //   BlocProvider.of<ListTabContainerCubit>(context)
            //       .searchInAmLocations(value);
            // },
          ),
          SizedBox(height: 8.v),
          BlocBuilder<ListTabContainerCubit, ListTapContainerState>(
            builder: (context, state) {
              if (state is ListTapContainerGetLocationsSuccessState) {
                final locations = state.amLocations;
                return Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
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
                      final visitIdIfFound =
                          BlocProvider.of<ListTabContainerCubit>(context)
                              .getVisitId(locations[index].id!);
                      //
                      return ListoneItemWidget(
                        locations[index],
                        isPm: false,
                        isVisitCreated: isVisitCreated,
                        isQuestionSubmitted: isQuestionSubmitted,
                        visitId: visitIdIfFound,
                      );
                      // return ListItemWidget(
                      //   visits[index],
                      // );
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          // BlocSelector<ListBloc, ListState, ListModel?>(
          //   selector: (state) => state.listModelObj,
          //   builder: (context, listModelObj) {
          //     return ListView.separated(
          //       physics: BouncingScrollPhysics(),
          //       shrinkWrap: true,
          //       separatorBuilder: (
          //         context,
          //         index,
          //       ) {
          //         return SizedBox(
          //           height: 4.v,
          //         );
          //       },
          //       itemCount: listModelObj?.listItemList.length ?? 0,
          //       itemBuilder: (context, index) {
          //         ListItemModel model =
          //             listModelObj?.listItemList[index] ?? ListItemModel();
          //         return ListItemWidget(
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
