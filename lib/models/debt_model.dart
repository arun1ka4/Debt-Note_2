class Debt {
  int? id;
  int userId;
  String nama;
  int jumlah;
  DateTime tanggalHutang;
  DateTime tanggalJatuhTempo;

  Debt({
    this.id,
    required this.userId,
    required this.nama,
    required this.jumlah,
    required this.tanggalHutang,
    required this.tanggalJatuhTempo,
  });

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'],
      userId: json['user_id'],
      nama: json['nama'],
      jumlah: json['jumlah'],
      tanggalHutang: DateTime.parse(json['tanggal_hutang']),
      tanggalJatuhTempo: DateTime.parse(json['tanggal_jatuh_tempo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nama': nama,
      'jumlah': jumlah,
      'tanggal_hutang': tanggalHutang.toIso8601String(),
      'tanggal_jatuh_tempo': tanggalJatuhTempo.toIso8601String(),
    };
  }
}
