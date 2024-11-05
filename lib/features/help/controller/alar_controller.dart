import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AlarmController extends GetxController {
  final AudioPlayer alarmPlayer = AudioPlayer();

  Future<void> playAlarm() async {
    try {
      await alarmPlayer.setAsset('assets/alarm_indoor.mp3');
      await alarmPlayer.setLoopMode(LoopMode.all);
      alarmPlayer.play();
    } catch (e) {
      print("Error playing alarm: $e");
    }
  }

  // Stop the alarm sound
  void stopAlarm() {
    alarmPlayer.stop();
  }
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return
          CupertinoAlertDialog(
            title: (false)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.alarm,
                  size: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    "Alarm"!,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                )
              ],
            )
                : Column(
              children: [
                Text(
                  "Alarm",
                  style: TextStyle(fontSize: 16),
                ),

              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  stopAlarm();
                  Navigator.of(context).pop();
                },
                child: Text("STOP"),
              ),
            ],
          );
          AlertDialog(

          title: Text("ALARM"),
          actions: [
            TextButton(
              onPressed: () {
                 stopAlarm();
                Navigator.of(context).pop();
              },
              child: Text("STOP"),
            ),
          ],
        );
      },
    );
  }
  @override
  void onClose() {
    alarmPlayer.dispose();
    super.onClose();
  }
}