import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/component/button.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/pages/item_list/list_juz.dart';
import 'package:my_quran/utils/colors.dart';

class Home extends StatefulWidget {
  static String? routeName = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> listItem = ["Juz", "Ayat"];
  int selectedIndex = 0;
  StreamController<DateTime>? _streamController;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController<DateTime>();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _streamController?.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  AnimationLimiter(
                    child: AnimationConfiguration.synchronized(
                      duration: Duration(milliseconds: (375 + 100) * 4),
                      child: SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Align(
                                alignment: Alignment.topRight,
                                child: SizedBox(
                                    child: Image.asset(
                                  "assets/ic_halaman_utama.png",
                                  fit: BoxFit.cover,
                                ))),
                          )),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimationLimiter(
                          child: AnimationConfiguration.synchronized(
                              duration: Duration(milliseconds: (375 + 100)),
                              child: SlideAnimation(
                                  horizontalOffset: -50.0,
                                  child:
                                      TextComponent.TextTittle("My Quran")))),
                      AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                          duration: Duration(milliseconds: (375 + 100) * 2),
                          child: SlideAnimation(
                            horizontalOffset: -50.0,
                            child: TextComponent.TextDescription(
                                "Baca Al-Quran Dengan Mudah",
                                colors: Colors.black),
                          ),
                        ),
                      ),
                      AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                          duration: Duration(milliseconds: (375 + 100) * 3),
                          child: SlideAnimation(
                            horizontalOffset: -50.0,
                            child: StreamBuilder<DateTime>(
                              stream: _streamController?.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var formattedTime = DateFormat.Hms()
                                      .format(snapshot.data ?? DateTime.now());

                                  return TextComponent.TextTittle(
                                      "$formattedTime",
                                      colors: Colors.black);
                                } else {
                                  return Text("Loading..");
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                          duration: Duration(milliseconds: (375 + 100) * 4),
                          child: SlideAnimation(
                            horizontalOffset: -50.0,
                            child: TextComponent.TextDescription(
                                "Ramadan 23,1444 AH",
                                colors: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimationLimiter(
                        child: AnimationConfiguration.synchronized(
                          duration: Duration(milliseconds: (375 + 100) * 5),
                          child: SlideAnimation(
                            horizontalOffset: -50.0,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        ColorApp.colorPurpler)),
                                onPressed: () {},
                                child: TextComponent.TextDescription(
                                    "Shubuh 4:17 AM",
                                    colors: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 15),
                        child: TextComponent.TextTittleJuz("Kategori",
                            colors: Colors.black),
                      ),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: listItem.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                side: BorderSide(
                                                    color: selectedIndex ==
                                                            index
                                                        ? ColorApp.colorPurpler
                                                        : Colors.black))),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                selectedIndex == index
                                                    ? ColorApp.colorPurpler
                                                    : Colors.white)),
                                    onPressed: () => {
                                          print(index),
                                          setState(() {
                                            selectedIndex = index;
                                          })
                                        },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        listItem[index],
                                        style: TextStyle(
                                            color: selectedIndex == index
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 100,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 2375),
                                child: SlideAnimation(
                                    horizontalOffset: -550.0,
                                    // delay: Duration(milliseconds: 400),
                                    duration: Duration(milliseconds: 800),
                                    child: FadeInAnimation(child: cardJuz())));
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardJuz() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5, color: ColorApp.colorPurpler),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () {},
              splashColor: ColorApp.colorPurpler,
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
        ),
      ),
    );
  }
}
