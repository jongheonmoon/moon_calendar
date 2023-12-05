part of "../calendar.dart";

class _DayOfWeekTitle extends StatelessWidget {
  const _DayOfWeekTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 38 / 46,
        ),
        itemCount: 7,
        itemBuilder: (context, index) => dayOfWeek(index),
      ),
    );
  }

  Widget dayOfWeek(int index) {
    var dayOfWeekString = "";
    switch (index) {
      case 0:
        dayOfWeekString = "일";
        break;
      case 1:
        dayOfWeekString = "월";
        break;
      case 2:
        dayOfWeekString = "화";
        break;
      case 3:
        dayOfWeekString = "수";
        break;
      case 4:
        dayOfWeekString = "목";
        break;
      case 5:
        dayOfWeekString = "금";
        break;
      case 6:
        dayOfWeekString = "토";
        break;
    }

    return Text(
      dayOfWeekString,
      style: const TextStyle(
        color: AppColors.appColor88,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: AppSizes.fontSize13,
      ),
      textAlign: TextAlign.center,
    );
  }
}
