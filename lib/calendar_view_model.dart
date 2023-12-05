part of "calendar.dart";

class _CalenderViewModel extends GetxController {
  _CalenderViewModel(
      {required this.startDateTime, required this.endDateTime, required this.possibleDayOfTheWeek});

  final DateTime startDateTime;
  final DateTime endDateTime;
  final String possibleDayOfTheWeek;
  final HashMap<String, List<Day?>> dayMap = HashMap(); // key = 202208

  late final PageController pageViewController;
  final dateTitle = "".obs;
  final isLeftPagingPossible = false.obs;
  final isRightPagingPossible = false.obs;
  var currentPagePosition = 0;

  late final visiblePreviousYear = startDateTime.year - 0;

  Day? selectDay;
  final isInit = false.obs;

  @override
  void onReady() {
    init();
  }

  init() {
    for (int year = visiblePreviousYear; year <= endDateTime.year; year++) {
      final int startMonth = visiblePreviousYear == year ? startDateTime.month : 1;
      for (int month = startMonth; month <= 12; month++) {
        final dayList = <Day?>[];
        final dateTime = DateTime(year, month, 1);
        final lastDay = DateTime(year, month + 1, 0).day;
        final weekendMultipleNumber = 8 - dateTime.weekday;

        // 날짜 빈공간 생성
        for (int day = 0; day < dateTime.weekday && dateTime.weekday != 7; day++) {
          dayList.add(null);
        }

        for (int day = 1; day <= lastDay; day++) {
          var isDisabled = false;
          var isSelected = false;
          var isToday = false;

          var isWeekend =
              (day % 7 == 0 && weekendMultipleNumber == 7) || (day % 7) == weekendMultipleNumber;

          final date = int.parse(
              "$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}");

          final startDate = int.parse(
              "${startDateTime.year}${startDateTime.month.toString().padLeft(2, '0')}${startDateTime.day.toString().padLeft(2, '0')}");

          final today =
              int.parse("${DateTime.now().year}${DateTime.now().month}${DateTime.now().day.toString().padLeft(2, '0')}");

          final endDate = int.parse(
              '${endDateTime.year}${endDateTime.month.toString().padLeft(2, '0')}${endDateTime.day.toString().padLeft(2, '0')}');

          // F.instance.logger.i("date ${date}");
          // F.instance.logger.i("startDate ${startDate}");
          // F.instance.logger.i("today ${today}");

          /// 오늘 날짜에 표시되는 값
          if (date == today) {
            isToday = true;
          }

          /// 시작날짜 체크하여 디저블 처리
          if (date < startDate) {
            isDisabled = true;
          }
          /// 예약 가능기간 체크하여 디저블 처리
          else if (date > endDate) {
            isDisabled = true;
          }
          /// 요일 체크하여 디저블 처리
          else if (!_isPossibleDayOfTheWeek(year, month, day)) {
            isDisabled = true;
          } else {
            if (selectDay == null) {
              isSelected = true;
            }
          }

          final objDay = Day(
              day: day.toString(),
              isWeekend: isWeekend,
              isDisabled: isDisabled,
              isSelected: isSelected,
              isToday: isToday);
          if (isSelected) selectDay = objDay;

          dayList.add(objDay);
        }

        dayMap.putIfAbsent("$year${month.toString().padLeft(2, '0')}", () => dayList);
      }
    }
    final dateTime = DateTime.now();
    setDateTitle(dateTime.year.toString(), dateTime.month.toString());
    currentPagePosition = getPagePosition(dateTime.year, dateTime.month);
    pageViewController = PageController(initialPage: currentPagePosition);

    pageViewController.addListener(() {
      if (currentPagePosition != pageViewController.page?.round()) {
        currentPagePosition = pageViewController.page?.round() ?? 0;
        final date = getDayMapKey(currentPagePosition);
        setDateTitle(date.substring(0, 4), date.substring(4));
      }
    });

    isInit.value = true;
  }

  /// 현재날짜가 가능한 요일인지 체크
  /// yyyymmdd
  bool _isPossibleDayOfTheWeek(int year, int month, int day) {
    bool result = false;

    final dateTime = DateTime(year, month, day);

    switch (dateTime.weekday) {
      case DateTime.sunday:
        result = possibleDayOfTheWeek.substring(0, 1) == "1";
        break;
      case DateTime.monday:
        result = possibleDayOfTheWeek.substring(1, 2) == "1";
        break;
      case DateTime.tuesday:
        result = possibleDayOfTheWeek.substring(2, 3) == "1";
        break;
      case DateTime.wednesday:
        result = possibleDayOfTheWeek.substring(3, 4) == "1";
        break;
      case DateTime.thursday:
        result = possibleDayOfTheWeek.substring(4, 5) == "1";
        break;
      case DateTime.friday:
        result = possibleDayOfTheWeek.substring(5, 6) == "1";
        break;
      case DateTime.saturday:
        result = possibleDayOfTheWeek.substring(6, 7) == "1";
        break;
    }

    return result;
  }

  /// 날짜 제목
  void setDateTitle(String year, String month) {
    dateTitle.value = "$year.${month.padLeft(2, '0')}";

    int iYear = int.parse(year);
    int iMonth = int.parse(month);

    isLeftPagingPossible.value = !(iYear == visiblePreviousYear && iMonth == startDateTime.month);
    isRightPagingPossible.value = !(iYear == endDateTime.year && iMonth >= 12);
  }

  /// 현재 위치 가져오기
  int getPagePosition(int year, int month) {
    return (year - visiblePreviousYear) * 12 + (month - startDateTime.month);
  }

  /// 요일 맵 키
  String getDayMapKey(int pageIndex) {
    DateTime dateTime = DateTime(visiblePreviousYear, startDateTime.month + pageIndex, 1);
    return "${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}";
  }

  /// 다음 화면
  void nextPage() {
    final currentPage = pageViewController.page?.round() ?? 0;
    if (currentPage < dayMap.length - 1) {
      pageViewController.jumpToPage(currentPage + 1);

      final dayMapKey = getDayMapKey(currentPage + 1);
      setDateTitle(dayMapKey.substring(0, 4), dayMapKey.substring(4));
    }
  }

  /// 이전 화면
  void previousPage() {
    final currentPage = pageViewController.page?.round() ?? 0;
    if (currentPage > 0) {
      pageViewController.jumpToPage(currentPage - 1);

      final dayMapKey = getDayMapKey(currentPage - 1);
      setDateTitle(dayMapKey.substring(0, 4), dayMapKey.substring(4));
    }
  }
}
