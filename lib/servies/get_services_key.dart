// import 'package:googleapis_auth/auth_io.dart';
//
// class GetServicesKey {
//   Future<String> getServerToken() async {
//     final scopes = [
//       'https://www.googleapis.come/auth/userinfo.email',
//       'https://www.googleapis.come/auth/firebase.database',
//       'https://www.googleapis.come/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson({
//           "type": "service_account",
//           "project_id": "livingplus-2706f",
//           "private_key_id": "f7274ef5d0a42698ed053a97c7e6358e439a9573",
//           "private_key":
//               "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC21WiOoQa28DqB\nedLJLe3jFPhfhKXiIY/v+shcMIqdZnz7S+5NFzNEVIK59XPQcfjzaykMM5aHKaX+\nXT+7TlDba+z9tf/DAVJIiMxwcqIXB/b9qkV5n4HvBp9vdGbeIzg6NKf7AkuLZcvn\ngKZXdl8k5KynWGJzwME072IrGcbnp1HX+IRPjtEkXY5GIO4laI8ICBOnV2qQ3Rwi\nr3TW+xwWqrC0etbvGBVyesuXUefdKaZJlMzMJooqQDPyvDLIGfXVRudDAsp6Uo6j\nljkng/h8KEdW13/ufB+661/2SaikV5TYL1qlKKwnE19r76XNiwAmTSbyO2IGZHs4\nqYWPhcEhAgMBAAECggEAP+6S36DuDKUnCCRVsTRmxSuNiDUFnnOW9dbvHdF5fv2a\nAXN1Mi7FJgUZKzZpl39rCo8zrMkTP1MwcKghw3jorDlqhvMPqpw5LhTry/xBsqT9\n2IikP5mnoTHjKWF+IPoWzL+h55NPYECp0ts5D0dckLWHrAKrdod15/E3FhQu6cyQ\nZwQTpAfQOO9q9L1nbRMCUdfl4u1QzPp2b4iZL9lTpPZrKRbfUuT+kZf6Vfml0ui4\nF76yOT9cfi+FqWg9kEixl36sdgrO55Za15fD3QbAZxZDGEYwSt0iGA+tS0stzDHG\nVnuTPvF17eHtSGKUQgHi/RcJO2Im31QRdkmMtKuW0wKBgQDeAG9CdiYHRlwVtjKY\nx4U2vkuddpKBNT+t1kNLsnyE54UAlkUyiz9NImcflt1bc59EbvGSR3ujpx3NBhfB\nBbDOunzxzN45WHelcl7ml9RStkuwHQRSK3swEoNC+nCdNJ/059/i4Lk8cjKhKUiQ\nFSilhi23xrFXFm+oW52e0LkUlwKBgQDS1WQ9iqjyQM5WQounFTGN3aHPiysNC8Ao\nJnxFvDxJBHwIYq/1uoZI/Y5kPtWSHrjtGGM69zg0h6iRPaqpTpCQvbK0+A2IbmPo\nOf7MO4F+0ksMJYpzBAUH4rMRDEOPHajziLB1GOWX5VySYJH0DMeHmxFQ7O7GNq+m\nUK7QRbx3BwKBgGr9CqGdDvayke5kwD2g6jJXw1k/q5tZbjb467WvbxMeAJsn0HFr\najZiPhCbRFKuhjMUxJcanBtijpogNZJwi6UVeuGNOguo9wBk/hdjVJAICrH1Sf/P\ntK6WPWwqBdu9YNlGZj+QzbSz1HKW0sGdcNlUsPPAbfbqeSVKAcxoCspBAoGBAMZC\nHG0ywwRrpJzBHwoTh/HcBJliSS2PazdWWW5KQHZ5XRmVk9oDeNuSdCAYZkVt1oA+\nerGsYJIlL4LE9oMXeiJiAHbk+/Tbud9bChuLqY5UunXFp5fYo9Jyf+j8G1utjH7W\nfvjeXKil6pNLdHSGv+rpCzOKWk7ShgJjxL/dlAhpAoGBAJ5r3peUnTmugbIXcpZJ\nItHp6YfdNGo4KoHpbCRAL7v0R18NaXSirnu84+Jgb4+VelLd8UyTdnH4dOyYKRVY\n13D9CmBkEjD939V6E2zdsxQtYD4AxRrTyeiQVPD+AbwEbTkiHtd0l1t9nKf1YM/1\nOyabQ95NHhjBI0DJbEWo35Tm\n-----END PRIVATE KEY-----\n",
//           "client_email":
//               "firebase-adminsdk-dpb2d@livingplus-2706f.iam.gserviceaccount.com",
//           "client_id": "108495612566157711532",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url":
//               "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url":
//               "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-dpb2d%40livingplus-2706f.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }),
//         scopes);
//     final accessServerKey = client.credentials.accessToken.data;
//     return accessServerKey;
//   }
// }
