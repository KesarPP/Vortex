class FoodCoupon {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final String mealType; // 'Breakfast', 'Lunch', 'Dinner', 'Midnight Snack', 'Swag Pack'
  final String validTimeWindow;
  bool isRedeemed;
  String? redeemedAt;
  String? redeemedLocation;
  double? latitude;
  double? longitude;

  FoodCoupon({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.mealType,
    required this.validTimeWindow,
    this.isRedeemed = false,
    this.redeemedAt,
    this.redeemedLocation,
    this.latitude,
    this.longitude,
  });

  FoodCoupon copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? userName,
    String? mealType,
    String? validTimeWindow,
    bool? isRedeemed,
    String? redeemedAt,
    String? redeemedLocation,
    double? latitude,
    double? longitude,
  }) {
    return FoodCoupon(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      mealType: mealType ?? this.mealType,
      validTimeWindow: validTimeWindow ?? this.validTimeWindow,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      redeemedLocation: redeemedLocation ?? this.redeemedLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory FoodCoupon.fromJson(Map<String, dynamic> json) {
    return FoodCoupon(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      mealType: json['mealType'] ?? '',
      validTimeWindow: json['validTimeWindow'] ?? '',
      isRedeemed: json['isRedeemed'] ?? false,
      redeemedAt: json['redeemedAt'],
      redeemedLocation: json['redeemedLocation'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'userId': userId,
        'userName': userName,
        'mealType': mealType,
        'validTimeWindow': validTimeWindow,
        'isRedeemed': isRedeemed,
        'redeemedAt': redeemedAt,
        'redeemedLocation': redeemedLocation,
        'latitude': latitude,
        'longitude': longitude,
      };

  String get qrPayload => 'VORTEX-COUPON::$id::$eventId::$userId::$mealType';
}
