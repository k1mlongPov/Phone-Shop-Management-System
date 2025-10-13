import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phone_shop/common/app_style.dart';
import 'package:phone_shop/common/reusable_text.dart';
import 'package:phone_shop/constants/constants.dart';
import 'package:phone_shop/controllers/dashboard_controller.dart';

class MonthlyProfitChart extends StatelessWidget {
  final DashboardController controller = Get.find();

  MonthlyProfitChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final phones = controller.monthlyPhoneProfit;
      final accessories = controller.monthlyAccessoryProfit;

      if (phones.isEmpty || accessories.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final maxY = _findMaxY(phones, accessories);

      return Container(
        width: width,
        height: 300.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with legend
            Row(
              children: [
                Expanded(
                  child: ReusableText(
                    text: "💰 Monthly Profit",
                    style: appStyle(14, kDark, FontWeight.bold),
                  ),
                ),
                _LegendDot(color: Colors.greenAccent.shade700, label: "Phones"),
                const SizedBox(width: 12),
                const _LegendDot(
                    color: Colors.blueAccent, label: "Accessories"),
              ],
            ),
            SizedBox(height: 16.h),
            // Chart area
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: maxY / 4, // 4 evenly spaced grid lines
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),

                  // ✅ Proper spacing for axes
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),

                    // ✅ Left (Y-axis): money labels spaced correctly
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: maxY / 4, // prevent overlap
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: ReusableText(
                              text: "\$${value.toInt()}",
                              style: appStyle(11, kDark, FontWeight.normal),
                            ),
                          );
                        },
                      ),
                    ),

                    // ✅ Bottom (X-axis): month labels evenly spaced
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1, // show every point once
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= phones.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: ReusableText(
                              text: phones[index]['month'],
                              style: appStyle(10, kDark, FontWeight.normal),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ✅ The two profit lines
                  lineBarsData: [
                    // Phones (green)
                    LineChartBarData(
                      spots: List.generate(
                        phones.length,
                        (i) => FlSpot(
                            i.toDouble(), phones[i]['profit'].toDouble()),
                      ),
                      isCurved: true,
                      color: Colors.greenAccent.shade700,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.greenAccent.withOpacity(0.25),
                      ),
                      dotData: const FlDotData(show: false),
                    ),

                    // Accessories (blue)
                    LineChartBarData(
                      spots: List.generate(
                        accessories.length,
                        (i) => FlSpot(
                            i.toDouble(), accessories[i]['profit'].toDouble()),
                      ),
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withOpacity(0.15),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],

                  // ✅ Animation for smooth entry
                  lineTouchData: const LineTouchData(enabled: true),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  double _findMaxY(List<Map<String, dynamic>> p, List<Map<String, dynamic>> a) {
    final maxP =
        p.map((e) => e['profit'] as double).reduce((a, b) => a > b ? a : b);
    final maxA =
        a.map((e) => e['profit'] as double).reduce((a, b) => a > b ? a : b);
    return (maxP > maxA ? maxP : maxA) * 1.3; // add some top padding
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        ReusableText(
          text: label,
          style: appStyle(12, kDark, FontWeight.normal),
        ),
      ],
    );
  }
}
