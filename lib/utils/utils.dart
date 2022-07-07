import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

showMessage(String message) {
  return Fluttertoast.showToast(
    msg: message,
    fontSize: 12,
    timeInSecForIosWeb: 1,
    textColor: Colors.black,
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: secondaryColor,
  );
}

roundedSubmitButton(String text, Function function) {
  return MaterialButton(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))),
    elevation: 0,
    minWidth: double.infinity,
    height: 45,
    hoverElevation: 0,
    focusElevation: 0,
    highlightElevation: 0,
    color: primaryColor,
    child: Text(text,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: .5)),
    onPressed: () {
      function();
    },
  );
}

roundedIconButton(IconData iconData, Function function) {
  return MaterialButton(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))),
    elevation: 0,
    minWidth: 44,
    height: 44,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: EdgeInsets.zero,
    hoverElevation: 0,
    focusElevation: 0,
    highlightElevation: 0,
    color: lightColor,
    child: Icon(iconData, size: 20),
    onPressed: () {
      function();
    },
  );
}

formInputBorder() {
  return const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(30)));
}
