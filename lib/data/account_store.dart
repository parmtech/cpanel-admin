import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account_profile.dart';

class AccountStore {
  AccountStore({
    SharedPreferencesAsync? preferences,
    FlutterSecureStorage? secureStorage,
  })  : _preferences = preferences ?? SharedPreferencesAsync(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _profilesKey = 'cpanel_admin_profiles_v1';
  static const _activeProfileKey = 'cpanel_admin_active_profile_v1';
  final SharedPreferencesAsync _preferences;
  final FlutterSecureStorage _secureStorage;

  Future<List<AccountProfile>> loadProfiles() async {
    final raw = await _preferences.getString(_profilesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map(
            (item) => AccountProfile.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    } on Object {
      return const [];
    }
  }

  Future<String?> loadActiveProfileId() =>
      _preferences.getString(_activeProfileKey);

  Future<void> setActiveProfileId(String id) =>
      _preferences.setString(_activeProfileKey, id);

  Future<void> saveProfile(
    AccountProfile profile, {
    String? apiToken,
  }) async {
    if (apiToken != null && apiToken.isNotEmpty) {
      await _secureStorage.write(key: _tokenKey(profile.id), value: apiToken);
    } else if (await _secureStorage.read(key: _tokenKey(profile.id)) == null) {
      throw StateError('An API token is required for this account.');
    }

    final profiles = await loadProfiles();
    final updated = [
      for (final item in profiles)
        if (item.id != profile.id) item,
      profile,
    ];
    await _preferences.setString(
      _profilesKey,
      jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
    if (await loadActiveProfileId() == null) {
      await setActiveProfileId(profile.id);
    }
  }

  Future<String?> loadApiToken(String profileId) =>
      _secureStorage.read(key: _tokenKey(profileId));

  Future<void> deleteProfile(String profileId) async {
    await _secureStorage.delete(key: _tokenKey(profileId));
    final profiles = await loadProfiles();
    final remaining = profiles.where((item) => item.id != profileId).toList();
    await _preferences.setString(
      _profilesKey,
      jsonEncode(remaining.map((item) => item.toJson()).toList()),
    );
    if (await loadActiveProfileId() == profileId) {
      if (remaining.isEmpty) {
        await _preferences.remove(_activeProfileKey);
      } else {
        await setActiveProfileId(remaining.first.id);
      }
    }
  }

  String _tokenKey(String id) => 'cpanel_admin_token_' + id;
}
