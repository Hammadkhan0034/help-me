import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetServicesKey {
  Future<String> getServerToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
          "private_key_id": dotenv.env['FIREBASE_PRIVATE_KEY_ID'],
          "private_key": dotenv.env['FIREBASE_PRIVATE_KEY']!.replaceAll(r'\n', '\n'),  // Make sure newlines are handled properly
          "client_email": dotenv.env['FIREBASE_CLIENT_EMAIL'],
          "client_id": dotenv.env['FIREBASE_CLIENT_ID'],
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/${dotenv.env['FIREBASE_CLIENT_EMAIL']}"
        }),
        scopes);

    String accessServerKey = client.credentials.accessToken.data;
    print("Server Token :  ${accessServerKey.toString()}");
    return accessServerKey;
  }
}
