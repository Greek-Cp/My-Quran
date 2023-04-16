import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_quran/model/response_doa.dart';
import 'package:my_quran/model/responses_juz.dart';
import 'package:my_quran/model/response_surat.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class API {
  static String BASE_API_EQURAN = "https://equran.id/api/v2/";
  static String BASE_POINT_SURAT = BASE_API_EQURAN + "surat";
  static String BASE_API_DOA = "https://doa-doa-api-ahmadramadhan.fly.dev/";
  static String BASE_POINT_DOA = BASE_API_DOA + "api";

  static String BASE_POINT_DETAIL_SURAT = BASE_API_EQURAN + "surat/";
}

class ControllerAPI extends ChangeNotifier {
  int selectionSurat = 0;

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
