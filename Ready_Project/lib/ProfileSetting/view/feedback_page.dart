import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('피드백 남기기'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text('FinCare를 사용하시면서 느낀 불편함을 제보해주세요!'),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              controller: feedbackController,
              maxLines: 16,
            ),
            OutlinedButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('피드백 전송'),
                        content: Text('해당 내용을 전송하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('전송'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('취소'),
                          ),
                        ],
                      );
                    });

                SendFeedBack(feedbackController.text);
                Navigator.of(context).pop();
              },
              child: Text('피드백 전송하기'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> SendFeedBack(String feedbackContent) async {

    print(feedbackContent);
    //여기에 피드백 보내는 거 코드 api쓰고 .


  }
}
