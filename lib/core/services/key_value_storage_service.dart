import 'package:get_it/get_it.dart';

import '../utils/key_value_storage_base.dart';


class KeyValueStorageService {
  /// The name of the first time onboarding access
  static const _isFirstTimeOnboardingAccessKey = 'isFirstTimeOnboardingAccessKey';

  /// The key value storage instance
  final KeyValueStorageBase _keyValueStorage;

  KeyValueStorageService({required KeyValueStorageBase keyValueStorage})
      : _keyValueStorage = keyValueStorage;

  /// Returns whether this is the first time the app is being used
  bool isFirstTimeOnboarding() {
    final firstLoad = _keyValueStorage.getCommon<bool>(_isFirstTimeOnboardingAccessKey);
    if (firstLoad == null) return true;
    return firstLoad;
  }

  /// Sets the first time onboarding to this value.
  void setFirstTimeOnboarding(bool isFirstTime) {
    _keyValueStorage.setCommon<bool>(_isFirstTimeOnboardingAccessKey, isFirstTime);
  }

  /// Clears the first time onboarding flag.
  void clearFirstTimeOnboarding() {
    _keyValueStorage.removeCommon(_isFirstTimeOnboardingAccessKey);
  }

  
}

/// Registers the local storage service
Future<void> registerLocalStorageDI(GetIt sl) async {
  await KeyValueStorageBase.init();

  sl.registerLazySingleton<KeyValueStorageBase>(() => KeyValueStorageBase.instance);

  sl.registerLazySingleton<KeyValueStorageService>(
    () => KeyValueStorageService(keyValueStorage: sl<KeyValueStorageBase>()),
  );
}
