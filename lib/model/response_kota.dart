class ResponseKota {
  String? status;
  Query? query;
  List<Kota>? kota;

  ResponseKota({this.status, this.query, this.kota});

  ResponseKota.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    query = json['query'] != null ? new Query.fromJson(json['query']) : null;
    if (json['kota'] != null) {
      kota = <Kota>[];
      json['kota'].forEach((v) {
        kota!.add(new Kota.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.query != null) {
      data['query'] = this.query!.toJson();
    }
    if (this.kota != null) {
      data['kota'] = this.kota!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Query {
  String? format;

  Query({this.format});

  Query.fromJson(Map<String, dynamic> json) {
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['format'] = this.format;
    return data;
  }
}

class Kota {
  String? id;
  String? nama;

  Kota({this.id, this.nama});

  Kota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    return data;
  }
}
