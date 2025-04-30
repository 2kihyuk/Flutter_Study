import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapsnsproject/common/component/custom_text_form_field.dart';
import 'package:mapsnsproject/common/layout/default_layout.dart';
import 'package:mapsnsproject/map/layout/g_map.dart';
import 'package:readmore/readmore.dart';

import '../../common/const/colors.dart';

///1. 유저가 누군지.. 만약 사용자 자신의 프로필 화면이라면 사용자명옆에 있는 점세개 짜리 버튼이 보이지만, 다른 유저의 프로필 화면에 들어왔다면 해당 버튼은 invisible하게 할 수 있어야함.
///2. 사용자이름(혹은 ID) - 댓글 내용 을 get해서 list에 넣어줄 수 있어야함.
///3. 댓글을 입력하고 onTap시 댓글을 입력한 사용자정보, 댓글 내용, 어떤 글에 달았는지 등의 정보를 post 할 수 있어야함.
///4. 장소 정보를 띄워주는 UI는 어떻게 수정할 것인가? 지도 띄울 것인가? 고민해봐야함.
///
class SnsFeedScreen extends StatefulWidget {
  const SnsFeedScreen({super.key});

  @override
  State<SnsFeedScreen> createState() => _SnsFeedScreenState();
}

class _SnsFeedScreenState extends State<SnsFeedScreen> {

  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final dummyComments = List.generate(
      10,
      (i) => {
        'user': 'user$i',
        'text': '댓글 내용 #$i: 길어지면…더보기 기능을 씁니다더보기 기능을 씁니다더보기 기능을 씁니다.',
      },
    );

    return DefaultLayout(
      titleText: '게시물',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1) 아바타
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Icon(
                        Icons.person_outline,
                        size: 24,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  // 2) 사용자명 + 위치
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '사용자 아이디',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '장소명',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3) 옵션 아이콘
                  IconButton(
                    onPressed: () {
                      // 메뉴 열기 등 동작
                    },
                    icon: Icon(Icons.more_horiz),
                    splashRadius: 20,
                  ),
                ],
              ),

              SizedBox(height: 24),

              ///사진 공간
              Container(
                color: Colors.red,
                width: double.infinity,
                child: Image.network(
                  'https://mapsnsproject1504616c5-dev.s3.ap-northeast-2.amazonaws.com/user_images/1745745367536.jpg',
                ),
              ),
              SizedBox(height: 16.0),

              ///사용자가 입력한 본문 내용 공간
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '사용자 아이디',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '이것은 본문이 들어갈 공간입니다.',
                        softWrap: true,
                        overflow: TextOverflow.visible, // 필요 시 보이게
                      ),
                    ),
                  ],
                ),
              ),

              ///다른 사용자들이 작성한 댓글 목록 공간
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   '타 유저 아이디',
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dummyComments.length,

                        itemBuilder: (context, index) {
                          final c = dummyComments[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['user']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ReadMoreText(
                                    c['text']!,
                                    trimLines: 1,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: '…더보기',
                                    trimExpandedText: ' 접기',
                                    delimiter: '',
                                    style: TextStyle(fontSize: 14),
                                    moreStyle: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    lessStyle: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
             ///댓글 입력하는 필드.
             TextFormField(
               controller: commentController,
               decoration: InputDecoration(
                 contentPadding: EdgeInsets.all(10),
                 hintStyle: TextStyle(
                   color:BODY_TEXT_COLOR,
                   fontSize: 14.0,
                 ),
                 hintText: '댓글을 입력하세요.',
                 suffixIcon: IconButton(onPressed: (){}, icon: Icon((Icons.add_comment))),
                 filled: true,
                 border: OutlineInputBorder(
                   borderSide: BorderSide(
                     color: INPUT_BORDER_COLOR,
                     width: 1.0,
                   ),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     color: INPUT_BORDER_COLOR,
                     width: 1.0,
                   ),
                 ),
               ),
             ),

              SizedBox(height: 16.0),

              ///장소 디테일 정보
              ExpansionTile(
                title: Text('장소 정보'),
                // 1) 타이틀(헤더) 영역의 좌우 패딩을 0으로
                tilePadding: EdgeInsets.zero,
                // 2) 열렸을 때 자식들이 차지하는 영역 전체의 패딩을 0으로
                childrenPadding: EdgeInsets.zero,
                // 3) 자식들을 Column처럼 start(왼쪽)에 붙여서 배치
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('장소명 : 화곡 투썸플레이스'),
                  Text('주소 : 서울시 강서구 우현로 67 1층'),
                  Text('별점 : 4.8'),
                  Text('리뷰 개수: 392개'),
                ],
              ),
            ],
          ),
        ),
      ),
      IsaddButton: false,
    );
  }
}

///보여줘야 할 정보 :
/// 장소의 지명(장소명) , 주소(있는경우에) , 다른 사용자들의 평점 및 개수 ? 다녀온 게시글의 사용자가 평가한 평점?
/// 사진, 본문 내용.
///
// showDialog(
// context: context,
// builder:
// (_) => AlertDialog(
// title: Text('게시글 정보'),
// content: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('작성자: khyuk2'),
// SizedBox(height: 8),
// Text('장소: 관악산 연주대 정상'),
// SizedBox(height: 8),
// Text('시간: ${DateTime.now().toLocal()}'),
// // 추가로 보여줄 정보가 있으면 여기에 더 넣어주세요
// ],
// ),
// actions: [
// TextButton(
// onPressed: () => Navigator.of(context).pop(),
// child: Text('닫기'),
// ),
// ],
// ),
// );
