import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/dio/dio.dart';
import 'package:lv2_actual/common/layout/default_layout.dart';
import 'package:lv2_actual/product/component/product_card.dart';
import 'package:lv2_actual/restaurant/component/restaurant_card.dart';
import 'package:lv2_actual/restaurant/repository/restaurant_repository.dart';

import '../../common/const/data.dart';
import '../model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({required this.id, super.key});

  // Future<Map<String,dynamic>> getRestaurantDetail() async {
  //   final dio = Dio();
  //
  //
  //   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //
  //   final resp = await dio.get('http://$ip/restaurant/$id',
  //       options: Options(headers: {
  //         'authorization': 'Bearer $accessToken',
  //       }));
  //
  //   return resp.data;
  // }

  // Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async{
  //   // final dio = Dio();
  //   // //여기서 dio.interceptors.add()에 우리가 정의한 customInterceptor를 넣어주면서, dio요청이 딱 전송되기 전에 interceptor가 해당 요청을 가로채서
  //   // //요청을 보낼떄, 요청을 받을때, 에러가 발생할때의 3가지 케이스에 대한 로직을 확인한다.
  //   //
  //   // dio.interceptors.add(
  //   //   CustomInterceptor(storage: storage),
  //   // );
  //   // final dio = ref.watch(dioProvider);
  //   // final repository = RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant');
  //   //
  //   // return repository.getRestaurantDetail(id: id);
  //   return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        title: '불타는 떡볶이',
        child: FutureBuilder<RestaurantDetailModel>(
          future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id),
          builder: (_,AsyncSnapshot<RestaurantDetailModel> snapshot){
            print(snapshot.data);

            if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // final item = RestaurantDetailModel.fromJson(snapshot.data!,);
            return CustomScrollView(
              slivers: [
                renderTop(model: snapshot.data!),
                renderLabel(),
                renderProducts(products: snapshot.data!.products),
              ],
            );
          },
        ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products
}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
