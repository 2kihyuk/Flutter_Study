import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/component/pagination_list_view.dart';
import 'package:lv2_actual/product/component/product_card.dart';
import 'package:lv2_actual/product/model/product_model.dart';
import 'package:lv2_actual/product/provider/product_provider.dart';
import 'package:lv2_actual/restaurant/view/restaurant_detail_screen.dart';

import '../../common/model/cursor_pagination_model.dart';

class ProductScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RestaurantDetailScreen(id: model.restaurant.id,))
              );
            },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
