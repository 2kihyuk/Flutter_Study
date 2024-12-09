import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUri = Uri.parse('https://blog.codefactory.ai');

class HomeScreen extends StatelessWidget {

  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..loadRequest(homeUri);

  ///점 2개를 찍으면 -> loadRequest함수를 실행하는데 , 함수를 실행한 결과를 반환하는게 아니고, 함수를 실행한 대상을 반환하라는뜻이다.
  ///결국, loadRequest를 실행한 인스턴스를 반환한다.
  ///final controller2 = WebViewController()..loadRequest();
  ///final controller2 = WebViewController(); 위 두개는 같은 뜻이다.

  HomeScreen({super.key});

  @override
  Widget lbuid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Code Factory'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            controller.loadRequest(homeUri);
          } , icon: Icon(
            Icons.home
          )
          )
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
