class ScanLog {
  final String id;
  final String scanType; // 'TEAM_ENTRY', 'FOOD_COUPON', 'SWAG'
  final String targetName;
  final String detail;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String venueZone;
  final bool isSuccess;

  ScanLog({
    required this.id,
    required this.scanType,
    required this.targetName,
    required this.detail,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.venueZone,
    this.isSuccess = true,
  });
}
