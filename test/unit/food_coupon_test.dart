import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/features/coupons/models/food_coupon.dart';

void main() {
  group('FoodCoupon Model Tests', () {
    test('FoodCoupon serialization, verification and qr payload generation', () {
      final coupon = FoodCoupon(
        id: 'COUPON-01',
        eventId: 'sprint-2026',
        userId: 'usr-1',
        userName: 'Alice Dev',
        mealType: 'Midnight Snack',
        validTimeWindow: '00:00 - 02:00',
        isRedeemed: false,
      );

      expect(coupon.id, 'COUPON-01');
      expect(coupon.isRedeemed, false);
      expect(coupon.qrPayload, contains('COUPON-01'));
      expect(coupon.qrPayload, contains('Midnight Snack'));

      final json = coupon.toJson();
      final fromJson = FoodCoupon.fromJson(json);

      expect(fromJson.id, 'COUPON-01');
      expect(fromJson.mealType, 'Midnight Snack');
      expect(fromJson.isRedeemed, false);

      final redeemed = coupon.copyWith(
        isRedeemed: true,
        redeemedLocation: 'Main Gate Checkpoint',
        redeemedAt: '01:15 AM',
      );

      expect(redeemed.isRedeemed, true);
      expect(redeemed.redeemedLocation, 'Main Gate Checkpoint');
      expect(redeemed.redeemedAt, '01:15 AM');
    });
  });
}
