import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../models/agenda_item.dart';
import '../providers/participant_provider.dart';

class ScheduleTimelineView extends ConsumerStatefulWidget {
  const ScheduleTimelineView({super.key});

  @override
  ConsumerState<ScheduleTimelineView> createState() => _ScheduleTimelineViewState();
}

class _ScheduleTimelineViewState extends ConsumerState<ScheduleTimelineView> {
  AgendaType? _selectedFilter;
  bool _onlyBookmarked = false;

  Color _getTypeColor(AgendaType type) {
    switch (type) {
      case AgendaType.keynote:
        return VortexTheme.neonCyan;
      case AgendaType.workshop:
        return VortexTheme.neonViolet;
      case AgendaType.meal:
        return Colors.orangeAccent;
      case AgendaType.checkpoint:
        return VortexTheme.telemetryGreen;
      case AgendaType.deadline:
        return Colors.redAccent;
    }
  }

  IconData _getTypeIcon(AgendaType type) {
    switch (type) {
      case AgendaType.keynote:
        return LucideIcons.presentation;
      case AgendaType.workshop:
        return LucideIcons.code;
      case AgendaType.meal:
        return LucideIcons.utensils;
      case AgendaType.checkpoint:
        return LucideIcons.flag;
      case AgendaType.deadline:
        return LucideIcons.alertTriangle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final agendaList = ref.watch(agendaProvider);

    final filtered = agendaList.where((item) {
      if (_onlyBookmarked && !item.isBookmarked) return false;
      if (_selectedFilter != null && item.type != _selectedFilter) return false;
      return true;
    }).toList();

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
                      'EVENT SCHEDULE',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: VortexTheme.neonCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Live synchronized schedule & milestone checkpoints',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _onlyBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _onlyBookmarked ? VortexTheme.neonCyan : VortexTheme.textSecondary,
                ),
                tooltip: 'Show Bookmarked Only',
                onPressed: () => setState(() => _onlyBookmarked = !_onlyBookmarked),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Track Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('All Events'),
                    selected: _selectedFilter == null,
                    selectedColor: VortexTheme.neonCyan.withOpacity(0.25),
                    backgroundColor: VortexTheme.surface,
                    labelStyle: TextStyle(
                      color: _selectedFilter == null ? VortexTheme.neonCyan : VortexTheme.textSecondary,
                      fontWeight: _selectedFilter == null ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (sel) => setState(() => _selectedFilter = null),
                  ),
                ),
                ...AgendaType.values.map((type) {
                  final isSelected = _selectedFilter == type;
                  final color = _getTypeColor(type);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      avatar: Icon(_getTypeIcon(type), size: 14, color: isSelected ? Colors.black : color),
                      label: Text(type.name.toUpperCase()),
                      selected: isSelected,
                      selectedColor: color,
                      backgroundColor: VortexTheme.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : VortexTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (sel) => setState(() => _selectedFilter = sel ? type : null),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timeline Items
          ...filtered.map((item) {
            final color = _getTypeColor(item.type);

            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: GlassCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline marker
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.isLiveNow ? color : VortexTheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: item.isLiveNow ? 2 : 1),
                            boxShadow: item.isLiveNow
                                ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                                : null,
                          ),
                          child: Icon(_getTypeIcon(item.type), size: 16, color: item.isLiveNow ? Colors.black : color),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (item.isLiveNow) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('● LIVE NOW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    '${item.startTime} - ${item.endTime}',
                                    style: TextStyle(
                                      color: item.isLiveNow ? VortexTheme.neonCyan : VortexTheme.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  size: 18,
                                  color: item.isBookmarked ? VortexTheme.neonCyan : VortexTheme.textSecondary.withOpacity(0.5),
                                ),
                                onPressed: () => ref.read(agendaProvider.notifier).toggleBookmark(item.id),
                              ),
                            ],
                          ),
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: item.isCompleted ? VortexTheme.textSecondary : VortexTheme.textPrimary,
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.mapPin, size: 12, color: VortexTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(item.speakerOrLocation, style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
