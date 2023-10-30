import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e14_client/utils/register_service.dart';
import 'package:provider/provider.dart';

class CredentialsInfo {
  bool? registered;
  String? phoneNumer, token;

  CredentialsInfo({this.registered, this.phoneNumer, this.token}) {
    registered = registered ?? false;
    phoneNumer = phoneNumer ?? "";
    token = token ?? "";
  }

  Map<String, dynamic> exportMap() =>
      {"registered": registered, "phoneNumer": phoneNumer, "token": token};
}

class Credentials extends ChangeNotifier {
  late SharedPreferences prefs;
  late CredentialsInfo info;

  bool initialized = false;

  Credentials() {
    initialize();
  }

  initialize() async {
    prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> readInfo =
        jsonDecode(prefs.getString("credentialsInfo") ?? "{}");

    info = CredentialsInfo(
        registered: readInfo["registered"],
        phoneNumer: readInfo["phoneNumer"],
        token: readInfo["token"]);

    check();

    initialized = true;

    notifyListeners();
  }

  check() async {
    if (info.token == null) return;

    if (!(await checkUser(info.token!))["result"]) {
      info = CredentialsInfo(registered: false, phoneNumer: null, token: null);
      prefs.setString("credentialsInfo", "{}");
      notifyListeners();
    }
  }

  register(String phoneNumber, token) async {
    info.registered = true;
    info.phoneNumer = phoneNumber;
    info.token = token;

    prefs.setString("credentialsInfo", jsonEncode(info.exportMap()));
    notifyListeners();
  }
}

class RegisterRequest extends ChangeNotifier {
  bool sentRegisterRequest = false,
      sentVerifyRequest = false,
      lockPhoneNumber = false;

  sendRegisterRequest(String phoneNumber) async {
    sentRegisterRequest = true;
    notifyListeners();

    var response = await requestRegister(
        "+84${phoneNumber.startsWith("0") ? phoneNumber.substring(1) : phoneNumber}");
    if (response["result"]) {
      lockPhoneNumber = true;
    } else {
      sentRegisterRequest = false;
      Fluttertoast.showToast(msg: response["reason"]);
    }
    notifyListeners();
  }

  sendVerifyRequest(
      BuildContext context, String phoneNumber, String verifyCode) async {
    sentVerifyRequest = true;
    notifyListeners();

    var response = await verifyRequest(
        "+84${phoneNumber.startsWith("0") ? phoneNumber.substring(1) : phoneNumber}",
        verifyCode);
    if (response["result"]) {
      if (!context.mounted) return;
      Provider.of<Credentials>(context, listen: false)
          .register(phoneNumber, response["token"]);
    } else {
      sentRegisterRequest = false;
      Fluttertoast.showToast(msg: response["reason"]);
    }
    notifyListeners();
  }
}
