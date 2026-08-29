import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../events/providers/event_team_provider.dart';

enum ScannerMode {
  teamGate('Team Entry Verification', LucideIcons.doorOpen, VortexTheme.neonCyan),
  breakfast('Breakfast Checkpoint', LucideIcons.coffee, Colors.amberAccent),
  lunch('Lunch Checkpoint', LucideIcons.utensils, Colors.orangeAccent),
  dinner('Dinner Checkpoint', LucideIcons.soup, VortexTheme.neonViolet),
  swag('Swag Distribution', LucideIcons.gift, VortexTheme.telemetryGreen);

  final String label;
  final IconData icon;
  final Color color;
  const ScannerMode(this.label, this.icon, this.color);
}

class ScannerHubView extends ConsumerStatefulWidget {
  const ScannerHubView({super.key});

  @override
  ConsumerState<ScannerHubView> createState() => _ScannerHubViewState();
}

class _ScannerHubViewState extends ConsumerState<ScannerHubView> {
  ScannerMode _activeMode = ScannerMode.teamGate;
  String _scanResult = 'Awaiting Barcode / QR Target in Viewfinder...';
  String _lastLocationStamp = 'GPS: Waiting for scan...';
  bool _lastSuccess = true;
  bool _isScanning = false;
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _triggerScan() async {
    final eventState = ref.read(eventTeamProvider);
    final myTeam = eventState.myTeam;

    String target = myTeam?.name ?? 'Team CypherFlow';
    String detail = 'Validated for [${_activeMode.label}]';
    String zone = _activeMode == ScannerMode.teamGate ? 'Gate 01 - Main Lobby' : 'Zone C - Dining Hall';

    final log = await ref.read(eventTeamProvider.notifier).recordScan(
          scanType: _activeMode.name.toUpperCase(),
          targetName: target,
          detail: detail,
          venueZone: zone,
          couponId: _activeMode == ScannerMode.breakfast ? 'CPN-01' : _activeMode == ScannerMode.lunch ? 'CPN-02' : null,
        );

    setState(() {
      _lastSuccess = true;
      _scanResult = 'VERIFIED: $target - $detail';
      _lastLocationStamp = '📍 Location: ${log.venueZone} (Lat: ${log.latitude.toStringAsFixed(4)}, Lng: ${log.longitude.toStringAsFixed(4)})';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: VortexTheme.surface,
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle2, color: VortexTheme.telemetryGreen),
            const SizedBox(width: 10),
            Expanded(child: Text('Scan Logged with GPS: Lat ${log.latitude.toStringAsFixed(4)}, Lng ${log.longitude.toStringAsFixed(4)}')),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isScanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty || barcodes.first.rawValue == null) return;
    
    final String barcodeValue = barcodes.first.rawValue!;
    
    setState(() => _isScanning = true);
    
    String target = barcodeValue;
    String detail = 'Validated for [${_activeMode.label}]';
    String zone = _activeMode == ScannerMode.teamGate ? 'Gate 01 - Main Lobby' : 'Zone C - Dining Hall';

    final log = await ref.read(eventTeamProvider.notifier).recordScan(
          scanType: _activeMode.name.toUpperCase(),
          targetName: target,
          detail: detail,
          venueZone: zone,
          couponId: _activeMode == ScannerMode.breakfast ? 'CPN-01' : _activeMode == ScannerMode.lunch ? 'CPN-02' : null,
        );

    if (mounted) {
      setState(() {
        _lastSuccess = true;
        _scanResult = 'VERIFIED: $target - $detail';
        _lastLocationStamp = '📍 Location: ${log.venueZone} (Lat: ${log.latitude.toStringAsFixed(4)}, Lng: ${log.longitude.toStringAsFixed(4)})';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: VortexTheme.surface,
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle2, color: VortexTheme.telemetryGreen),
              const SizedBox(width: 10),
              Expanded(child: Text('Scan Logged with GPS: Lat ${log.latitude.toStringAsFixed(4)}, Lng ${log.longitude.toStringAsFixed(4)}')),
            ],
          ),
        ),
      );
    }
    
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventTeamProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MULTI-MODE SCANNER HUB',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: VortexTheme.neonCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scans Team QR Passes & Individual Food Coupons with GPS Geolocation Tracking',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: VortexTheme.telemetryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: VortexTheme.telemetryGreen),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: VortexTheme.telemetryGreen),
                    const SizedBox(width: 6),
                    Text('${eventState.scanLogs.length} GEO-LOGGED SCANS',
                        style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Fast Mode Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ScannerMode.values.map((mode) {
                final isSelected = _activeMode == mode;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    avatar: Icon(mode.icon, size: 16, color: isSelected ? Colors.black : mode.color),
                    label: Text(mode.label),
                    selected: isSelected,
                    selectedColor: mode.color,
                    backgroundColor: VortexTheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : VortexTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? mode.color : VortexTheme.textSecondary.withOpacity(0.2),
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _activeMode = mode);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Viewfinder
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _activeMode.color.withOpacity(0.4), width: 1.5),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: MobileScanner(
                          controller: _cameraController,
                          onDetect: _handleBarcode,
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          border: Border.all(color: _activeMode.color, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 40,
                        right: 40,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: _activeMode.color, blurRadius: 10, spreadRadius: 2),
                            ],
                            color: _activeMode.color,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.camera, size: 14, color: Colors.white70),
                              const SizedBox(width: 8),
                              Text('MODE: ${_activeMode.label.toUpperCase()}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Scan Output & Geolocation
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: VortexTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _lastSuccess ? VortexTheme.telemetryGreen.withOpacity(0.5) : Colors.redAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _lastSuccess ? LucideIcons.checkCircle : LucideIcons.alertCircle,
                            color: _lastSuccess ? VortexTheme.telemetryGreen : Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _scanResult,
                              style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(_lastLocationStamp, style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 11, fontFamily: 'monospace')),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _triggerScan,
                    icon: const Icon(LucideIcons.scanLine),
                    label: const Text('TRIGGER SCAN & RECORD GEOLOCATION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _activeMode.color,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // LIVE GEOLOCATION AUDIT LOGS
          Text('GEOLOCATION SCAN AUDIT LOGS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: VortexTheme.textSecondary, letterSpacing: 1.5)),
          const SizedBox(height: 12),

          ...eventState.scanLogs.map((log) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: VortexTheme.neonViolet.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.mapPin, color: VortexTheme.neonViolet, size: 16),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(log.targetName, style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('${log.timestamp.hour.toString().padLeft(2, "0")}:${log.timestamp.minute.toString().padLeft(2, "0")}',
                                  style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 11)),
                            ],
                          ),
                          Text(log.detail, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                          Text('📍 ${log.venueZone} • Lat: ${log.latitude.toStringAsFixed(4)}, Lng: ${log.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
