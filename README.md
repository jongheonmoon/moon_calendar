<p align="center">
  <img src="https://raw.githubusercontent.com/jongheonmoon/moon_calendar/master/preview/my_img.png" />
</p>
 
<h1 align="center">Flutter Calendar</h1>

## Git Hub

[https://github.com/jongheonmoon/moon_calendar](link)


## Download

```
moon_calendar: ^1.0.2
```

## Example

```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    DateTime startDateTime = DateTime.now();
    DateTime endDateTime = DateTime.now().add(const Duration(days: 365));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Calender(
        startDateTime: startDateTime,
        selectCallback: (DateTime dateTime) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(dateTime.toString()),
            duration: const Duration(seconds: 3), // 올라와있는 시간
          ));
        },
        endDateTime: endDateTime,
        disableSelectedCallback: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("선택 안되는 날짜"),
            duration: Duration(seconds: 3), // 올라와있는 시간
          ));
        },
        isTodayColor: true,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```
 
## Preview

<p align="center">
  <img src="https://github.com/jongheonmoon/moon_calendar/blob/master/preview/preview1.png?raw=true" />
</p>
 
 
### Updates
### 1.0.0

 - 최초 업로드

### 1.0.1

- 소스 정리
- 주석 추가
- 설명 문구 수정

### 1.0.2

- README.md 수정
- Dart format 변경