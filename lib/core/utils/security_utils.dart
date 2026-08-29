import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  /// Dynamic QR Refresh Logic: 
  /// Timestamped hashing function preventing replay attacks.
  /// Generates a hash based on the userId and the current time block (e.g., every 20 seconds).
  static String generateDynamicQRHash(String userId, {int refreshIntervalSeconds = 20}) {
    final int currentEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // Divide by refreshInterval to get the current time block
    final int timeBlock = currentEpoch ~/ refreshIntervalSeconds;
    
    final String dataToHash = '$userId-$timeBlock';
    final List<int> bytes = utf8.encode(dataToHash);
    final Digest digest = sha256.convert(bytes);
    
    return digest.toString();
  }
}
