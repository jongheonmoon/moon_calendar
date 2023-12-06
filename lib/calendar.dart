import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moon_calendar/constant/app_colors.dart';
import 'package:moon_calendar/constant/app_sizes.dart';
import 'package:moon_calendar/constant/expandable_page_view_widget.dart';

part "calendar_view_model.dart";
part "model/day.dart";
part "widget/day_contents.dart";
part "widget/day_of_week_title.dart";

typedef SelectCallback = Function(DateTime dateTime);

class Calender extends StatefulWidget {
  const Calender({
    Key? key,
    required this.startDateTime,
    required this.selectCallback,
    required this.endDateTime,
    this.possibleDayOfTheWeek = "1111111",
    required this.disableSelectedCallback,
    required this.isTodayColor,
  }) : super(key: key);

  final DateTime startDateTime;
  final String possibleDayOfTheWeek; // 1111111 (0:불가능, 1: 가능, 형식:일월화수목금토)
  final DateTime endDateTime;
  final SelectCallback selectCallback;
  final VoidCallback disableSelectedCallback;
  final bool isTodayColor;

  @override
  State<Calender> createState() {
    final String uniqueKey = UniqueKey().toString();
    return _CalenderState(Get.put(
      _CalenderViewModel(
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        possibleDayOfTheWeek: possibleDayOfTheWeek,
      ),
      tag: uniqueKey,
    ));
  }
}

class _CalenderState extends State<Calender> {
  _CalenderState(this.controller);

  final _CalenderViewModel controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInit.isFalse) return const SizedBox();
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return InkWell(
                  onTap: () {
                    // controller.calenderBack ? controller.previousPage() : null;
                    controller.previousPage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 7, left: 5, right: 5, top: 5),
                    child: SvgPicture.asset(
                      "assets/images/btn_arrow_disable_13.svg",
                      width: 13,
                      height: 13,
                      colorFilter: controller.isLeftPagingPossible.isTrue
                          ? const ColorFilter.mode(
                              AppColors.appColor22, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 9),
              Obx(() {
                return Text(controller.dateTitle.value,
                    style: const TextStyle(
                      color: AppColors.appColor22,
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.fontSize18,
                    ),
                    textAlign: TextAlign.center);
              }),
              const SizedBox(width: 9),
              Obx(() {
                return InkWell(
                  onTap: () => controller.nextPage(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 7, left: 5, right: 5, top: 5),
                    child: SvgPicture.asset(
                      "assets/images/btn_arrow_13.svg",
                      width: 13,
                      height: 13,
                      colorFilter: controller.isRightPagingPossible.isFalse
                          ? const ColorFilter.mode(
                              AppColors.appColorCC, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 28),
          const _DayOfWeekTitle(),
          const SizedBox(height: 5),
          _DayContents(
            selectCallback: widget.selectCallback,
            controller: controller,
            disablePressCallback: widget.disableSelectedCallback,
            isTodayColor: widget.isTodayColor,
          ),
        ],
      );
    });
  }
}
