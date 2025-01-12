import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lv2_actual/common/const/data.dart';

/// Dio를 쓰는 이유.
/// 인터셉트란. 중간에 가로채다.
/// 1) 요청을 보낼때
/// 2) 요청을 받을때
/// 3) 에러가 났을때
/// 이 세가지 경우에 대해서 중간에 가로채서 변환을해서 반환할 수 있다.

class CustomInterceptor extends Interceptor{

  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
});
  //1) 요청을 보낼때
  //요청이 보내질때마다 만약 요청의 헤더에 accessToken == true라는 값이 있다면, 실제 토큰을  스토리지에서 가져와서 authorization : Bearer token 으로 헤더를 변경한다.
  //왜 이렇게하냐? 어떤 레포지토리던, 토큰이 필요한 요청을 할때마다, 이 헤더안에다가 매번 토큰값을 직접 넣어줄 수 없기때문에, 요청을 보낼때마다 헤더에 실제 토큰 값을 읽어와서 넣어주는 작업을 해줘야한다.
  //onRequest를 통해서 요청을 보낼때마다 해당 요청의 헤더를 읽을 수 가 있으니까 repository에 Header에다가   accessToken : true값을 이미 넣어두었기 때문에 가능.

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    //헤더 삭제
    if(options.headers['accessToken'] == 'true'){
      options.headers.remove('accessToken');

      //실제 토큰으로 헤더값 변경
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }

    if(options.headers['refreshToken'] == 'true'){
      options.headers.remove('refreshToken');

      //실제 토큰으로 헤더값 변경
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({
        'authorization' : 'Bearer $token',
      });
    }
   

    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }


  //2) 응답을 받을때
@override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');


    return super.onResponse(response, handler);
  }


  //3) 에러가 났을때
  //401에러 -> 토큰에 문제가 있을때./ 이때는 토큰을 재발급받는 시도를하고, 재발급되면, 새로운 토큰으로 요청을 하는 작업을 원함.
  //요청을 보내기전에. dio.Interceptor를 통해서 요청의 헤더에 제대로 된 토큰값이 있나 확인을 하는데, 만약 onRequest가 실행되기전에 err이 확인된다면
  //onError가 실행되며, 우선 리프레쉬 토큰을 읽고,
  //리프레쉬 토큰이 없다면 오류를 던져야하며,
  //401에러인지(액세스 토큰이 만료 되어서 생긴 오류) , api요청의 경로가 잘못되어 생긴오류인지를 확인하는데
  //이때 401에러지만, 경로가 잘못되지 않았다면,
  // refresh토큰을 이용해서 새로운 액세스 토큰을 발급받아서 헤더에 새로운 액세스 토큰을 넣어주고 반환해주며, 스토리지에 새로운 액세스 토큰을 다시 써줘야 한다.
  //그리고 dio.fetch()를 통해 다시 전송한다.

  //액세스 토큰을 발급하기위한 리프레쉬 토큰도 없다면 에러를 던질수 밖에 없다. 할 수 있는것이 없다 더이상.
  //만약 try문 내에사 새로운 액세스 토큰을 발급하는 과정에서도 오류가 발생한다면 이때도 에러를 던질 수 밖에없다. 할 수 있는 것 이없다.

@override
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    // TODO: implement onError
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken이 없다면 에러를 던진다.
    if(refreshToken == null){
      //에러를 던질때는 handler.reject(err)을 사용한다. 정해진 룰이다.
      handler.reject(err);
      return;
    }
    final isState401 = err.response?.statusCode == 401; //토큰이 잘못 되었다.
    final isPathRefresh = err.requestOptions.path == '/auth/token'; //에러가 난 요청이 토큰을 발급받으려던 요청이었는가?


    try{
      if(isState401 && !isPathRefresh) {
        final dio = Dio();
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        //토큰 변경하기
        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        //요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      }
    }on DioException catch(e){
      return handler.reject(e);
    }

    return handler.reject(err);
  }

}