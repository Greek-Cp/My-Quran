import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/component/button.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/model/responses_juz.dart';
import 'package:my_quran/pages/home.dart';
import 'package:my_quran/pages/item_list/list_juz.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:http/http.dart' as http;

class PageDoa extends StatefulWidget {
  static String? routeName = "/PageDoa";

  @override
  State<PageDoa> createState() => _PageDoaState();
}

class _PageDoaState extends State<PageDoa> with SingleTickerProviderStateMixin {
  List<String> listItem = ["Surat", "Doa"];
  int selectedIndex = 1;
  StreamController<DateTime>? _streamController;
  final GlobalKey<State<PageDoa>> _animationLimiterKey = GlobalKey();
  late AnimationController _controller;

  late Animation<double> _FadeAnimationImageSurat;
  late Animation<Offset> _PositionAnimationImage;
  late Animation<Offset> _PositionKategori;

  Timer? _timer;
  late Future<List<Doa>> listDoa;

  @override
  void initState() {
    listDoa = ControllerAPI.fetchDataDoa();
    super.initState();
    _streamController = StreamController<DateTime>();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _streamController?.add(DateTime.now());
    });
    _controller = AnimationController(
      duration: Duration(milliseconds: 2400),
      vsync: this,
    );

    _FadeAnimationImageSurat =
        Tween<double>(begin: 0, end: 1).animate(_controller);
    _PositionAnimationImage = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _PositionKategori = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    playAnimation();
  }

  void _animate() {
    // Check the status of the AnimationController and start/stop the animation accordingly
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    Future.delayed(Duration(milliseconds: 2400), () {
      Navigator.of(context).popAndPushNamed(Home.routeName.toString());
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    _timer?.cancel();
    super.dispose();
  }

  void playAnimation() {
    _controller.forward();
  }

  void stopAnimation() {
    _controller.stop();
  }

  double horizontalOffset = 50.0;
  int time = 375 + 100;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    left: -30,
                    top: 0,
                    child: FadeTransition(
                        opacity: _FadeAnimationImageSurat,
                        child: SlideTransition(
                          position: _PositionKategori,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Positioned(
                                child: SizedBox(
                                    child: Image.asset(
                                  "assets/ic_halaman_doa.png",
                                  width: 340,
                                  height: 260,
                                  fit: BoxFit.fill,
                                )),
                              )),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                              position: _PositionAnimationImage,
                              child: TextComponent.TextTittle("My Quran")),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                            position: _PositionAnimationImage,
                            child: TextComponent.TextDescription(
                                "Bacaaan Doa Doa",
                                colors: Colors.black),
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: StreamBuilder<DateTime>(
                            stream: _streamController?.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var formattedTime = DateFormat.Hms()
                                    .format(snapshot.data ?? DateTime.now());

                                return SlideTransition(
                                  position: _PositionAnimationImage,
                                  child: TextComponent.TextTittle(
                                      "$formattedTime",
                                      colors: Colors.black),
                                );
                              } else {
                                return Text("Loading..");
                              }
                            },
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                            position: _PositionAnimationImage,
                            child: TextComponent.TextDescription(
                                "Ramadan 23,1444 AH",
                                colors: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                            position: _PositionAnimationImage,
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
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 15, top: 40),
                            child: FadeTransition(
                              opacity: _FadeAnimationImageSurat,
                              child: SlideTransition(
                                position: _PositionKategori,
                                child: TextComponent.TextTittleJuz("Kategori",
                                    colors: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                            position: _PositionAnimationImage,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
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
                                                            BorderRadius
                                                                .circular(30),
                                                        side: BorderSide(
                                                            color:
                                                                selectedIndex ==
                                                                        index
                                                                    ? ColorApp
                                                                        .colorPurpler
                                                                    : Colors
                                                                        .black))),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        selectedIndex == index
                                                            ? ColorApp
                                                                .colorPurpler
                                                            : Colors.white)),
                                            onPressed: () => {
                                                  print(index),
                                                  setState(() {
                                                    selectedIndex = index;
                                                    if (selectedIndex == 0) {
                                                      _animate();
                                                    }
                                                  }),
                                                  if (selectedIndex == 0) {}
                                                },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                listItem[index],
                                                style: TextStyle(
                                                    color:
                                                        selectedIndex == index
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<List<Doa>>(
                            future: listDoa,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Doa>? listData = snapshot.data;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: listData!.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 2375),
                                        child: SlideTransition(
                                            position: _PositionAnimationImage,
                                            child: FadeTransition(
                                                opacity:
                                                    _FadeAnimationImageSurat,
                                                child: cardJuz(
                                                    noDoa: listData[index]
                                                        .id
                                                        .toString(),
                                                    namaDoa: listData[index]
                                                        .doa
                                                        .toString(),
                                                    doaArab:
                                                        listData[index].ayat,
                                                    doaLatin: listData[index]
                                                        .latin))));
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardJuz(
      {String? noDoa, String? namaDoa, String? doaArab, String? doaLatin}) {
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
              child: Column(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 45, top: 15),
                        child: TextComponent.TextTittleJuz(
                          "${namaDoa}",
                          colors: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/ic_juz.png",
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      "${noDoa}",
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
                            Flexible(
                              child: TextComponent.TextDescription("${doaArab}",
                                  colors: ColorApp.colorPurpler),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 45, bottom: 15),
                        child: TextComponent.TextDescriptionJuz(
                          "${doaLatin}",
                          colors: ColorApp.colorGray,
                        ),
                      ),
                    ],
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
