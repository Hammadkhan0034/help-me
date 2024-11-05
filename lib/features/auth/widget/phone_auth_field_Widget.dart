import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneAuthFieldWidget extends StatelessWidget {
  final ValueChanged<PhoneNumber>? onChanged;
  const PhoneAuthFieldWidget({
    super.key,

    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      keyboardType: TextInputType.phone,
      pickerDialogStyle: PickerDialogStyle(
          backgroundColor: AColors.primary,
          countryNameStyle: const TextStyle(color: Colors.white),
          searchFieldCursorColor: Colors.white,
          countryCodeStyle: const TextStyle(color: Colors.white)),
      dropdownTextStyle:
      const TextStyle(fontSize: 18, color: Colors.white),
      style: const TextStyle(fontSize: 18, color: Colors.white),
      decoration: const InputDecoration(
        helperStyle: TextStyle(fontSize: 14, color: Color(0xffF4F4F9)),
        fillColor:AColors.darkGrey, //Color(0xffF4F4F9),
        focusColor: Color(0xffF4F4F9),
        suffixIconColor: Color(0xffF4F4F9),
        iconColor: Color(0xffF4F4F9),
        errorStyle: TextStyle(color: Colors.white),
        filled: true,
        hintText: 'Phone Number',
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color:AColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AColors.darkGrey),
        ),
      ),
      initialCountryCode: 'PK',
      onChanged: onChanged,
      validator: (value) {
        if ( value == null || value.completeNumber== value.countryCode) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }
}
