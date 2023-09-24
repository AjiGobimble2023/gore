import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../entity/tob.dart';

class TobModel extends Tob {
  const TobModel({
    required super.kodeTOB,
    required super.namaTOB,
    required super.jenisTOB,
    required super.tanggalMulai,
    required super.tanggalBerakhir,
    required super.jarakAntarPaket,
    super.isFormatTOMerdeka = false,
    super.isBersyarat = false,
    super.isTeaser = false,
  });

  factory TobModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      logger.log('TOB_MODEL-FromJson: json >> $json');
    }
    return TobModel(
      kodeTOB: json['kode_tob'].toString(),
      namaTOB: json['nama_tob'],
      jenisTOB: json['jenis_tob'] ?? 'TryOut',
      tanggalMulai: json['tanggal_mulai'],
      tanggalBerakhir: json['tanggal_selesai'],
      jarakAntarPaket: json['jarak_antar_paket'] ?? 0,
      isFormatTOMerdeka: json['isKurikulumMerdeka'],
      isBersyarat: json['isbersyarat'] == '1',
      isTeaser: json['jenis'] == 'teaser',
    );
  }
}
