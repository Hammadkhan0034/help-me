import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PinField extends StatefulWidget {
  final Function(String) onCompleted;

  const PinField({super.key, required this.onCompleted});

  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> with CodeAutoFill {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode(); // FocusNode for autofocusing

  @override
  void initState() {
    super.initState();
    listenForCode();
    _pinFocusNode.requestFocus(); // Automatically focus on the PIN field
  }

  @override
  void codeUpdated() {
    setState(() {
      _pinController.text = code!; // Automatically populate the pin field
      widget.onCompleted(code!); // Trigger the onCompleted callback
    });
  }

  @override
  void dispose() {
    _pinFocusNode.dispose(); // Dispose of the focus node when the widget is disposed
    cancel(); // Stop listening for OTP when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Theme.of(context).textTheme.headlineLarge,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme;

    return Pinput(
      length: 6,
      controller: _pinController,
      focusNode: _pinFocusNode, // Set the focus node to automatically focus the field
      defaultPinTheme: defaultPinTheme.copyDecorationWith(color: Colors.white30),
      focusedPinTheme: focusedPinTheme.copyDecorationWith(color: Colors.white30),
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      onCompleted: (pin) {
        widget.onCompleted(pin);
      },
    );
  }
}
