import 'package:alarm_app/servies/get_services_key.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
class SendNotificationService {
  static Future<void> sendNotificationUsingApi({
    required List<String> fcmList,
    required String? title,
    required String? body,
    required Map<String, dynamic>? data,

  }) async
  {
    try {
      String serverKey = await GetServicesKey().getServerToken();
      String url = "https://fcm.googleapis.com/v1/projects/helpme-bf036/messages:send";
      var headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      };
      for (String fcmToken in fcmList) {
        Map<String, dynamic> message = {
          "message": {
            "token": fcmToken,
            "notification": {
              "title": title,
              "body": body,
            },
            "android": {
              "notification": {
                "sound": "raw_alarm"
              }
            },
            "apns": {
              "payload": {
                "aps": {
                  "sound": "raw_alarm.wav"
                }
              }
            },
            "data": data,
          }
        };

        try {
          final http.Response response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(message),
          );
          if (response.statusCode == 200) {
            log('Notification sent successfully to $fcmToken: ${response.body}');
          } else {
            log('Failed to send notification to $fcmToken. Status code: ${response.statusCode}. Response: ${response.body}');
          }
        } catch (e) {
          log('Error sending notification to $fcmToken: $e');
        }
      }
    } catch (e) {
      log('Error in sendNotificationUsingApi: $e');
    }}}