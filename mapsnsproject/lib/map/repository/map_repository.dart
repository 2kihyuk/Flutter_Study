import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapsnsproject/map/data/address_data.dart';


final pickPlaceProvider = StateProvider<Place>((ref) {
  return Place(
    formatted_address: '',
    geometry: Geometry(location: Location(lat: 0.0, lng: 0.0)),
    name: '',
    rating: 0.0,
    user_ratings_total: 0,
  );
});
