import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionStore {
  Future<int> readCompletedSessions();

  Future<void> writeCompletedSessions(int count);
}

class SharedPreferencesSessionStore implements SessionStore {
  SharedPreferencesSessionStore(this._preferences);

  static const _completedSessionsKey = 'completed_focus_sessions';
  final SharedPreferences _preferences;

  @override
  Future<int> readCompletedSessions() async {
    return _preferences.getInt(_completedSessionsKey) ?? 0;
  }

  @override
  Future<void> writeCompletedSessions(int count) async {
    await _preferences.setInt(_completedSessionsKey, count);
  }
}

class MemorySessionStore implements SessionStore {
  MemorySessionStore([this.count = 0]);

  int count;

  @override
  Future<int> readCompletedSessions() async => count;

  @override
  Future<void> writeCompletedSessions(int count) async {
    this.count = count;
  }
}
