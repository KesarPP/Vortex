import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/vortex_theme.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/participant_provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _skillInputController = TextEditingController();
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _tableController;
  late TextEditingController _teamController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(participantProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
    _tableController = TextEditingController(text: profile.tableNumber);
    _teamController = TextEditingController(text: profile.teamName);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(participantProfileProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HACKER PROFILE',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: VortexTheme.neonCyan,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your identity, skills, and event credentials',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: VortexTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(_isEditing ? LucideIcons.check : LucideIcons.edit3, color: VortexTheme.neonCyan),
                tooltip: _isEditing ? 'Save Profile' : 'Edit Profile',
                onPressed: () {
                  if (_isEditing) {
                    ref.read(participantProfileProvider.notifier).updateProfile(
                          name: _nameController.text.trim(),
                          bio: _bioController.text.trim(),
                          tableNumber: _tableController.text.trim(),
                          teamName: _teamController.text.trim(),
                        );
                  }
                  setState(() => _isEditing = !_isEditing);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Profile Card
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [VortexTheme.neonCyan, VortexTheme.neonViolet],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: VortexTheme.neonCyan.withOpacity(0.3),
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Text(profile.avatar, style: const TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isEditing)
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(color: VortexTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                              decoration: const InputDecoration(isDense: true, labelText: 'Name'),
                            )
                          else
                            Text(
                              profile.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: VortexTheme.textPrimary,
                                  ),
                            ),
                          Text(profile.handle, style: const TextStyle(color: VortexTheme.neonCyan, fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: VortexTheme.neonViolet.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(profile.teamName, style: const TextStyle(color: VortexTheme.neonViolet, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: VortexTheme.telemetryGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(profile.tableNumber, style: const TextStyle(color: VortexTheme.telemetryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white10),
                const SizedBox(height: 12),
                if (_isEditing)
                  TextField(
                    controller: _bioController,
                    maxLines: 2,
                    style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 13),
                    decoration: const InputDecoration(labelText: 'Bio & Focus Area', border: OutlineInputBorder()),
                  )
                else
                  Text(
                    profile.bio,
                    style: const TextStyle(color: VortexTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Venue Wi-Fi Quick Connect Card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: VortexTheme.neonCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.wifi, color: VortexTheme.neonCyan, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('VENUE WI-FI CREDENTIALS', style: TextStyle(color: VortexTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('SSID: Vortex-Gigabit-5G  |  Pass: cyberhack2026', style: TextStyle(color: VortexTheme.textPrimary, fontSize: 13, fontFamily: 'monospace')),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.copy, size: 18, color: VortexTheme.neonCyan),
                  tooltip: 'Copy password',
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: 'cyberhack2026'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wi-Fi Password copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Skills & Vector Tags Management
          Text('MY SKILLSET & VECTOR TAGS',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: VortexTheme.textSecondary,
                    letterSpacing: 1.5,
                  )),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.map((skill) {
                    return Chip(
                      label: Text('#$skill'),
                      backgroundColor: VortexTheme.surface,
                      deleteIcon: const Icon(LucideIcons.x, size: 14, color: VortexTheme.neonCyan),
                      onDeleted: () => ref.read(participantProfileProvider.notifier).removeSkill(skill),
                      labelStyle: const TextStyle(color: VortexTheme.neonCyan, fontSize: 12, fontWeight: FontWeight.bold),
                      side: BorderSide(color: VortexTheme.neonCyan.withOpacity(0.4)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillInputController,
                        style: const TextStyle(color: VortexTheme.textPrimary, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Add new skill tag (e.g. #Go, #Solidity)...',
                          hintStyle: const TextStyle(color: VortexTheme.textSecondary),
                          filled: true,
                          fillColor: VortexTheme.surface,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        final text = _skillInputController.text.replaceAll('#', '').trim();
                        if (text.isNotEmpty) {
                          ref.read(participantProfileProvider.notifier).addSkill(text);
                          _skillInputController.clear();
                        }
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('ADD'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VortexTheme.neonCyan,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Sign Out Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).signOut(),
              icon: const Icon(LucideIcons.logOut, size: 16, color: Colors.redAccent),
              label: const Text('SIGN OUT OF VORTEX', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
