import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';

enum BroadcastPriority {
  info('Informational', VortexTheme.neonCyan),
  alert('Warning Alert', Colors.orangeAccent),
  urgent('Urgent Schedule Change', Colors.redAccent);

  final String label;
  final Color color;
  const BroadcastPriority(this.label, this.color);
}

class BroadcastConsoleView extends StatefulWidget {
  const BroadcastConsoleView({super.key});

  @override
  State<BroadcastConsoleView> createState() => _BroadcastConsoleViewState();
}

class _BroadcastConsoleViewState extends State<BroadcastConsoleView> {
  final _messageController = TextEditingController();
  BroadcastPriority _priority = BroadcastPriority.info;
  bool _sendPush = true;
  bool _pinToStage = false;

  final List<Map<String, dynamic>> _history = [];

  void _sendBroadcast() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _history.insert(0, {
        'priority': _priority,
        'message': _messageController.text.trim(),
        'sentAt': 'Just now',
        'reach': '452 devices (WebSocket Broadcast)',
      });
      _messageController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: VortexTheme.surface,
        content: Row(
          children: const [
            Icon(LucideIcons.radio, color: VortexTheme.telemetryGreen),
            SizedBox(width: 10),
            Text('WebSocket Broadcast Dispatched across 452 active sockets!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BROADCAST CONSOLE',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: VortexTheme.neonCyan,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Global WebSocket push notification dispatch with channel priority levels',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Composer
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRIORITY CHANNEL',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: VortexTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 10),
                Row(
                  children: BroadcastPriority.values.map((p) {
                    final isSelected = _priority == p;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ChoiceChip(
                        label: Text(p.label),
                        selected: isSelected,
                        selectedColor: p.color.withOpacity(0.25),
                        backgroundColor: VortexTheme.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? p.color : VortexTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? p.color : VortexTheme.textSecondary.withOpacity(0.2),
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _priority = p);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  style: const TextStyle(color: VortexTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Type announcement payload for instant live broadcast...',
                    hintStyle: const TextStyle(color: VortexTheme.textSecondary),
                    filled: true,
                    fillColor: VortexTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: _priority.color.withOpacity(0.4)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Checkbox(
                      value: _sendPush,
                      activeColor: VortexTheme.neonCyan,
                      onChanged: (val) => setState(() => _sendPush = val ?? true),
                    ),
                    const Text('Send PWA Push', style: TextStyle(color: VortexTheme.textPrimary, fontSize: 13)),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: _pinToStage,
                      activeColor: VortexTheme.neonViolet,
                      onChanged: (val) => setState(() => _pinToStage = val ?? false),
                    ),
                    const Text('Overlay on Stage Projector', style: TextStyle(color: VortexTheme.textPrimary, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _sendBroadcast,
                    icon: const Icon(LucideIcons.send),
                    label: const Text('DISPATCH LIVE BROADCAST'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _priority.color,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Broadcast History
          Text('TRANSMISSION LOGS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: VortexTheme.textSecondary,
                    letterSpacing: 1.5,
                  )),
          const SizedBox(height: 12),
          ..._history.map((item) {
            final BroadcastPriority p = item['priority'] as BroadcastPriority;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 50,
                      decoration: BoxDecoration(
                        color: p.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p.label.toUpperCase(),
                                  style: TextStyle(color: p.color, fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('${item['sentAt']} • ${item['reach']}',
                                  style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(item['message'], style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 14)),
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
