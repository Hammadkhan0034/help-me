import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneAuthFieldWidget extends StatelessWidget {
  final ValueChanged<PhoneNumber>? onChanged;
  const PhoneAuthFieldWidget({super.key, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: onChanged,
      selectorConfig: const SelectorConfig(
        showFlags: false,
        trailingSpace: false,

        setSelectorButtonAsPrefixIcon: true,
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        // backgroundColor: AColors.primary,
      ),
      ignoreBlank: true,
      onSubmit: () {
        FocusScope.of(context).unfocus();
      },
      onSaved: (v) {
        FocusScope.of(context).unfocus();
      },
      initialValue: PhoneNumber(isoCode: 'MY'),
      formatInput: true,
      selectorTextStyle: TextStyle(color: Colors.white),
      textStyle: TextStyle(color: Colors.white),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.phone,
      inputDecoration: const InputDecoration(
          fillColor: AColors.darkGrey,
          filled: true,
          hintText: 'Phone Number',
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          errorStyle: TextStyle(color: Colors.white)),
      inputBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }
}
