import 'package:flutter/material.dart';
import 'package:my_quran/component/text.dart';
import 'package:my_quran/model/controller_response.dart';
import 'package:my_quran/model/response_kota.dart';
import 'package:my_quran/pages/jadwal_sholat.dart';
import 'package:my_quran/utils/colors.dart';
import 'package:provider/provider.dart';

class PagePilihKota extends StatefulWidget {
  static String? routeName = "/PagePilihKota";
  @override
  State<PagePilihKota> createState() => _PagePilihKotaState();
}

class _PagePilihKotaState extends State<PagePilihKota> {
  late Future<ResponseKota> dataKota;
  @override
  void initState() {
    dataKota = ControllerAPI.fetchDataKota();
  }

  late ControllerAPI providerControler;

  Widget kota(String idKota, String namaKota) {
    return Card(
        child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(JadwalSholat.routeName.toString());
        providerControler.setNamaKota(namaKota, idKota);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text("$idKota"),
            ),
            SizedBox(
              width: 30,
            ),
            TextComponent.TextDescription(namaKota, colors: Colors.black),
          ],
        ),
      ),
    ));
  }

  TextEditingController textEditingController = TextEditingController();
  List<Kota> listKotaDicari = [];
  List<Kota>? responseKota = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    providerControler = Provider.of<ControllerAPI>(context);
    return Scaffold(
      backgroundColor: ColorApp.colorBackgroundJadwalSholat,
      body: SingleChildScrollView(
        child: FutureBuilder<ResponseKota>(
          future: dataKota,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              responseKota = snapshot.data!.kota;
              return Padding(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(JadwalSholat.routeName.toString());
                          },
                          icon: Icon(Icons.arrow_left),
                          color: Colors.white,
                          iconSize: 50,
                        ),
                        TextComponent.TextTittle(
                          "Cari Kota",
                          colors: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            listKotaDicari = responseKota!
                                .where((element) =>
                                    element.nama!.contains(value.toString()))
                                .toList();
                          });
                        } else if (value.isEmpty) {
                          listKotaDicari = responseKota!;
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Cari Kota',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return kota(listKotaDicari![index].id.toString(),
                            listKotaDicari![index].nama.toString());
                      },
                      itemCount: listKotaDicari!.length.toInt(),
                    )
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
