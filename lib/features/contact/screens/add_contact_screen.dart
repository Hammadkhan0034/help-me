import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          "Add Contacts",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100, width: Get.width),
                  const Text(
                    "App Contacts",
                    style: TextStyle(
                        color: AColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Ahmad "
                          "+013256645",
                      hintStyle: TextStyle(color: AColors.white),
                      suffixIcon: Icon(
                        Icons.add,
                        color: AColors.white,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Added Contacts",
                    style: TextStyle(
                        color: AColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const ATextField(
                    hintText: "Sam "
                        "+013256645",
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Pending",
                          style: TextStyle(
                            color: AColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: "Sam "
                          "+013256645",
                      hintStyle: TextStyle(color: AColors.white),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Pending",
                            style: TextStyle(
                              color: AColors.white,
                            ),
                          ),
                        ],
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: AColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ATextField(
                    hintText: "Ahmad "
                        "+013256645",
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          color: AColors.white,
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.delete,
                          color: AColors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const WarningCircleIcon(),
        ],
      ),
    );
  }
}

class ATextField extends StatelessWidget {
  const ATextField({
    super.key,
    this.hintText,
    this.suffix,
  });

  final String? hintText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Ahmad "
            "+013256645",
        hintStyle: const TextStyle(color: AColors.white),
        suffixIcon: suffix,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AColors.white,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AColors.white,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AColors.white,
          ),
        ),
      ),
    );
  }
}
