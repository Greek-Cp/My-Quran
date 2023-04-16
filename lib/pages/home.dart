import 'dart:async';
import 'dart:convert';

import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/component/button.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/model/responses_juz.dart';
import 'package:my_quran/pages/baca_surat.dart';
import 'package:my_quran/pages/doa.dart';
import 'package:my_quran/pages/item_list/list_juz.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static String? routeName = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<String> listItem = ["Surat", "Doa"];
  int selectedIndex = 0;
  StreamController<DateTime>? _streamController;
  final GlobalKey<State<Home>> _animationLimiterKey = GlobalKey();
  late AnimationController _controller;

  late Animation<double> _FadeAnimationImageSurat;
  late Animation<Offset> _PositionAnimationImage;

  Timer? _timer;
  late Future<Juz> listJuz;

  @override
  void initState() {
    listJuz = ControllerAPI.fetchDataJuz();
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
      begin: Offset(-1, 0),
      end: Offset(0, 0),
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
      Navigator.push(context,
          PageTransition(child: PageDoa(), type: PageTransitionType.fade));
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
  late ControllerAPI providerSurat;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    providerSurat = Provider.of<ControllerAPI>(context);
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
                  FadeTransition(
                      opacity: _FadeAnimationImageSurat,
                      child: SlideTransition(
                        position: _PositionAnimationImage,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                                child: Image.asset(
                              "assets/ic_halaman_utama.png",
                              fit: BoxFit.cover,
                            ))),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              "Baca Al-Quran Dengan Mudah",
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
                                  "Maghrib 17:33 PM",
                                  colors: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 15),
                        child: FadeTransition(
                          opacity: _FadeAnimationImageSurat,
                          child: SlideTransition(
                            position: _PositionAnimationImage,
                            child: TextComponent.TextTittleJuz("Kategori",
                                colors: Colors.black),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _FadeAnimationImageSurat,
                        child: SlideTransition(
                          position: _PositionAnimationImage,
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
                                                        BorderRadius.circular(
                                                            30),
                                                    side: BorderSide(
                                                        color: selectedIndex ==
                                                                index
                                                            ? ColorApp
                                                                .colorPurpler
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
                                                if (selectedIndex == 1) {
                                                  _animate();
                                                }
                                              }),
                                              if (selectedIndex == 0) {}
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
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<Juz>(
                          future: listJuz,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Data>? listData = snapshot.data!.data;
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
                                          child: FadeInAnimation(
                                              child: GestureDetector(
                                            onTap: () {},
                                            child: cardJuz(
                                              noJuz: listData[index]
                                                  .nomor
                                                  .toString(),
                                              namaJuz: listData[index]
                                                  .nama
                                                  .toString(),
                                              namaLatin: listData[index]
                                                  .namaLatin
                                                  .toString(),
                                              tempatTurun: listData[index]
                                                  .tempatTurun
                                                  .toString(),
                                              jumlahAyat: listData[index]
                                                  .jumlahAyat
                                                  .toString(),
                                            ),
                                          ))));
                                },
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })
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

  Widget cardJuz(
      {String? noJuz,
      String? namaJuz,
      String? tempatTurun,
      String? jumlahAyat,
      String? namaLatin}) {
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
              onTap: () {
                providerSurat.setSelectionSurat(noJuz.toInt());
                providerSurat.setNamaSuratDiPilih(namaLatin.toString());
                Navigator.pushNamed(context, BacaSurat.routeName.toString());
              },
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
                            "${noJuz}",
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
                          "${namaLatin}",
                          colors: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        TextComponent.TextDescriptionJuz(
                          "${tempatTurun} * ${jumlahAyat} AYAT",
                          colors: ColorApp.colorGray,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  TextComponent.TextTittleJuz(
                    "${namaJuz}",
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

class AnimationLimiterState {}
