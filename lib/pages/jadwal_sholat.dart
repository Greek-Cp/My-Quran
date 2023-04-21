import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:my_quran/utils/size.dart';

class JadwalSholat extends StatefulWidget {
  static String? routeName = "/jadwal_sholat";
  @override
  State<JadwalSholat> createState() => _JadwalSholatState();
}

class JadwalSholatModel {
  String? namaSholat;
  String? alamatFile;
  String? waktuSholat;
  JadwalSholatModel(this.namaSholat, this.alamatFile, this.waktuSholat);
}

class _JadwalSholatState extends State<JadwalSholat> {
  List<JadwalSholatModel> jadwalSholatList = [
    JadwalSholatModel("Imsak", "assets/ic_cloud_night.png", "04:27"),
    JadwalSholatModel("Subuh", "assets/ic_cloud_shubuh.png", "04:37"),
    JadwalSholatModel("Terbit", "assets/ic_cloud_terbit.png", "05:53"),
    JadwalSholatModel("Dhuha", "assets/ic_cloud_dhuha.png", "06:15"),
    JadwalSholatModel("Zuhur", "assets/ic_cloud_zuhur.png", "11:54")
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: ColorApp.colorBackgroundJadwalSholat,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                SizedBox(),
                Image.asset(
                  "assets/ic_halaman_jadwal_sholat.png",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComponent.TextTittleJuz("Jadwal Sholat",
                              colors: Colors.white),
                          TextComponent.TextDescription("Surabaya",
                              colors: Colors.white)
                        ],
                      ),
                      Icon(Icons.notifications_active,
                          color: Colors.white, size: 40)
                    ],
                  ),
                )
              ],
            ),
            TextComponent.TextTittle("Shubuh 4:18 AM", colors: Colors.white),
            TextDescription(
              "Yang membedakan antara orang beriman dengan tidak beriman adalah meninggalkan salat.",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: Expanded(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.keyboard_arrow_left)),
                          TextDescription("20 April 2023",
                              colors: Colors.black),
                          IconButton(
                              onPressed: () => {},
                              icon: Icon(Icons.keyboard_arrow_right)),
                        ]),
                  ))),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("img : " + jadwalSholatList[index].alamatFile.toString());
                return widgetJadwalSholat(jadwalSholatList[index]);
              },
              itemCount: jadwalSholatList.length,
            )
          ],
        ),
      ),
    );
  }

  Widget widgetJadwalSholat(JadwalSholatModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            model.alamatFile.toString(),
            color: Colors.white,
          ),
          TextTittle(model.namaSholat.toString()),
          TextDescription(model.waktuSholat.toString()),
        ],
      ),
    );
  }

  static Widget TextDescription(String name,
      {Color? colors = Colors.white,
      FontWeight? fontWeight = FontWeight.normal}) {
    return Text(
      "$name",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontSize: size.sizeSubTittle - 2,
              fontWeight: fontWeight)),
    );
  }

  static Widget TextTittle(String name,
      {Color? colors = Colors.white,
      FontWeight? fontWeight = FontWeight.bold}) {
    return Text(
      "$name",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: TextStyle(
              color: colors,
              fontSize: size.sizeSubTittle,
              fontWeight: fontWeight)),
    );
  }
}
