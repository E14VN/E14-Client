import 'package:dio/dio.dart';

final dio = Dio();

Future<Map<String, dynamic>> checkUser(String token) async {
  Map<String, dynamic> result = {};

  try {
    result = (await dio.get("https://e14.neursdev.tk/userRegister/check",
            options: Options(
                validateStatus: (_) => true,
                headers: {"Authorization": token},
                sendTimeout: const Duration(seconds: 10))))
        .data;
  } catch (e) {
    print(e);
    result = {"result": false, "reason": "Không thể gửi yêu cầu!"};
  }

  return result;
}

Future<Map<String, dynamic>> requestRegister(String phoneNumber) async {
  Map<String, dynamic> result = {};

  try {
    result = (await dio.post("https://e14.neursdev.tk/userRegister/request",
            data: {"phoneNumber": phoneNumber},
            options: Options(
                validateStatus: (_) => true,
                sendTimeout: const Duration(seconds: 10))))
        .data;
  } catch (e) {
    print(e);
    result = {"result": false, "reason": "Không thể gửi yêu cầu!"};
  }

  return result;
}

Future<Map<String, dynamic>> verifyRequest(
    String phoneNumber, verifyCode) async {
  Map<String, dynamic> result = {};

  try {
    result = (await dio.post("https://e14.neursdev.tk/userRegister/verify",
            data: {"phoneNumber": phoneNumber, "verifyCode": verifyCode},
            options: Options(
                validateStatus: (_) => true,
                sendTimeout: const Duration(seconds: 10))))
        .data;
  } catch (e) {
    print(e);
    result = {"result": false, "reason": "Không thể gửi yêu cầu!"};
  }

  return result;
}
