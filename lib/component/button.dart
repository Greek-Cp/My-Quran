import 'package:flutter/material.dart';
import 'package:my_quran/utils/colors.dart';

class ButtonComponent {
  static Widget MainButton(String text, Function functionOnPressed) {
    return ElevatedButton(
      onPressed: () {
        functionOnPressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text("Baca Sekarang"),
      ),
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: MaterialStatePropertyAll(ColorApp.colorPurpler)),
    );
  }
}
