import 'package:flutter/cupertino.dart';

import '../provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController scrollController,
    required PaginationProvider provider,
  }) {
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300)
      provider.paginate(
        fetchMore: true,
      );
  }
}
