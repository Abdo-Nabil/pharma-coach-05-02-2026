import 'package:mina_s_application5/widgets/custom_search_view.dart';
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
              _buildSearch(context),
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
          BlocSelector<ListOneBloc, ListOneState, TextEditingController?>(
            selector: (state) => state.searchController,
            builder: (context, searchController) {
              return CustomSearchView(
                controller: searchController,
                hintText: "lbl_search".tr,
              );
            },
          ),
          SizedBox(height: 8.v),
          BlocSelector<ListOneBloc, ListOneState, ListOneModel?>(
            selector: (state) => state.listOneModelObj,
            builder: (context, listOneModelObj) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (
                  context,
                  index,
                ) {
                  return SizedBox(
                    height: 4.v,
                  );
                },
                itemCount: listOneModelObj?.listoneItemList.length ?? 0,
                itemBuilder: (context, index) {
                  ListoneItemModel model =
                      listOneModelObj?.listoneItemList[index] ??
                          ListoneItemModel();
                  return ListoneItemWidget(
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
