
import 'package:shared_preferences/shared_preferences.dart';

class CashService {
  static const _isOpenKey = "cash_open";
  static const _initialKey = "cash_initial";

  static Future<void> openCash(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOpenKey, true);
    await prefs.setDouble(_initialKey, amount);
  }

  static Future<void> closeCash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOpenKey, false);
    await prefs.remove(_initialKey);
  }

  static Future<bool> isOpen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOpenKey) ?? false;
  }

  static Future<double> getInitialAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_initialKey) ?? 0;
  }
  
  static Future<String> generateFolio() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final dateKey = "${now.year}${now.month}${now.day}";
    final lastDate = prefs.getString("folio_date");

    int counter = 1;

    if (lastDate == dateKey) {
      counter = (prefs.getInt("folio_counter") ?? 0) + 1;
    }

    await prefs.setString("folio_date", dateKey);
    await prefs.setInt("folio_counter", counter);

    return "${now.year.toString().substring(2)}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}-"
        "${counter.toString().padLeft(3, '0')}";
  }
}