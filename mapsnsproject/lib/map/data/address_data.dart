class PlaceResponse {
  final List<Place> results;
  final String status;

  PlaceResponse({required this.results, required this.status});

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    return PlaceResponse(
      results:
          (json['results'] as List)
              .map((item) => Place.fromJson(item))
              .toList(),
      status: json['status'],
    );
  }
}

class Place {
  final String formatted_address;
  final Geometry geometry;
  final String name;
  final OpeningHours? openingHours;
  final double rating;
  final int user_ratings_total;

  Place({
    required this.formatted_address,
    required this.geometry,
    required this.name,
    this.openingHours,
    required this.rating,
    required this.user_ratings_total,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      formatted_address: json['formatted_address'],
      geometry: Geometry.fromJson(json['geometry']),
      name: json['name'],
      openingHours: json['opening_hours'] != null
          ? OpeningHours.fromJson(json['opening_hours']) // opening_hours가 있을 경우에만 처리
          : null,
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()  // int 타입일 경우 double로 변환
          : json['rating']?.toDouble() ?? 0.0,  // null 값 처리
      user_ratings_total: json['user_ratings_total'] ?? 0,
    );
  }
}


class Geometry {

  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String,dynamic> json){
    return Geometry(location: Location.fromJson(json['location']));
  }


}

class OpeningHours{
    final bool openNow;

    OpeningHours({required this.openNow});

    factory OpeningHours.fromJson(Map<String,dynamic> json){
      return OpeningHours(openNow: json['open_now'] ?? false);
    }
}

class Location{
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String,dynamic> json){
    return Location(lat: json['lat'], lng: json['lng']);
  }
}
