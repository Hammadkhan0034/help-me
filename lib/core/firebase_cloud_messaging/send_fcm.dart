// import 'dart:convert';
//
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;
//
// class PushNotificationService {
//   static Future<String> getStaticToken() async {
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "nexcab-23a27",
//       "private_key_id": "66661447f6658aaa902db287851a40fdd3256cc2",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCoCYDnDt1or+2r\n10fWXd7W+B+B96dK6cjoi1LAQWl4cHMTMqiYQ5NOVeh/3bgCdrCrCLBHtZ9IgFuG\nQzwcsvqgLpjk9sjmqLs1sjDFvtph+ZaaDSLNkETP+8fyw3Cp9YwR840QD6dBGeyI\nEED6/Dcuoz8agA0FORno7H1etA3Mwqa4m+hmeM/QTZI4agR3ZxE7foBGy72N8Il5\n5imJrxhO2I2CXPHAVVL2bimf2b4Hu/9THPzQUvz6hsuu/Feh0ZOeStIDYGVA9l/u\n0oEWgNI66QA1MW6A1wWNmq1ssYN7lk+KfOXdcGHqJozDFo+Fx3U6O2+ImW/CVsPl\nbhSlEANRAgMBAAECggEAC4ZzV+W2G+sNIx8l5zcTBK2KA7EHwWSdig2cRGF4KXGV\nAvkThTYFUXck9jgv2cNoRKLY7GIxpZhgLqpH4jQIaponlHS0vNVP2dP58mYvtk6X\nHMPP4keF4LoFMcpj3NRhog2RXEumjhmIFqD+w/gulL1Po7KqsfQDqe0mgCtbUvLe\nS6I8F90c46R8MiXoLejYwAJaSHy56PH55YlUJX2ptOQIZ9MyUMgeQjQFD7QKqfgK\nKkhUcu5mqn+CNKNXJstKF0oRtgDy0PXJbcBSb1TaEDpTZzUO2NHEhxyYCBEMATwH\nay9nWLSRBGnQOJvFQ4F8Gxrc0jVFJ+yBpz0SScmkDQKBgQDiLRhwxh2PHOjrbkX0\nnaGTJKDckymIBcwPT0iLtqrOvRbbYJQeGXQsBowmaZ8sdNBghMnLKVyiRM+nTLQ2\nfjXvN0QEssIodHnfUPGbO9+wLbvnIDevDhWTaJR5mIy8PbvOISHTjrSeURdZDPNV\nLmJx+X8zgaFsnEMdJ0MGn+mM4wKBgQC+Mdcz2QMa12wtrFlZumOrCGTiW7LuMH/k\n+sNWPuUfkGeUo4tPd5Whl/1kN5b7KaH5OkcxPRjGwPtjQDF5dtjQvDfH5nqJ6s64\nHUtx3LhnaigqBfiMe6mBleWA9hUrWPX56P7kgwU/hua61b8c/sqUnkCnCUxznkPb\nYZRi4wo5OwKBgQCqZGjeRRLtx0zeWRRQxhR8wwKBSkjmld92xTcVMoeZ+rBmk2rj\nBjAUHtak9buaBWMa488WxFFqWkbKdinqR8kgL9WJaJaHXcCW8ecjGMdbdgjyhb4N\nnqG4jPgWZ0vXYPbEwwc113PRNaxORUhoquo1jU48InPXXB3fr716Fy0fGwKBgQCR\ncoAGcGDFeBSMYQ77ZWSu+P5ddI7DRGep7nLPU83Yc5AixWbV4LeXGip3J2PYsx/g\n/kZPS0/VPuOAJSkwoEhyaF2oC4OOUPjBJ/X4HzkOLMqGSIaouDEKnl0iYA4UVjXV\nZe73RZMP39Q28Rrzy42UVelPU/cZO+DctiTJ8qJw3QKBgQCK17YPBhh52DdYuMWZ\nHHvG5NXP/tAD/zr6K2INL0Ss/hyGPI8WjxgHgjD4D8IA7oMMQUpE1V50tOyF6IDK\nUNVt5psOlJUwOkLvwH8sGddQyc/SBB+bDyfmOJdQIhdYH5oVGEfyojJG52ZlO0eF\n74snsihUtYVEcOQOgKpd3IIUtw==\n-----END PRIVATE KEY-----\n",
//       "client_email": "nexcab@nexcab-23a27.iam.gserviceaccount.com",
//       "client_id": "117463922012743087412",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/nexcab%40nexcab-23a27.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com"
//     };
//
//     String token = "";
//
//     List<String> scopes = [
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];
//
//     http.Client client = await auth.clientViaServiceAccount(
//         auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
//     auth.AccessCredentials credentials =
//         await auth.obtainAccessCredentialsViaServiceAccount(
//             auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//             scopes,
//             client);
//     client.close();
//     token = credentials.accessToken.data;
//     print(token);
//
//     return token;
//   }
//
//   static sendPushNotification(
//       {required String title,
//       required String description,
//       required String fcmToken}) async {
//     String token = await getStaticToken();
//     String url =
//         "https://fcm.googleapis.com/v1/projects/nexcab-23a27/messages:send";
//     Map<String, dynamic> body = {
//       "message": {
//         "token": fcmToken,
//         "notification": {"body": description, "title": title}
//       }
//     };
//
//     final response = await http
//         .post(Uri.parse(url), body: jsonEncode(body), headers: <String, String>{
//       'Authorization': 'Bearer $token',
//     });
//
//     print(response.body);
//   }
// }
