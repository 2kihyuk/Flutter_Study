import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/provider/pagination_provider.dart';
import 'package:lv2_actual/product/repository/product_repository.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/product_model.dart';


final productProvider = StateNotifierProvider<ProductStateNotifier,CursorPaginationBase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductStateNotifier(repository: repository);

});

class ProductStateNotifier extends PaginationProvider<ProductModel, ProductRepository>{
  ProductStateNotifier({
    required super.repository,
});

}