import 'dart:convert';

import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/model/response_jadwal_sholat.dart';
import 'package:my_quran/model/response_kota.dart';
import 'package:my_quran/model/responses_juz.dart';
import 'package:my_quran/model/response_surat.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'model_kota.dart';

class API {
  static String BASE_API_EQURAN = "https://equran.id/api/v2/";
  static String BASE_POINT_SURAT = BASE_API_EQURAN + "surat";
  static String BASE_API_DOA = "https://doa-doa-api-ahmadramadhan.fly.dev/";
  static String BASE_POINT_DOA = BASE_API_DOA + "api";
  static String BASE_API_JADWAL_SHOLAT = "https://api.banghasan.com/";
  static String BASE_API_POINT_KOTA =
      BASE_API_JADWAL_SHOLAT + "sholat/format/json/kota";
  static String BASE_POINT_DETAIL_SURAT = BASE_API_EQURAN + "surat/";
  static String BASE_POINT_JADWAL_SHOLAT =
      BASE_API_JADWAL_SHOLAT + "sholat/format/json/jadwal/kota/";
}

class ControllerAPI extends ChangeNotifier {
  int selectionSurat = 0;
  String? namaKota;
  ModelKota? modelKota;

  void setNamaKota(String? nama, String kodeKota) {
    modelKota = ModelKota(kodeKota.toInt(), nama.toString());

    notifyListeners();
  }

  ModelKota? get getNamaKota => modelKota;
  int get getPilihSurat => selectionSurat;

  String namaSuratDiPilih = "";
  void setSelectionSurat(int select) {
    selectionSurat = select;
    notifyListeners();
    print("Surat Berhasil Dipilih");
  }

  void setNamaSuratDiPilih(String namaSurat) {
    namaSuratDiPilih = namaSurat;
    notifyListeners();
    print("Surat Berhasil Di Set");
  }

  String get getNamaSurat => namaSuratDiPilih;
  late Future<ResponseKota> Kota;
  static Future<ResponseKota> fetchDataKota() async {
    Uri uri = Uri.parse(API.BASE_API_POINT_KOTA);

    var responseResult = await http.get(uri);

    return ResponseKota.fromJson(jsonDecode(responseResult.body));
  }

  static Future<ResponseJadwalSholat> fetchDataJadwalSholat(
      {String? kota = "703", String? tanggal = "2023-04-23"}) async {
    Uri uri = Uri.parse(API.BASE_POINT_JADWAL_SHOLAT +
        kota.toString() +
        "/tanggal/" +
        tanggal.toString());
    var responseResult = await http.get(uri);

    return ResponseJadwalSholat.fromJson(jsonDecode(responseResult.body));
  }

  late Future<Juz> listJuz;
  static Future<Juz> fetchDataJuz() async {
    Uri uri = Uri.parse(API.BASE_POINT_SURAT);
    var responseResut = await http.get(uri);
    return Juz.fromJson(jsonDecode(responseResut.body));
  }

  static Future<DetailSurat> fetchDataDetailSurat({String? noSurat}) async {
    Uri uri = Uri.parse(API.BASE_POINT_DETAIL_SURAT + noSurat.toString());
    var responseResult = await http.get(uri);
    return DetailSurat.fromJson(jsonDecode(responseResult.body));
  }

  static Future<List<Doa>> fetchDataDoa() async {
    Uri uri = Uri.parse(API.BASE_POINT_DOA);
    var responseResult = await http.get(uri);

    print(jsonDecode(responseResult.body));
    List<dynamic> jsonResponse = jsonDecode(responseResult.body);
    return jsonResponse.map((data) => Doa.fromJson(data)).toList();
  }

  static getListDoa() {}
}
