class ResponseJadwalSholat {
  String? status;
  Query? query;
  Jadwal? jadwal;

  ResponseJadwalSholat({this.status, this.query, this.jadwal});

  ResponseJadwalSholat.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    jadwal =
        json['jadwal'] != null ? new Jadwal.fromJson(json['jadwal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    if (this.jadwal != null) {
      data['jadwal'] = this.jadwal!.toJson();
    }
    return data;
  }
}

class Query {
  String? format;
  String? kota;
  String? tanggal;

  Query({this.format, this.kota, this.tanggal});

  Query.fromJson(Map<String, dynamic> json) {
    format = json['format'];
    kota = json['kota'];
    tanggal = json['tanggal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['format'] = this.format;
    data['kota'] = this.kota;
    data['tanggal'] = this.tanggal;
    return data;
  }
}

class Jadwal {
  String? status;
  Data? data;

  Jadwal({this.status, this.data});

  Jadwal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? ashar;
  String? dhuha;
  String? dzuhur;
  String? imsak;
  String? isya;
  String? maghrib;
  String? subuh;
  String? tanggal;
  String? terbit;

  Data(
      {this.ashar,
      this.dhuha,
      this.dzuhur,
      this.imsak,
      this.isya,
      this.maghrib,
      this.subuh,
      this.tanggal,
      this.terbit});

  Data.fromJson(Map<String, dynamic> json) {
    ashar = json['ashar'];
    dhuha = json['dhuha'];
    dzuhur = json['dzuhur'];
    imsak = json['imsak'];
    isya = json['isya'];
    maghrib = json['maghrib'];
    subuh = json['subuh'];
    tanggal = json['tanggal'];
    terbit = json['terbit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ashar'] = this.ashar;
    data['dhuha'] = this.dhuha;
    data['dzuhur'] = this.dzuhur;
    data['imsak'] = this.imsak;
    data['isya'] = this.isya;
    data['maghrib'] = this.maghrib;
    data['subuh'] = this.subuh;
    data['tanggal'] = this.tanggal;
    data['terbit'] = this.terbit;
    return data;
  }
}
