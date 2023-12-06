part of "../calendar.dart";

class _DayContents extends StatefulWidget {
  const _DayContents({
    Key? key,
    required this.selectCallback,
    required this.controller,
    required this.disablePressCallback,
    required this.isTodayColor,
  }) : super(key: key);

  final SelectCallback selectCallback;
  final VoidCallback disablePressCallback;
  final _CalenderViewModel controller;
  final bool isTodayColor;

  @override
  State<_DayContents> createState() => _DayContentsState();
}

class _DayContentsState extends State<_DayContents> {
  final crossAxisCount = 7;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.selectCallback.call(DateTime(
        int.parse(widget.controller.dateTitle.substring(0, 4)),
        int.parse(widget.controller.dateTitle.substring(5)),
        int.parse(widget.controller.selectDay!.day),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width -
        (2 * MediaQuery.of(context).padding.horizontal);

    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: ExpandablePageView(
        itemCount: widget.controller.dayMap.length,
        controller: widget.controller.pageViewController,
        itemBuilder: (context, pageIndex) {
          final dayList = widget.controller
                  .dayMap[widget.controller.getDayMapKey(pageIndex)] ??
              [];
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: width / 365,
            ),
            itemCount: dayList.length,
            itemBuilder: (context, index) => day(dayList[index], width),
            physics: const NeverScrollableScrollPhysics(),
          );
        },
      ),
    );
  }

  /// 일 화면 정보
  Widget day(Day? day, double width) {
    if (day == null) return const SizedBox();

    late Color color;

    if (day.isDisabled) {
      color = AppColors.appColorCC;
    } else if (day.isWeekend) {
      color = AppColors.appColorFF3400;
    } else if (day.isSelected) {
      if (day.isToday && widget.isTodayColor) {
        color = AppColors.appColorFF3400;
      } else {
        color = AppColors.appColor22;
      }
    } else if (day.isToday && widget.isTodayColor) {
      color = AppColors.appColorFF3400;
    } else {
      color = AppColors.appColor66;
    }

    return InkWell(
      onTap: () {
        if (day.isDisabled) {
          widget.disablePressCallback.call();
          return;
        }
        widget.controller.selectDay?.isSelected = false;
        day.isSelected = true;
        widget.controller.selectDay = day;
        widget.selectCallback.call(DateTime(
          int.parse(widget.controller.dateTitle.substring(0, 4)),
          int.parse(widget.controller.dateTitle.substring(5)),
          int.parse(day.day),
        ));
        // F.instance.logger.i(day.);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: (width / crossAxisCount - 38) / 2, vertical: 2),
        decoration: day.isSelected
            ? BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20 * 46 / 38),
                ),
                border: Border.all(
                  color: AppColors.mainColor,
                  width: 1,
                ),
              )
            : null,
        child: Stack(
          children: [
            Center(
              child: Text(
                day.day,
                style: TextStyle(
                  color: color,
                  fontWeight: day == widget.controller.selectDay
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: AppSizes.fontSize14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
              visible: day.isToday,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Container(
                    width: 4.5,
                    height: 4.5,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                        color: AppColors.mainColor,
                        width: 1,
                      )),
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
