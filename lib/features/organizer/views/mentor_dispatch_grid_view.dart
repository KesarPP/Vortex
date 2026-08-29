import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';

enum TicketStatus { open, claimed, resolved }

class MentorTicket {
  final String id;
  final String teamName;
  final String tableLocation;
  final String domain;
  final String description;
  final String timeAgo;
  TicketStatus status;
  String? claimedBy;

  MentorTicket({
    required this.id,
    required this.teamName,
    required this.tableLocation,
    required this.domain,
    required this.description,
    required this.timeAgo,
    this.status = TicketStatus.open,
    this.claimedBy,
  });
}

class MentorDispatchGridView extends StatefulWidget {
  const MentorDispatchGridView({super.key});

  @override
  State<MentorDispatchGridView> createState() => _MentorDispatchGridViewState();
}

class _MentorDispatchGridViewState extends State<MentorDispatchGridView> {
  final List<MentorTicket> _tickets = [];

  void _claimTicket(MentorTicket ticket) {
    setState(() {
      ticket.status = TicketStatus.claimed;
      ticket.claimedBy = 'Organizer Dispatch (You)';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket ${ticket.id} claimed!')),
    );
  }

  void _resolveTicket(MentorTicket ticket) {
    setState(() {
      ticket.status = TicketStatus.resolved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: VortexTheme.surface,
        content: Text('Ticket ${ticket.id} marked as RESOLVED.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int openCount = _tickets.where((t) => t.status == TicketStatus.open).length;
    final int claimedCount = _tickets.where((t) => t.status == TicketStatus.claimed).length;

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
                      'LIVE MENTOR DISPATCH GRID',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: VortexTheme.neonCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real-time triage queue with physical table dispatch & resolution tracking',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _Badge(label: '$openCount OPEN', color: Colors.redAccent),
                  const SizedBox(width: 8),
                  _Badge(label: '$claimedCount IN PROGRESS', color: Colors.orangeAccent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tickets Grid
          ..._tickets.map((ticket) {
            Color statusColor;
            String statusLabel;
            switch (ticket.status) {
              case TicketStatus.open:
                statusColor = Colors.redAccent;
                statusLabel = 'OPEN TICKET';
                break;
              case TicketStatus.claimed:
                statusColor = Colors.orangeAccent;
                statusLabel = 'CLAIMED (${ticket.claimedBy})';
                break;
              case TicketStatus.resolved:
                statusColor = VortexTheme.telemetryGreen;
                statusLabel = 'RESOLVED';
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ticket.teamName,
                                  style: const TextStyle(
                                    color: VortexTheme.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: VortexTheme.neonViolet.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.mapPin, size: 12, color: VortexTheme.neonViolet),
                                  const SizedBox(width: 4),
                                  Text(ticket.tableLocation, style: const TextStyle(color: VortexTheme.neonViolet, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(ticket.timeAgo, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: VortexTheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Domain: ${ticket.domain}', style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 12)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.description,
                      style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (ticket.status == TicketStatus.open)
                          ElevatedButton.icon(
                            onPressed: () => _claimTicket(ticket),
                            icon: const Icon(LucideIcons.userCheck, size: 14),
                            label: const Text('CLAIM TICKET'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VortexTheme.neonCyan,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        if (ticket.status == TicketStatus.claimed) ...[
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.arrowRightLeft, size: 14),
                            label: const Text('REASSIGN MENTOR'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: VortexTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _resolveTicket(ticket),
                            icon: const Icon(LucideIcons.check, size: 14),
                            label: const Text('MARK RESOLVED'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VortexTheme.telemetryGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                          ),
                        ],
                      ],
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
