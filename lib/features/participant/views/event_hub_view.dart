import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../widgets/mentor_ticket_modal.dart';

class EventHubView extends StatefulWidget {
  const EventHubView({super.key});

  @override
  State<EventHubView> createState() => _EventHubViewState();
}

class _EventHubViewState extends State<EventHubView> {
  int _currentStep = 0;
  final _repoController = TextEditingController();
  final _videoController = TextEditingController();
  final _deckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Live Countdown Banner
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: VortexTheme.neonViolet.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VortexTheme.neonViolet),
                  ),
                  child: const Icon(LucideIcons.timer, color: VortexTheme.neonViolet, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUBMISSION DEADLINE IN',
                        style: TextStyle(
                          color: VortexTheme.textSecondary,
                          letterSpacing: 1.5,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '04 : 32 : 18',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: VortexTheme.neonCyan,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => MentorTicketModal.show(context),
                  icon: const Icon(LucideIcons.lifeBuoy, size: 16),
                  label: const Text('NEED HELP?'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Active Broadcast Announcements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LIVE ANNOUNCEMENTS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: VortexTheme.textSecondary,
                      letterSpacing: 1.5,
                    ),
              ),
              const Icon(LucideIcons.radio, color: VortexTheme.telemetryGreen, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'No active announcements.',
                style: TextStyle(color: VortexTheme.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // 3. Multi-Step Project Submission Form
          Text(
            'PROJECT SUBMISSION',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: VortexTheme.textSecondary,
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stepper(
                  physics: const NeverScrollableScrollPhysics(),
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: VortexTheme.surface,
                          content: Text('🎉 Project Submission Finalized and Locked!'),
                        ),
                      );
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) setState(() => _currentStep--);
                  },
                  steps: [
                    Step(
                      title: const Text('Code Repository', style: TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Public GitHub / GitLab URI', style: TextStyle(color: VortexTheme.textSecondary)),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                      content: TextField(
                        controller: _repoController,
                        style: const TextStyle(color: VortexTheme.neonCyan),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.github, color: VortexTheme.neonCyan),
                          filled: true,
                          fillColor: VortexTheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Demo Video (2 mins max)', style: TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: const Text('YouTube / Loom / Drive link', style: TextStyle(color: VortexTheme.textSecondary)),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                      content: TextField(
                        controller: _videoController,
                        style: const TextStyle(color: VortexTheme.neonViolet),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.video, color: VortexTheme.neonViolet),
                          filled: true,
                          fillColor: VortexTheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Pitch Deck & Architecture PDF', style: TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Pitch deck / Figma link / Google Slides', style: TextStyle(color: VortexTheme.textSecondary)),
                      isActive: _currentStep >= 2,
                      content: TextField(
                        controller: _deckController,
                        style: const TextStyle(color: VortexTheme.telemetryGreen),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.presentation, color: VortexTheme.telemetryGreen),
                          filled: true,
                          fillColor: VortexTheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String priority;
  final String time;
  final String message;
  final Color color;

  const _AnnouncementCard({
    required this.priority,
    required this.time,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
                ),
                child: Text(
                  priority,
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Text(time, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
