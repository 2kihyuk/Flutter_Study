import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_actual/common/model/cursor_pagination_model.dart';
import 'package:lv2_actual/common/provider/pagination_provider.dart';

import '../../rating/model/rating_model.dart';
import '../repository/restaurant_rating_repository.dart';

final restaurantRatingProvider = StateNotifierProvider.family<RestaurantRatingStateNotifer,CursorPaginationBase,String>(
    (ref,id){
      final repo = ref.watch(restaurantRatingRepositoryProvider(id));
      return RestaurantRatingStateNotifer(repository: repo);
    });

class RestaurantRatingStateNotifer
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifer({
    required super.repository,
  });
}
