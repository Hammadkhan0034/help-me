import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/door/controllers/door_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupNameDropDown extends StatelessWidget {
  const GroupNameDropDown({
    super.key,
    required this.ctrl,
  });

  final DoorController ctrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AColors.dark,
          ),
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              const Text(
                "Group Name ",
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                child: Obx(
                  () => DropdownButton(
                    isExpanded: true,
                    focusColor: AColors.dark,
                    value: ctrl.selectedItem.value,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 24,
                    iconEnabledColor: AColors.white,
                    dropdownColor: AColors.dark,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        ctrl.setSelected(newValue);
                      }
                    },
                    items: ctrl.items
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
