import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';

class MentorTicketModal extends StatefulWidget {
  const MentorTicketModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MentorTicketModal(),
    );
  }

  @override
  State<MentorTicketModal> createState() => _MentorTicketModalState();
}

class _MentorTicketModalState extends State<MentorTicketModal> {
  final _tableController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedDomain = 'AI/ML & LLM API';

  final List<String> _domains = [
    'AI/ML & LLM API',
    'Backend & Cloud Infra',
    'Flutter & Frontend',
    'Hardware & IoT',
    'Smart Contracts / Web3',
    'Pitch Deck & UI/UX'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: GlassCard(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.lifeBuoy, color: VortexTheme.neonCyan),
                      const SizedBox(width: 10),
                      Text(
                        'DISPATCH MENTOR',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: VortexTheme.textPrimary,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: VortexTheme.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('PROBLEM DOMAIN',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VortexTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _domains.map((domain) {
                  final isSelected = _selectedDomain == domain;
                  return ChoiceChip(
                    label: Text(domain),
                    selected: isSelected,
                    selectedColor: VortexTheme.neonCyan.withOpacity(0.25),
                    backgroundColor: VortexTheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? VortexTheme.neonCyan : VortexTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? VortexTheme.neonCyan : VortexTheme.textSecondary.withOpacity(0.2),
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedDomain = domain);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('TABLE LOCATION',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VortexTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              TextField(
                controller: _tableController,
                style: const TextStyle(color: VortexTheme.textPrimary),
                decoration: InputDecoration(
                  prefixIcon: const Icon(LucideIcons.mapPin, color: VortexTheme.neonViolet),
                  filled: true,
                  fillColor: VortexTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: VortexTheme.neonViolet.withOpacity(0.4)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('BRIEF DESCRIPTION OF BLOCKER',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: VortexTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: VortexTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. Getting CORS error on WebSocket handshake with Ollama endpoint...',
                  hintStyle: const TextStyle(color: VortexTheme.textSecondary),
                  filled: true,
                  fillColor: VortexTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: VortexTheme.textSecondary.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: VortexTheme.surface,
                        content: Row(
                          children: const [
                            Icon(LucideIcons.checkCircle2, color: VortexTheme.telemetryGreen),
                            SizedBox(width: 10),
                            Text('Ticket Dispatched! Mentor queue position: #2'),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.send),
                  label: const Text('SUMMON MENTOR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VortexTheme.neonCyan,
                    foregroundColor: VortexTheme.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
