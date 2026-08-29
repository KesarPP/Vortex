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

  String get qrPayload => 'VORTEX-COUPON::$id::$eventId::$userId::$mealType';
}
