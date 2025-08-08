import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/profile_model.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _isLoggedInKey = 'IS_LOGGED_IN';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProfileModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return ProfileModel.fromJson(jsonMap);
    }
    return null;
  }

  @override
  Future<void> cacheUser(ProfileModel user) async {
    final jsonString = json.encode(user.toJson());
    await sharedPreferences.setString(_cachedUserKey, jsonString);
    await sharedPreferences.setBool(_isLoggedInKey, true);
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(_cachedUserKey);
    await sharedPreferences.setBool(_isLoggedInKey, false);
  }

  @override
  Future<String?> getAccessToken() async {
    return sharedPreferences.getString(_accessTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await sharedPreferences.setString(_accessTokenKey, token);
  }

  @override
  Future<void> clearAccessToken() async {
    await sharedPreferences.remove(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await sharedPreferences.setString(_refreshTokenKey, token);
  }

  @override
  Future<void> clearRefreshToken() async {
    await sharedPreferences.remove(_refreshTokenKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<void> clearAllData() async {
    await Future.wait([
      clearCachedUser(),
      clearAccessToken(),
      clearRefreshToken(),
    ]);
  }
}

