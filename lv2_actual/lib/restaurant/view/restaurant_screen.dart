import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2_actual/restaurant/component/restaurant_card.dart';
import 'package:lv2_actual/restaurant/model/restaurant_model.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List>(
                future: paginateRestaurant(),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  print(snapshot.data);
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: Text('No Data'),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final item = snapshot.data![index];
                      //parsed
                      final pItem2 = RestaurantModel.fromJson(json: item);

                      return RestaurantCard.fromModel(
                        model: pItem2,
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
