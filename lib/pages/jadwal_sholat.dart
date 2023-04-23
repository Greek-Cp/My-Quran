import 'dart:async';

import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/model_kota.dart';
import 'package:my_quran/model/response_jadwal_sholat.dart';
import 'package:my_quran/model/response_kota.dart';
import 'package:my_quran/pages/page_pilihkota.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:my_quran/utils/size.dart';
import 'package:provider/provider.dart';

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
  List<JadwalSholatModel> jadwalSholatList = [];

  late Future<ResponseJadwalSholat> responseJadwalSholat;
  @override
  void initState() {
    _streamController = StreamController<Duration>();
    _startTimer();
  }

  void _startTimer() {
    // ambil waktu saat ini
    final now = DateTime.now();

    // buat objek DateTime untuk waktu sholat Maghrib hari ini
    final maghribToday = DateTime(
      now.year,
      now.month,
      now.day,
      _maghribHour,
      _maghribMinute,
    );

    // jika waktu sholat Maghrib hari ini sudah lewat, hitung mundur untuk sholat Maghrib besok
    if (maghribToday.isBefore(now)) {
      maghribToday.add(Duration(days: 1));
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final difference = maghribToday.difference(DateTime.now());
      _streamController.add(difference);
      if (difference.isNegative) {
        _timer.cancel();
      }
    });
  }

  late ModelKota modelKota;
  late String namaKota;
  late String idKota;
  late String tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late String tanggalFromPick;
  late String sholatSaatIni = "";
  DateTime? pickedDate;

  late StreamController<Duration> _streamController;
  late Timer _timer;
  void setWaktuSholat(String? waktuSholata) {
    List<String> parts = waktuSholata!.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
    var now = DateTime.now();
    TimeOfDay waktuSholat = TimeOfDay(hour: hour, minute: minute);
    TimeOfDay waktuSaatIn = TimeOfDay.fromDateTime(now);
  }

  // waktu sholat Maghrib pada contoh ini diatur pada pukul 18:00
  int _maghribHour = 18;
  int _maghribMinute = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final provider = Provider.of<ControllerAPI>(context);
    if (provider.getNamaKota == null) {
      modelKota = ModelKota(512, "Pilih Kota");
    } else {
      modelKota = provider.getNamaKota!;
    }

    namaKota = modelKota.namaKota.toString();
    idKota = modelKota.idKota.toString();
    responseJadwalSholat =
        ControllerAPI.fetchDataJadwalSholat(kota: idKota, tanggal: tanggal);
    return Scaffold(
      backgroundColor: ColorApp.colorBackgroundJadwalSholat,
      body: SingleChildScrollView(
        child: FutureBuilder<ResponseJadwalSholat>(
          future: responseJadwalSholat,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TimeOfDay td = TimeOfDay.fromDateTime(DateTime.now());
              Jadwal? jadwal = snapshot.data?.jadwal;
              String? ashar = jadwal!.data?.ashar;
              String? dhuha = jadwal.data?.dhuha;
              String? dzuhur = jadwal.data?.dzuhur;
              String? imsak = jadwal.data?.imsak;
              String? isya = jadwal.data?.isya;
              String? maghrib = jadwal.data?.maghrib;
              String? subuh = jadwal.data?.subuh;
              String? terbit = jadwal.data?.isya;
              DateTime asharTime = DateTime.parse('2000-01-01 $ashar');
              TimeOfDay asharTimeOfDay = TimeOfDay.fromDateTime(asharTime);

              DateTime dhuhaTime = DateTime.parse('2000-01-01 $dhuha');
              TimeOfDay dhuhaTimeOfDay = TimeOfDay.fromDateTime(dhuhaTime);

              DateTime dzuhurTime = DateTime.parse('2000-01-01 $dzuhur');
              TimeOfDay dzuhurTimeOfDay = TimeOfDay.fromDateTime(dzuhurTime);

              DateTime imsakTime = DateTime.parse('2000-01-01 $imsak');
              TimeOfDay imsakTimeOfDay = TimeOfDay.fromDateTime(imsakTime);

              DateTime isyaTime = DateTime.parse('2000-01-01 $isya');
              TimeOfDay isyaTimeOfDay = TimeOfDay.fromDateTime(isyaTime);

              DateTime maghribTime = DateTime.parse('2000-01-01 $maghrib');
              TimeOfDay maghribTimeOfDay = TimeOfDay.fromDateTime(maghribTime);

              DateTime subuhTime = DateTime.parse('2000-01-01 $subuh');
              TimeOfDay subuhTimeOfDay = TimeOfDay.fromDateTime(subuhTime);

              DateTime terbitTime = DateTime.parse('2000-01-01 $terbit');
              TimeOfDay terbitTimeOfDay = TimeOfDay.fromDateTime(terbitTime);
              // Mengambil waktu saat ini
              DateTime now = DateTime.now();
              TimeOfDay nowTimeOfDay = TimeOfDay.fromDateTime(now);

              if (nowTimeOfDay.hour >= terbitTimeOfDay.hour &&
                  nowTimeOfDay.minute >= terbitTimeOfDay.minute &&
                  nowTimeOfDay.hour < dhuhaTimeOfDay.hour) {
                // Waktu saat ini lebih besar atau sama dengan waktu terbit matahari dan lebih kecil dari waktu dhuha
                print('Waktu Saat Ini: ${nowTimeOfDay.format(context)}');
                print(
                    'Waktu Terbit Matahari: ${terbitTimeOfDay.format(context)}');
                print('Saat Ini Adalah Waktu Dhuha');
                sholatSaatIni = "Dhuha ${terbitTimeOfDay.format(context)}";
              } else if (nowTimeOfDay.hour >= dhuhaTimeOfDay.hour &&
                  nowTimeOfDay.minute >= dhuhaTimeOfDay.minute &&
                  nowTimeOfDay.hour < dzuhurTimeOfDay.hour) {
                // Waktu saat ini lebih besar atau sama dengan waktu dhuha dan lebih kecil dari waktu dzuhur
                print('Waktu Saat Ini: ${nowTimeOfDay.format(context)}');
                print('Waktu Dhuha: ${dhuhaTimeOfDay.format(context)}');
                print('Saat Ini Adalah Waktu Dzuhur');
                sholatSaatIni = "Dzuhur ${dzuhurTimeOfDay.format(context)}";
              } else if (nowTimeOfDay.hour >= dzuhurTimeOfDay.hour &&
                  nowTimeOfDay.minute >= dzuhurTimeOfDay.minute &&
                  nowTimeOfDay.hour < asharTimeOfDay.hour) {
                // Waktu saat ini lebih besar atau sama dengan waktu dzuhur dan lebih kecil dari waktu ashar
                print('Waktu Saat Ini: ${nowTimeOfDay.format(context)}');
                print('Waktu Dzuhur: ${dzuhurTimeOfDay.format(context)}');
                print('Saat Ini Adalah Waktu Ashar');
                sholatSaatIni = "Ashar ${asharTimeOfDay.format(context)}";
              } else if (nowTimeOfDay.hour >= asharTimeOfDay.hour &&
                  nowTimeOfDay.minute >= asharTimeOfDay.minute &&
                  nowTimeOfDay.hour < maghribTimeOfDay.hour) {
                // Waktu saat ini lebih besar atau sama dengan waktu ashar dan lebih kecil dari waktu maghrib
                print('Waktu Saat Ini: ${nowTimeOfDay.format(context)}');
                print('Waktu Ashar: ${asharTimeOfDay.format(context)}');
                print('Saat Ini Adalah Waktu Maghrib');
                sholatSaatIni = "Maghrib ${maghribTimeOfDay.format(context)}";
              } else if (nowTimeOfDay.hour >= maghribTimeOfDay.hour &&
                  nowTimeOfDay.minute >= maghribTimeOfDay.minute &&
                  nowTimeOfDay.hour < isyaTime.hour) {
                sholatSaatIni = "Isya ${isyaTimeOfDay.format(context)}";
              } else {
                sholatSaatIni = "Maghrib 17:52";
              }
              jadwalSholatList = [
                JadwalSholatModel("Imsyak", "assets/ic_cloud_night.png", imsak),
                JadwalSholatModel(
                    "Shubuh", "assets/ic_cloud_shubuh.png", subuh),
                JadwalSholatModel(
                    "Terbit", "assets/ic_cloud_terbit.png", terbit),
                JadwalSholatModel("Dhuha", "assets/ic_cloud_dhuha.png", dhuha),
                JadwalSholatModel(
                    "Dzuhur", "assets/ic_cloud_zuhur.png", dzuhur),
                JadwalSholatModel("Ashr", "assets/ic_cloud_zuhur.png", ashar),
                JadwalSholatModel(
                    "Maghrib", "assets/ic_cloud_zuhur.png", maghrib),
                JadwalSholatModel("Isya", "assets/ic_cloud_zuhur.png", isya)
              ];

              return Column(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextComponent.TextTittleJuz("Jadwal Sholat",
                                    colors: Colors.white),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        PagePilihKota.routeName.toString());
                                  },
                                  child: TextComponent.TextDescription(namaKota,
                                      colors: Colors.white),
                                ),
                                StreamBuilder<Duration>(
                                    stream: _streamController.stream,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      final duration = snapshot.data!;
                                      final hours = duration.inHours;
                                      final minutes =
                                          duration.inMinutes.remainder(60);
                                      final seconds =
                                          duration.inSeconds.remainder(60);
                                      return Text(
                                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      );
                                    })
                              ],
                            ),
                            Icon(Icons.notifications_active,
                                color: Colors.white, size: 40)
                          ],
                        ),
                      )
                    ],
                  ),
                  TextComponent.TextTittle("$sholatSaatIni",
                      colors: Colors.white),
                  TextDescription(
                    "Yang membedakan antara orang beriman dengan tidak beriman adalah meninggalkan salat.",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
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
                                TextDescription("$tanggal",
                                    colors: Colors.black),
                                IconButton(
                                    onPressed: () async {
                                      pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              DateTime.now(), //get today's date
                                          firstDate: DateTime(
                                              2000), //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime(2101));

                                      setState(() {
                                        tanggal = DateFormat('yyyy-MM-dd').format(
                                            pickedDate!); // format date in required form here we use yyyy-MM-dd that means time is removed
                                      });
                                    },
                                    icon: Icon(Icons.keyboard_arrow_right)),
                              ]),
                        ))),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print("img : " +
                          jadwalSholatList[index].alamatFile.toString());
                      return widgetJadwalSholat(jadwalSholatList[index]);
                    },
                    itemCount: jadwalSholatList.length,
                  )
                ],
              );
            } else {
              return Text(snapshot.data.toString());
            }
          },
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
