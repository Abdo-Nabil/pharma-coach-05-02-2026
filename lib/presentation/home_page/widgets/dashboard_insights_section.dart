import 'package:flutter/material.dart';
import 'package:mina_s_application5/core/app_export.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/dashboard_insights_cubit.dart';
import 'package:mina_s_application5/presentation/home_page/cubit/dashboard_insights_state.dart';

class DashboardInsightsSection extends StatelessWidget {
  const DashboardInsightsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardInsightsCubit, DashboardInsightsState>(
      builder: (context, state) {
        if (state.status == DashboardInsightsStatus.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == DashboardInsightsStatus.error) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(fontSize: 20.fSize),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.status == DashboardInsightsStatus.success) {
          final data = state.insights!;

          // We use Flexible/Expanded to let them share space if parent allows,
          // or just Container with constraints.
          // User asked for 3 containers in the blank area, "no scroll".
          // We'll stack them vertically using Expanded to fill the available space evenly.

          return Expanded(
            flex: 2, // Adjust flex as needed relative to the list below
            child: Column(
              children: [
                Expanded(
                  child: _buildCategoryInsight(context, data.categories),
                ),
                SizedBox(height: 8.v),
                Expanded(
                  child: _buildRepInsight(context, data.medicalReps),
                ),
                SizedBox(height: 8.v),
                Expanded(
                  child: _buildVisitInsight(
                      context, data.visits, data.yourPosition),
                ),
                SizedBox(height: 16.v), // Spacing before "Your Plan"
              ],
            ),
          );
        }

        return SizedBox.shrink(); // Initial state or other
      },
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.v),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: child,
    );
  }

  Widget _buildCategoryInsight(BuildContext context, dynamic categories) {
    // categories is DashboardCategories
    final highest = categories.highest;
    final lowest = categories.lowest;

    return _buildContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRow("Highest Category", highest?.category ?? "-",
              highest?.score ?? 0, true),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.v),
            child: Divider(),
          ),
          _buildRow("Lowest Category", lowest?.category ?? "-",
              lowest?.score ?? 0, false),
        ],
      ),
    );
  }

  Widget _buildRepInsight(BuildContext context, dynamic reps) {
    // reps is DashboardMedicalReps
    final highest = reps.highest;
    final lowest = reps.lowest;

    return _buildContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRow(
              "Highest Rep", highest?.name ?? "-", highest?.score ?? 0, true),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.v),
            child: Divider(),
          ),
          _buildRow(
              "Lowest Rep", lowest?.name ?? "-", lowest?.score ?? 0, false),
        ],
      ),
    );
  }

  Widget _buildVisitInsight(
      BuildContext context, dynamic visits, dynamic position) {
    // visits: DashboardVisits, position: DashboardYourPosition
    final bool isUp = visits.trend == 'up';

    return _buildContainer(
      child: Row(
        children: [
          // Visits Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Visits", style: _labelStyle()),
                SizedBox(height: 4.v),
                Row(
                  children: [
                    Text("${visits.currentMonth}", style: _valueStyle()),
                    SizedBox(width: 8.h),
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isUp ? Colors.green : Colors.red,
                      size: 16.adaptSize,
                    ),
                    Text(
                      isUp ? "Up" : "Down",
                      style: TextStyle(
                        color: isUp ? Colors.green : Colors.red,
                        fontSize: 12.fSize,
                      ),
                    )
                  ],
                ),
                Text("vs Last Month: ${visits.lastMonth}",
                    style: CustomTextStyles.bodySmall_1),
              ],
            ),
          ),
          Container(
              width: 1.h,
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(horizontal: 8.h)),
          // Position Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Position", style: _labelStyle()),
                SizedBox(height: 4.v),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rank: ${position.rank}/${position.totalManagers}",
                          style: CustomTextStyles.bodySmall_1),
                    ]),
                Text("Score: ${position.score}", style: _valueStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String name, double score, bool isGood) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: _labelStyle(),
              ),
              SizedBox(
                height: 4.v,
              ),
              Text(name,
                  style: CustomTextStyles.bodySmall12.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Text(
          "${score.toStringAsFixed(1)}",
          style:
              _valueStyle().copyWith(color: isGood ? Colors.green : Colors.red),
        ),
      ],
    );
  }

  TextStyle _labelStyle() => CustomTextStyles.bodySmall12
      .copyWith(color: Colors.black87, fontWeight: FontWeight.w400);
  TextStyle _valueStyle() =>
      CustomTextStyles.labelLargeSFProTextBluegray900SemiBold
          .copyWith(fontSize: 16.fSize);
}
