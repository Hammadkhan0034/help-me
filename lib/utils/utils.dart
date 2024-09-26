
import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';






class Utils {




  static String formatPhoneNumber(String number) {
    number = number.replaceAll(" ", "");
    int countryCode = number.length - 10;
    String restOfNumber = number.substring(countryCode);
    return "${number.substring(0, countryCode)} ${restOfNumber.substring(0, 3)} ${restOfNumber.substring(3)}";
  }










  static Future<String> imagePicker(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: imageSource);
    // print("picking file");

    if (xFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: xFile.path,

        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile == null) return xFile.path;
      return croppedFile.path;
    }
    return "";
  }

  static Future<String> imagePickerBottomSheet(BuildContext context) async {
    // print("here");
    String? imagePath = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 170,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String imagePath = await imagePicker(ImageSource.camera);

                      Navigator.of(Get.context!).pop(imagePath);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "CAMERA",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      String imagePath = await imagePicker(ImageSource.gallery);

                      Navigator.of(Get.context!).pop(imagePath);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.image,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "GALLERY",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
    // print(imagePath);
    return imagePath ?? "";
  }

  static Future<bool> askForConfirmation(
      BuildContext context, String action, String title) async {
    bool isConfirmed = false;
    isConfirmed = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AColors.primary,
            title: Text(title, style: const TextStyle(color: Colors.white)),
            content: Text(
              "Are you sure you want to $action?",
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "No",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          );
        });

    return isConfirmed;
  }

  static String getInitials(String name) {
    String init = "";

    final list = name.trim().split(RegExp(" "));
    if (list.length == 1) return list.first[0].toUpperCase();
    for (var item in list) {
      item = item.trim();
      if (item.isNotEmpty) {
        init += item.trim()[0].toUpperCase();
      }
    }
    return init;
  }

  static DateTime convertTo24HourFormat(
      String time12Hour, DateTime selectedDate) {
    String period = time12Hour.substring(time12Hour.length - 2);
    String time = time12Hour.substring(0, time12Hour.length - 3);

    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, hour, minute);
  }

  static Offset getTapPosition(
      TapDownDetails tapDownDetails, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.globalToLocal(tapDownDetails.globalPosition);
    return offset;
  }

  static String getFormattedDate(DateTime? dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime ?? DateTime.now());
  }

  static String getFormattedDateAndTimeFromTimeStamp(DateTime date) {
    var formattedDate = DateFormat('dd.MM.yyyy - HH:mm').format(date);
    return formattedDate;
  }

  static String getFormattedTime(DateTime date) {
    var formattedDate = DateFormat('HH:mm').format(date);
    return formattedDate;
  }

  static String getFormattedDateAndTime(
      DateTime dateTime, TimeOfDay timeOfDay) {
    final formatter = DateFormat('dd.MM.yyyy');
    return "${formatter.format(dateTime)} - ${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }

  static String getUniqueIdFromTwoIds(String id1, String id2) =>
      id1.compareTo(id2) > 0 ? "$id2-$id1" : "$id1-$id2";
}

void myPrintWarning(String text) {
  // print('\x1B[33m$text\x1B[0m');
}

void myPrintSuccess(String text) {
  // print('\x1B[32m$text\x1B[0m');
}

void myPrintError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

String formatDateToDMY(DateTime dateTime) {
  return DateFormat("dd-MM-yyyy").format(dateTime);
}
