import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/group_controller.dart';

class DoorModeWidget extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;

  DoorModeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final GroupController dropdownController =
      Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Obx(
        () => ListTile(
          title: Text(
            label,
            style: const TextStyle(color: AColors.white),
          ),
          trailing: DropdownButton<String>(
            dropdownColor: AColors.darkGrey,
            icon: const Icon(Icons.arrow_drop_down),
            value: dropdownController.groupType.value,
            items: <String>['Indoor', 'Outdoor'].map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  style: const TextStyle(color: AColors.white),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              dropdownController
                  .updateOption(newValue!); // Update in controller
              onChanged(newValue); // Trigger the callback
            },
          ),
        ),
      ),
    );
  }
}
