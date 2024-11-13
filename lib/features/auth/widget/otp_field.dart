import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PinField extends StatefulWidget {
  // final Function(String) onCompleted;
  final TextEditingController pinController ;

  const PinField({super.key,  required this.pinController});

  @override
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> with CodeAutoFill {
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    listenForCode();
    _pinFocusNode.requestFocus();
  }

  @override
  void codeUpdated() {
    setState(() {
      widget.pinController.text = code!;
      // widget.onCompleted(code!);
    });
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
    cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
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
      controller: widget.pinController,
      focusNode: _pinFocusNode,
      defaultPinTheme:
          defaultPinTheme.copyDecorationWith(color: Colors.white30),
      focusedPinTheme:
          focusedPinTheme.copyDecorationWith(color: Colors.white30),
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      // onCompleted: (pin) {
      //   widget.onCompleted(pin);
      // },
    );
  }
}
