import 'package:mina_s_application5/widgets/custom_search_view.dart';
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
              _buildFlash(context),
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
          BlocSelector<ListBloc, ListState, TextEditingController?>(
            selector: (state) => state.searchController,
            builder: (context, searchController) {
              return CustomSearchView(
                controller: searchController,
                hintText: "lbl_search".tr,
              );
            },
          ),
          SizedBox(height: 8.v),
          BlocSelector<ListBloc, ListState, ListModel?>(
            selector: (state) => state.listModelObj,
            builder: (context, listModelObj) {
              return ListView.separated(
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
                itemCount: listModelObj?.listItemList.length ?? 0,
                itemBuilder: (context, index) {
                  ListItemModel model =
                      listModelObj?.listItemList[index] ?? ListItemModel();
                  return ListItemWidget(
                    model,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
