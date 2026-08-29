import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hackathon_event.dart';
import '../../teams/models/team_model.dart';
import '../../coupons/models/food_coupon.dart';
import '../../scanner/models/scan_log.dart';
import '../../auth/providers/auth_provider.dart';
import '../../participant/providers/participant_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firebase_service.dart';

class EventTeamState {
  final List<HackathonEvent> events;
  final String? selectedEventId;
  final List<TeamModel> allTeams;
  final List<FoodCoupon> userCoupons;
  final List<ScanLog> scanLogs;

  EventTeamState({
    required this.events,
    this.selectedEventId,
    required this.allTeams,
    required this.userCoupons,
    required this.scanLogs,
  });

  HackathonEvent? get activeEvent {
    if (selectedEventId == null) {
      return events.firstWhere((e) => e.isRegistered, orElse: () => events.first);
    }
    return events.firstWhere((e) => e.id == selectedEventId, orElse: () => events.first);
  }

  TeamModel? get myTeam {
    final active = activeEvent;
    if (active == null || active.registeredTeamId == null) return null;
    try {
      return allTeams.firstWhere((t) => t.id == active.registeredTeamId);
    } catch (_) {
      return null;
    }
  }

  EventTeamState copyWith({
    List<HackathonEvent>? events,
    String? selectedEventId,
    List<TeamModel>? allTeams,
    List<FoodCoupon>? userCoupons,
    List<ScanLog>? scanLogs,
  }) {
    return EventTeamState(
      events: events ?? this.events,
      selectedEventId: selectedEventId ?? this.selectedEventId,
      allTeams: allTeams ?? this.allTeams,
      userCoupons: userCoupons ?? this.userCoupons,
      scanLogs: scanLogs ?? this.scanLogs,
    );
  }
}

final eventTeamProvider = StateNotifierProvider<EventTeamNotifier, EventTeamState>((ref) {
  return EventTeamNotifier(ref);
});

class EventTeamNotifier extends StateNotifier<EventTeamState> {
  final Ref ref;
  static const String _teamsPrefsKey = 'vortex_saved_teams';

  EventTeamNotifier(this.ref)
      : super(
          EventTeamState(
            selectedEventId: 'EVT-SPRINT',
            events: [
              HackathonEvent(
                id: 'EVT-SPRINT',
                title: 'Sprint to build',
                tagline: 'A 24-Hour Hackathon',
                bannerIcon: '⏱️',
                date: 'Soon',
                venue: 'Main Arena',
                minTeamSize: 1,
                maxTeamSize: 4,
                tracks: ['General'],
                availableCoupons: [],
                isRegistered: false,
              ),
            ],
            allTeams: [], userCoupons: [], scanLogs: [],
          ),
        ) {
    _loadTeams();
    ref.listen(authProvider, (previous, next) {
      if (previous?.uid != next.uid) {
        refreshUserTeamStatus();
      }
    });
  }

  Future<void> _loadTeams() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final teamsJsonStr = prefs.getString(_teamsPrefsKey);
      List<TeamModel> loadedTeams = [];

      // 1. Load from local cache for immediate display
      if (teamsJsonStr != null) {
        final List<dynamic> decodedList = jsonDecode(teamsJsonStr);
        loadedTeams = decodedList.map((e) => TeamModel.fromJson(e)).toList();
        state = state.copyWith(allTeams: loadedTeams);
        _updateActiveEventRegistration(loadedTeams);
      }

