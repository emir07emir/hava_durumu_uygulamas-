class OpenMeteo {
  double latitude;
  double longitude;
  String timezone;
  Map<String,dynamic>daily;
  Map<String,dynamic>hourly;

  OpenMeteo({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.daily,
    required this.hourly,
  });

  factory OpenMeteo.fromJson(Map<String, dynamic>json){
    return OpenMeteo(
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      timezone: json["timezone"],
      daily: json["daily"] as Map<String,dynamic>,
      hourly: json["hourly"] as Map<String,dynamic>,
    );
  }


}
