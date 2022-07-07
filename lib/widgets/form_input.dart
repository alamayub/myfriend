import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final String hint;
  final bool obscure;
  final Widget prefixIcon;
  const FormInput(
      {Key? key,
      required this.controller,
      required this.textInputType,
      this.textCapitalization = TextCapitalization.none,
      required this.hint,
      this.obscure = false,
      this.prefixIcon = const SizedBox()})
      : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscure,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          hintText: widget.hint,
          isDense: true,
          filled: true,
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30)))),
    );
  }
}
