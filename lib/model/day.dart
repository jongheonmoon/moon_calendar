part of "../calendar.dart";

class Day {
  Day({
    this.day = '',
    this.isWeekend = false,
    this.isToday = false,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final bool isWeekend;
  final bool isDisabled;
  final bool isToday;
  final String day;
  bool isSelected;

}
