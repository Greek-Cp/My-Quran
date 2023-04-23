import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_surat.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:my_quran/utils/size.dart';
import 'package:provider/provider.dart';

class BacaSurat extends StatefulWidget {
  static String? routeName = "/baca_surat";
  @override
  State<BacaSurat> createState() => _BacaSuratState();
}

class _BacaSuratState extends State<BacaSurat> with TickerProviderStateMixin {
  late Future<DetailSurat> detailSurat;
  String? nomorSurat;

  late AudioPlayer audioPlayer;

  @override
  void initState() {
    detailSurat =
        ControllerAPI.fetchDataDetailSurat(noSurat: nomorSurat.toString());
  }

  late ControllerAPI controllerAPI;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    audioPlayer = AudioPlayer();
    controllerAPI = Provider.of<ControllerAPI>(context);
    String namaSurat = controllerAPI.getNamaSurat;
    nomorSurat = controllerAPI.getPilihSurat.toString();
    detailSurat =
        ControllerAPI.fetchDataDetailSurat(noSurat: nomorSurat.toString());
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        shadowColor: ColorApp.colorPurpler,
        snap: false,
        floating: true,
        stretch: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: ColorApp.colorPurpler,
        pinned: true,
        expandedHeight: 180,
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextComponent.TextTittleJuz("Surat ${namaSurat}",
                colors: Colors.white),
          ),
          titlePadding: EdgeInsetsDirectional.only(start: 50.0, bottom: 20.0),
          collapseMode: CollapseMode.parallax,
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTittleJuzPembuka(
                  "ِبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيْم",
                ),
                TextDescriptionAyat("bismillāhir-raḥmānir-raḥīm(i)",
                    colors: Colors.black),
                TextDescriptionArti(
                    "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang",
                    colors: Colors.grey),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DetailSurat>(
                        future: detailSurat,
                        builder: (context, snapshot) {
                          DetailSurat? detailSurat = snapshot.data;
                          if (snapshot.hasData) {
                            List<Ayat>? listAyat = detailSurat!.data!.ayat;
                            listAyat!.removeAt(0);
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: detailSurat!.data!.ayat!.length,
                              itemBuilder: (context, index) {
                                return WidgetSurat(
                                    nomorAyat: index.toString(),
                                    arti: listAyat![index].teksIndonesia,
                                    ayat: listAyat![index].teksArab,
                                    latin: listAyat![index].teksLatin,
                                    urlSuaraBacaan:
                                        listAyat![index].audio!.s01.toString());
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        })
                  ])),
        ]),
      )
    ]));
  }

  static Widget TextTittleJuz(String name,
      {Color? colors = ColorApp.colorPurpler,
      FontWeight? fontWeight = FontWeight.normal,
      double size = 10}) {
    return Text(
      "${name}",
      textAlign: TextAlign.end,
      style: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              color: colors, fontWeight: fontWeight, fontSize: size + 17)),
    );
  }

  static Widget TextTittleJuzPembuka(String name,
      {Color? colors = ColorApp.colorPurpler,
      FontWeight? fontWeight = FontWeight.bold,
      double size = 18}) {
    return Center(
      child: Text(
        "${name}",
        style: GoogleFonts.ibmPlexSansArabic(
            textStyle: TextStyle(
                color: colors, fontWeight: fontWeight, fontSize: size + 10)),
      ),
    );
  }

  static Widget TextDescriptionAyat(
    String name, {
    Color? colors = ColorApp.colorPurpler,
    FontWeight? fontWeight = FontWeight.bold,
  }) {
    return Text(
      "${name}",
      style: GoogleFonts.notoSansArabic(
          textStyle: TextStyle(
              color: colors,
              fontWeight: FontWeight.normal,
              fontSize: size.sizeTittleJuz)),
    );
  }

  static Widget TextDescriptionArti(String name,
      {Color? colors = ColorApp.colorPurpler,
      FontWeight? fontWeight = FontWeight.bold,
      FontStyle fontStyle = FontStyle.italic}) {
    return Text(
      "${name}",
      style: GoogleFonts.ibmPlexSansArabic(
          textStyle: TextStyle(
              color: colors,
              fontWeight: FontWeight.normal,
              fontSize: size.sizeTittleJuz,
              fontStyle: FontStyle.italic)),
    );
  }

  late Source audioUrl;
  Widget WidgetSurat(
      {String? nomorAyat,
      String? ayat,
      String? latin,
      String? arti,
      String? urlSuaraBacaan}) {
    bool isPlay = false;
    late AnimationController animationControllerPlayButton;
    animationControllerPlayButton =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Color.fromARGB(235, 249, 245, 253),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorApp.colorPurpler,
                    child: TextComponent.TextDescription(
                        "${int.parse(nomorAyat.toString()) + 1}",
                        colors: Colors.white),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                    ),
                    onPressed: () {},
                    color: ColorApp.colorPurpler,
                  ),
                  GestureDetector(
                    key: ValueKey(nomorAyat),
                    onTap: () async {
                      if (isPlay == false) {
                        isPlay = true;
                        audioUrl = UrlSource(urlSuaraBacaan.toString());
                        audioPlayer.play(audioUrl);
                        animationControllerPlayButton.forward();
                        audioPlayer.onPlayerComplete.listen((event) {
                          audioPlayer.stop();
                          animationControllerPlayButton.reverse();
                        });
                        audioPlayer.onPlayerStateChanged.listen((event) {
                          if (event == PlayerState.stopped) {
                            animationControllerPlayButton.reverse();
                          } else if (event == PlayerState.paused) {
                            animationControllerPlayButton.reverse();
                          }
                        });
                      } else if (isPlay == true) {
                        isPlay = false;
                        audioPlayer.pause();
                        animationControllerPlayButton.reverse();
                      }
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animationControllerPlayButton,
                      color: ColorApp.colorPurpler,
                    ),
                  ),
                  Icon(Icons.bookmark_outline, color: ColorApp.colorPurpler)
                ],
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Align(
              alignment: Alignment.centerRight,
              child: TextTittleJuz(
                "${ayat}",
                colors: Colors.black,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Align(
              alignment: Alignment.topLeft,
              child: TextComponent.TextDescriptionJuz("${latin}",
                  colors: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 20),
          child: Container(
            child: Align(
                alignment: Alignment.topLeft,
                child: TextComponent.TextDescriptionJuz("${arti}",
                    fontStyle: FontStyle.italic, colors: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
