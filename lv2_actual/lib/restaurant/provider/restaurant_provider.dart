import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant_model.dart';
import '../repository/restaurant_repository.dart';

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]){
    paginate();
  }

  paginate() async{
    final resp = await repository.paginate();

    state = resp.data;
  }
}

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
},);
