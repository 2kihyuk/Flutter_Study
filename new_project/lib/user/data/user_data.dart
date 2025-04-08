

//사용자에 대한 정보.
/// User 클래스는 어디서 쓰이는가?
/// 회원가입 및 로그인 할때.
/// 프로필 페이지를 조회할때, 해당 프로필이 나 자신의 프로필인지? 혹은 다른 사용자의 프로필인지.
///
class User{

  final String user_Name;
  final String user_ID;
  final String? user_PW;
  final String user_Number;
  final bool isUserIsMe; //사용자가 나 자신인지, 다른 사용자인지?

  User({
    required this.user_Name,
    required this.user_ID,
    this.user_PW,
    required this.user_Number,
    required this.isUserIsMe
  });

}