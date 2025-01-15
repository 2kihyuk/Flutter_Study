import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver {
  ///Provider를 업데이트 한 직후에 실행되는 함수
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    // TODO: implement didUpdateProvider
    super.didUpdateProvider(provider, previousValue, newValue, container);
    print('[Provider updated] provider : $provider  / Pv : $previousValue / Nv : $newValue');
  }
  ///Provider를 추가하면 불리는 함수
  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value, ProviderContainer container) {
    // TODO: implement didAddProvider
    super.didAddProvider(provider, value, container);
    print('[Provider Added] provider : $provider  / value : $value ');
  }
  ///Provider가 삭제됬을때
  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    // TODO: implement didDisposeProvider
    super.didDisposeProvider(provider, container);
    print('[Provider dispose] provider : $provider');
  }
}
