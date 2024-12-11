class Schedule{

  ///식별 가능한 ID
  final int id;
  ///시작 시간
  final int startTime;
  ///종료 시간
  final int endTime;
  ///일정 내용
  final String content;
  ///날짜
  final DateTime date;
  ///카테고리
  final String color;
  ///일정 생성날짜시간
  final DateTime createdAt; ///일정을 생성한 시간
///
    Schedule({
      required this.id,
      required this.startTime,
      required this.endTime,
      required this.content,
      required this.date,
      required this.color,
      required this.createdAt
    });


}