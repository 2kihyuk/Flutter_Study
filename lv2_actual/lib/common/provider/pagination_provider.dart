import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/model/model_with_id.dart';
import 'package:lv2_actual/common/repository/base_pagination_repository.dart';

import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

class PaginationProvider<
        T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
        extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()){
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    //true 일 경우 , 추가로 데이터 더 가져와라.
    //false 일 경우. 새로고침(현재 상태를 덮어씌움)
    bool fetchMore = false,
    //true일 경우 ,강제로 다시 로딩하기- CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // final resp = await repository.paginate();
      //
      // state = resp;
      //5가지 가능성 존재 State의 상태. -> CursorPagination에 대한 클래스를 5개 모두 정의해두었음.

      //1) 상태가 CursorPagination일때 - 정상적으로 데이터가 존재할때.
      //2) 상태가 CursorPaginationLoading일때 - 데이터가 로딩중인 상태일때  (현재 캐시없음)
      //3) 상태가 CursorPaginationError일때 - 데이터가 에러가 있을때
      //4) 상태가 CursorPaginationReFetching일때 - 첫번째 데이터부터 다시 데이터를 가져올때
      //5) 상태가 CursorPaginationFetchMore일때 - 추가 데이터를 paginate해오라는 요청을 받았을때.

      //바로 반환하는 상황
      //1) hasMore가 false 일때. (기존 상태에서 이미 다음 데이터가 없다는 값을 가지고있다면) -> 더이상 Paginate()를 실행할 필요가 없음.
      //2) 로딩중일때 - fetchMore가 true일때 - 앱에서 맨 아래까지 스크롤을 다 땡겨서 추가로 데이터를 더 가져와라 하는 상황. ,
      // 로딩중인데, fetchMore가 false일때 - 그냥 함수를 실행할거임. 왜? 새로운 데이터를 가져오는 도중에, 새로고침을 하면, 새로고침 작업을 실행함. -> 새로고침의 의도가 있다. 기존요청 무시하고 새로고침.

      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      //3가지의 로딩 상태.
      final isLoading = state is CursorPaginationLoading;
      final isReFetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginataionFetchingMore;

      //2번 반환 상황. 로딩중일때, 새로고침의 의도가 있다면, 그냥 새로고침 해버리기.
      if (fetchMore && (isLoading || isReFetching || isFetchingMore)) {
        return;
      }
      //PaginationParams 생성.
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchMore 상황. 데이터를 추가로 더 가져와야하는 상황. 이미 첫번째 페이지를 가져와서 20개의 데이터가 존재하는 상황에서 ㅇ추가로 20개를 더 요청하면, 가장 마지막 데이터의 id를 기준으로 다음 데이터 가져오는
      //상황.

      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state =
            CursorPaginataionFetchingMore<T>(data: pState.data, meta: pState.meta);
        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      }
      //데이터를 처음부터 가져오는 상황
      else {
        //만약에 데이터가 있는 상황이라면 , 기존 데이터를 보존한 채로 Fetch(API 요청) 를 진행.
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state =
              CursorPaginationRefetching(data: pState.data, meta: pState.meta);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginataionFetchingMore) {
        final pState = state as CursorPaginataionFetchingMore<T>;

        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
      } else {
        state = resp;
      }
    } catch (e,stack) {
      print(e);
      print(stack);
      state =
          CursorPaginationError(message: '데이터를 가져오지 못했습니다. - ${e.toString()}');
    }
  }
}
