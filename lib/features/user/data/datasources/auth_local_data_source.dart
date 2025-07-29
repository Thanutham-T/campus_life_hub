import '../models/profile_model.dart';

abstract class AuthLocalDataSource {
  Future<ProfileModel?> getCachedUser();
  
  Future<void> cacheUser(ProfileModel user);
  
  Future<void> clearCachedUser();
  
  Future<String?> getAccessToken();
  
  Future<void> saveAccessToken(String token);
  
  Future<void> clearAccessToken();
  
  Future<String?> getRefreshToken();
  
  Future<void> saveRefreshToken(String token);
  
  Future<void> clearRefreshToken();
  
  Future<bool> isLoggedIn();
  
  Future<void> clearAllData();
}
