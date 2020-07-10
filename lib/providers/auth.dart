import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  //TODO: add your web api key
  final webApiKey = 'ENTER_YOUR_KEY';

  bool get isAuth => token != null;


  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null)
      return _token;
    else
      return null;
  }

  String get userId => _userId;

  Future<void> signUp(String email, String password) async {
    print(email + password);
    try {
      final response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webApiKey',
          body: {
            "email": email,
            "password": password,
            "returnSecureToken": true.toString(),
          });
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    print(email + password);

    try {
      final response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$webApiKey',
          body: {
            "email": email,
            "password": password,
            "returnSecureToken": true.toString(),
          });
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print(_token);
      notifyListeners();


      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }
  Future<bool> tryAutoLogin() async{

    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData'))
      return false;
    final extractedData = json.decode(prefs.getString('userData'))as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']).isAfter(DateTime.now());
    if(!expiryDate)
      return false;
    _token = extractedData['token'];

    _userId = extractedData['userId'];
    _expiryDate = DateTime.parse(extractedData['expiryDate']);
    notifyListeners();
    return true;

  }

  void logOut() async{
    _token = null;
    _expiryDate = null;
    _userId =null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
