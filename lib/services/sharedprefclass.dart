import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefClass {
  static const String hourlynotificationKey = "hourly_notification_enabled";

  Future<void> setHourlyNotification(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(hourlynotificationKey, value);
  }

  Future<bool> getHourlyNotification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(hourlynotificationKey) ?? false;
  }
}
