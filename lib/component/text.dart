import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:my_quran/utils/size.dart';

class TextComponent {
  static Widget TextTittle(String name,
      {Color? colors = ColorApp.colorPurpler}) {
    return Text(
      "${name}",
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontWeight: FontWeight.bold,
              fontSize: size.sizeTittle)),
    );
  }

  static Widget TextDescription(String name,
      {Color? colors = ColorApp.colorGray,
      FontWeight? fontWeight = FontWeight.normal}) {
    return Text(
      "$name",
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontSize: size.sizeSubTittle,
              fontWeight: fontWeight)),
    );
  }

  static Widget TextTittleJuz(
    String name, {
    Color? colors = ColorApp.colorPurpler,
    FontWeight? fontWeight = FontWeight.bold,
  }) {
    return Text(
      "${name}",
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontWeight: fontWeight,
              fontSize: size.sizeTittleJuz)),
    );
  }

  static Widget TextDescriptionJuz(String name,
      {Color? colors = ColorApp.colorGray,
      FontWeight? fontWeight = FontWeight.normal,
      FontStyle? fontStyle = FontStyle.normal}) {
    return Text(
      "$name",
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontSize: size.sizeDescriptionJuz,
              fontWeight: fontWeight,
              fontStyle: fontStyle)),
    );
  }
}