      // 2. Sync from Firestore if initialized
      if (FirebaseService.isInitialized) {
        debugPrint('[Firestore Sync] Fetching teams from Firestore collection "teams"...');
        final snapshot = await FirebaseFirestore.instance.collection('teams').get();
        if (snapshot.docs.isNotEmpty) {
          loadedTeams = snapshot.docs.map((doc) => TeamModel.fromJson(doc.data())).toList();
          state = state.copyWith(allTeams: loadedTeams);
          _updateActiveEventRegistration(loadedTeams);
          
          // Update local cache with fresh data
          final encodedList = loadedTeams.map((t) => t.toJson()).toList();
          await prefs.setString(_teamsPrefsKey, jsonEncode(encodedList));
          debugPrint('[Firestore Sync] Loaded ${loadedTeams.length} teams from Firestore.');
        } else {
          debugPrint('[Firestore Sync] "teams" collection is currently empty on Firestore.');
        }
      } else {
        debugPrint('[Firestore Sync] Firebase is not initialized. Using local cache only.');
      }
    } catch (e) {
      debugPrint('[Firestore Sync Error] Error loading teams: $e');
    }
  }

  void _updateActiveEventRegistration(List<TeamModel> loadedTeams) {
    final auth = ref.read(authProvider);
    if (auth.uid != null) {
      try {
        final userTeam = loadedTeams.firstWhere(
          (t) => t.members.any((m) => m.id == auth.uid)
        );
        state = state.copyWith(
          events: state.events.map((e) {
            if (e.id == userTeam.eventId) {
              return e.copyWith(isRegistered: true, registeredTeamId: userTeam.id);
            }
            return e;
          }).toList(),
        );
      } catch (_) {}
    }
  }

  Future<void> _saveTeams() async {
    try {
      // 1. Save to local cache
      final prefs = await SharedPreferences.getInstance();
      final encodedList = state.allTeams.map((t) => t.toJson()).toList();
      await prefs.setString(_teamsPrefsKey, jsonEncode(encodedList));

      // 2. Sync to Firestore if initialized
      if (FirebaseService.isInitialized) {
        if (state.allTeams.isEmpty) {
          debugPrint('[Firestore Sync] No teams to save to Firestore.');
          return;
        }
        debugPrint('[Firestore Sync] Saving ${state.allTeams.length} teams to Firestore...');
        final batch = FirebaseFirestore.instance.batch();
        for (var team in state.allTeams) {
          final docRef = FirebaseFirestore.instance.collection('teams').doc(team.id);
          batch.set(docRef, team.toJson(), SetOptions(merge: true));
        }
        await batch.commit();
        debugPrint('[Firestore Sync] Successfully committed ${state.allTeams.length} teams to Firestore!');
      } else {
        debugPrint('[Firestore Sync] Firebase not initialized. Saved to local storage only.');
      }
    } catch (e) {
      debugPrint('[Firestore Sync Error] Error saving teams to Firestore: $e');
    }
  }

  void refreshUserTeamStatus() {
    final auth = ref.read(authProvider);
    final uid = auth.uid;

    if (uid == null) {
      // Clear registration status if logged out
      state = state.copyWith(
        events: state.events.map((e) => e.copyWith(isRegistered: false, registeredTeamId: null)).toList(),
      );
      return;
    }

    // If logged in, find if they are in a team
    try {
      final userTeam = state.allTeams.firstWhere(
        (t) => t.members.any((m) => m.id == uid),
      );
      state = state.copyWith(
        events: state.events.map((e) {
          if (e.id == userTeam.eventId) {
            return e.copyWith(isRegistered: true, registeredTeamId: userTeam.id);
          }
          return e.copyWith(isRegistered: false, registeredTeamId: null);
        }).toList(),
      );
    } catch (_) {
      // Not in any team
      state = state.copyWith(
        events: state.events.map((e) => e.copyWith(isRegistered: false, registeredTeamId: null)).toList(),
      );
    }
  }

  void selectEvent(String eventId) {
    state = state.copyWith(selectedEventId: eventId);
  }

  void registerForEvent(String eventId) {
    state = state.copyWith(
      events: state.events.map((e) {
        if (e.id == eventId) {
          return e.copyWith(isRegistered: true);
        }
        return e;
      }).toList(),
      selectedEventId: eventId,
    );
  }

  void createTeam({
    required String eventId,
    required String teamName,
    required String track,
    required int maxCapacity,
    required List<String> requiredSkills,
  }) {
    final auth = ref.read(authProvider);
    final profile = ref.read(participantProfileProvider);
    final newTeamId = 'TEAM-${DateTime.now().millisecondsSinceEpoch % 10000}';
    final leader = TeamMember(
      id: auth.uid ?? 'usr-current',
      name: (profile.name.isNotEmpty && profile.name != 'Hacker')
          ? profile.name
          : (auth.displayName ?? 'Team Leader'),
      role: 'Team Lead',
      email: auth.email ?? '${(auth.displayName ?? "leader").toLowerCase()}@vortex.os',
      avatar: profile.avatar.isNotEmpty ? profile.avatar : '⚡',
      isLeader: true,
      isCheckedIn: true,
    );

    final newTeam = TeamModel(
      id: newTeamId,
      eventId: eventId,
      name: teamName,
      track: track,
      tableNumber: 'Table TBD',
      maxCapacity: maxCapacity,
      members: [leader],
      status: TeamStatus.recruiting,
      requiredSkills: requiredSkills,
    );

    state = state.copyWith(
      allTeams: [...state.allTeams, newTeam],
      events: state.events.map((e) {
        if (e.id == eventId) {
          return e.copyWith(registeredTeamId: newTeamId, isRegistered: true);
        }
        return e;
      }).toList(),
    );
    _saveTeams();
  }

  void requestToJoinTeam(String teamId) {
    final auth = ref.read(authProvider);
    final profile = ref.read(participantProfileProvider);
    
    final request = JoinRequest(
      userId: auth.uid ?? 'usr-current',
      name: auth.displayName ?? profile.name,
      handle: profile.handle,
      avatar: profile.avatar,
    );

    final updatedTeams = state.allTeams.map((team) {
      if (team.id == teamId) {
        if (team.isFull || team.joinRequests.any((r) => r.userId == request.userId)) {
          return team;
        }
        final updatedRequests = [...team.joinRequests, request];
        return team.copyWith(joinRequests: updatedRequests);
      }
      return team;
    }).toList();

    state = state.copyWith(allTeams: updatedTeams);
    _saveTeams();
  }

  void acceptJoinRequest(String teamId, String userId) {
    final updatedTeams = state.allTeams.map((team) {
      if (team.id == teamId) {
        final request = team.joinRequests.firstWhere((r) => r.userId == userId);
        final remainingRequests = team.joinRequests.where((r) => r.userId != userId).toList();
        
        if (team.isFull) return team.copyWith(joinRequests: remainingRequests);
        
        final newMember = TeamMember(
          id: request.userId,
          name: request.name,
          role: 'Core Contributor',
          email: '${request.handle.replaceAll('@', '')}@vortex.os',
          avatar: request.avatar,
          isCheckedIn: true,
        );

        final updatedMembers = [...team.members, newMember];
        final isNowFull = updatedMembers.length >= team.maxCapacity;

        return team.copyWith(
          members: updatedMembers,
          joinRequests: remainingRequests,
          status: isNowFull ? TeamStatus.approved : TeamStatus.recruiting,
          approvedAt: isNowFull ? 'Auto-Approved (Full)' : null,
          tableNumber: isNowFull ? 'Table A-08' : team.tableNumber,
        );
      }
      return team;
    }).toList();

    state = state.copyWith(allTeams: updatedTeams);
    
    // Check if the current user just joined a team
    final auth = ref.read(authProvider);
    if (auth.uid == userId && state.activeEvent != null) {
      state = state.copyWith(
        events: state.events.map((e) {
          if (e.id == state.selectedEventId) {
            return e.copyWith(registeredTeamId: teamId, isRegistered: true);
          }
          return e;
        }).toList(),
      );
    }
    
    _saveTeams();
  }

  void declineJoinRequest(String teamId, String userId) {
    final updatedTeams = state.allTeams.map((team) {
      if (team.id == teamId) {
        final remainingRequests = team.joinRequests.where((r) => r.userId != userId).toList();
        return team.copyWith(joinRequests: remainingRequests);
      }
      return team;
    }).toList();

    state = state.copyWith(allTeams: updatedTeams);
    _saveTeams();
  }

  void toggleSeekingMembers(String teamId) {
    state = state.copyWith(
      allTeams: state.allTeams.map((t) {
        if (t.id == teamId) {
          final updatedSeeking = !t.isSeekingMembers;
          return t.copyWith(isSeekingMembers: updatedSeeking);
        }
        return t;
      }).toList(),
    );
    _saveTeams();
  }

  void leaveOrDisbandTeam(String teamId) {
    final auth = ref.read(authProvider);
    final uid = auth.uid;

    final updatedTeams = <TeamModel>[];
    for (var team in state.allTeams) {
      if (team.id == teamId) {
        final isLeader = team.members.any((m) => m.id == uid && m.isLeader);
        if (isLeader) {
          // Disband whole team if leader leaves
          continue;
        } else {
          // Remove single member
          final remaining = team.members.where((m) => m.id != uid).toList();
          updatedTeams.add(team.copyWith(members: remaining));
        }
      } else {
        updatedTeams.add(team);
      }
    }

    state = state.copyWith(
      allTeams: updatedTeams,
      events: state.events.map((e) {
        if (e.registeredTeamId == teamId) {
          return e.copyWith(isRegistered: false, registeredTeamId: null);
        }
        return e;
      }).toList(),
    );
    _saveTeams();
  }

  void approveTeamByOrganizer(String teamId, String assignedTable) {
    state = state.copyWith(
      allTeams: state.allTeams.map((t) {
        if (t.id == teamId) {
          return t.copyWith(
            status: TeamStatus.approved,
            tableNumber: assignedTable,
            approvedAt: 'Approved just now',
          );
        }
        return t;
      }).toList(),
    );
    _saveTeams();
  }

  void submitTeamScore(String teamId, double innovation, double technical, double uiux, double pitch) {
    state = state.copyWith(
      allTeams: state.allTeams.map((t) {
        if (t.id == teamId) {
          return t.copyWith(
            innovationScore: innovation,
            technicalScore: technical,
            uiuxScore: uiux,
            pitchScore: pitch,
          );
        }
        return t;
      }).toList(),
    );
    _saveTeams();
  }

  Future<ScanLog> recordScan({
    required String scanType,
    required String targetName,
    required String detail,
    required String venueZone,
    String? couponId,
  }) async {
    double lat = 12.9716;
    double lng = 77.5946;

    try {
      final hasPermission = await Geolocator.checkPermission();
      if (hasPermission == LocationPermission.always || hasPermission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 3));
        lat = pos.latitude;
        lng = pos.longitude;
      }
    } catch (_) {
      // Fallback to venue coordinates
    }

    final log = ScanLog(
      id: 'LOG-${DateTime.now().millisecondsSinceEpoch % 10000}',
      scanType: scanType,
      targetName: targetName,
      detail: detail,
      timestamp: DateTime.now(),
      latitude: lat,
      longitude: lng,
      venueZone: venueZone,
      isSuccess: true,
    );

    if (couponId != null) {
      state = state.copyWith(
        userCoupons: state.userCoupons.map((c) {
          if (c.id == couponId) {
            c.isRedeemed = true;
            c.redeemedAt = 'Just now';
            c.redeemedLocation = venueZone;
            c.latitude = lat;
            c.longitude = lng;
          }
          return c;
        }).toList(),
      );
    }

    state = state.copyWith(scanLogs: [log, ...state.scanLogs]);
    return log;
  }
}

