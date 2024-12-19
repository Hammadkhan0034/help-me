import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyAndEula extends StatelessWidget {
  final String privacyPolicyUrl ="https://hammadkhan0034.github.io/privacy-policy.github.io/";
  final String eulaUrl="https://www.apple.com/legal/internet-services/itunes/dev/stdeula/";

  const PrivacyPolicyAndEula({
    super.key,
  });

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          RichText(

            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(
                  text: "By using this app, you agree to our ",
                  style:  TextStyle(color: Colors.white),

                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchUrl(privacyPolicyUrl),
                ),
                const TextSpan(
                  text: " and ",
                  style:  TextStyle(color: Colors.white),

                ),
                TextSpan(
                  text: "Terms of Use",
                  style: const TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _launchUrl(eulaUrl),
                ),
                const TextSpan(
                  text: ".",
                  style:  TextStyle(color: Colors.white),

                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
