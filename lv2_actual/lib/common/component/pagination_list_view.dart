import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/model/cursor_pagination_model.dart';
import 'package:lv2_actual/common/model/model_with_id.dart';
import 'package:lv2_actual/common/provider/pagination_provider.dart';
import 'package:lv2_actual/common/utils/pagination_utils.dart';

import '../../product/provider/product_provider.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {

  final PaginationWidgetBuilder<T> itemBuilder;

  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    super.key,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    //현재 위치가 최대 길이가 보다 조금 덜 되는 위치까지 왔다면, 새로운 데이터를 추가요청해라.

    //스크롤러의 현재 위치가, 스크롤러의 최대 스크롤 가능한 길이의 300픽셀정도 적은길이 보다 크다면 -> 데이터 더 가져오는 함수 실행.
    // if (scrollController.offset >
    //     scrollController.position.maxScrollExtent - 300)
    //   ref.read(restaurantProvider.notifier).paginate(
    //         fetchMore: true,
    //       );
    PaginationUtils.paginate(
      scrollController: scrollController,
      provider: ref.read(
        widget.provider.notifier,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //에러
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(
                      forceRefetch: true,
                    );
              },
              child: Text('다시 시도')),
        ],
      );
    }

    //나머지 3개의 상태는 모두 CursorPagination의 자식이다. CursorPaginationRefetching, FetchingMore, CursorPagination
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: scrollController,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: cp is CursorPaginataionFetchingMore
                      ? CircularProgressIndicator()
                      : Text('마지막 데이터 입니다.'),
                ));
          }
          final pItem = cp.data[index];
          //parsed
          // final pItem2 = RestaurantModel.fromJson(item);

          return widget.itemBuilder(context,index,pItem);
        },
        separatorBuilder: (_, index) {
          return SizedBox(
            height: 16.0,
          );
        },
      ),
    );
  }
}
