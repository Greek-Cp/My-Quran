import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:my_quran/utils/size.dart';

class PageJuz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 5, color: ColorApp.colorPurpler),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Card(
          elevation: 1.0,
          color: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Stack(
                children: [
                  Image.asset(
                    "assets/ic_juz.png",
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "1",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent.TextTittleJuz(
                      "Al-Fatihah",
                      colors: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    TextComponent.TextDescriptionJuz(
                      "MEKAH * 7 AYAT",
                      colors: ColorApp.colorGray,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              TextComponent.TextTittleJuz(
                "ةحتافلا",
                colors: ColorApp.colorPurpler,
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
