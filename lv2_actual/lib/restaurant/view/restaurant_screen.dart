import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2_actual/common/dio/dio.dart';
import 'package:lv2_actual/restaurant/component/restaurant_card.dart';
import 'package:lv2_actual/restaurant/model/restaurant_model.dart';
import 'package:lv2_actual/restaurant/repository/restaurant_repository.dart';
import 'package:lv2_actual/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    final resp  = await RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant').paginate();


    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // final resp = await dio.get('http://$ip/restaurant',
    //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<RestaurantModel>>(
                future: paginateRestaurant(),
                builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final pItem2 = snapshot.data![index];
                      //parsed
                      // final pItem2 = RestaurantModel.fromJson(item);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(id: pItem2.id,),
                            ),
                          );
                        },
                        child: RestaurantCard.fromModel(
                          model: pItem2,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(
                        height: 16.0,
                      );
                    },
                  );
                },
              ))),
    );
  }
}
