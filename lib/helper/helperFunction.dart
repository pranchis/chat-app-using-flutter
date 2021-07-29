import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferencesUser ="ISLOGGEDIN";
  static String userNameKey = "USERNAMEKEY";
  static String userEmail = "USEREMAILKEY";
  

  static Future<bool> saveUser(bool isUserLoggedIn) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(sharedPreferencesUser, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userNameKey, userName);
  }

   static Future<bool> saveUserEmailPrefence(String email) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(userEmail, email);
  }

   static Future<bool> getUser() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.getBool(sharedPreferencesUser);
  }

  static Future<String> getName() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.getString(userNameKey);
  }

  static Future<String> getEmail() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.getString(userEmail);
  }


  
}