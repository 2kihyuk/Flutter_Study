import 'package:actual_riverpod/layout/default_layout.dart';
import 'package:actual_riverpod/riverpod/future_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FutureProviderScreen extends ConsumerWidget {
  const FutureProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multipleFutureProvider);
    //multiFutureProvider를 watch하고 있다가 값이 반환되거나 상태가 변경된다면 각각의 파라미터에 해당하는 함수들이 실행되어서 값이 렌더링됨을 알 수있다.
    //여기서 state는 AsyncValue타입인데, Future자체가 비동기이기 때문에, AsyncValue는 when이라는 함수를 자동으로 가지고있는데,
    //이때 when안에는 기본적으로 내장 파라미터(함수타입)으로 data, error, loading을 가지고있다. 각각의 상황에 들어맞는 함수들이 실행되는 로직이다.
    //data함수 파라미터는 로딩이 끝나고 데이터가 존재할때 실행되며, error함수 파라미터는 에러가 발생했을때 실행되며, loading은 로딩중에 실행되는 함수이다.

    return DefaultLayout(
      title: 'FutureProvider Screen',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          state.when(
            data: (data) {
              return Text(
                data.toString(),
                textAlign: TextAlign.center,
              );
            }, //로딩이 끝나고 데이터가 있을떄
            error: (err, stack) => Text(
              err.toString(),
            ), //에러가있을때
            loading: () => Center(
              child: CircularProgressIndicator(),
            ), //로딩중일때
          ),
        ],
      ),
    );
  }
}
