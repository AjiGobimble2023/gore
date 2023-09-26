class RankingSatuModel {
  final String noRegistrasi;
  final String namaLengkap;
  final String score;
  final String tipe;
  final String? photoUrl;

  RankingSatuModel({
    required this.noRegistrasi,
    required this.namaLengkap,
    required this.score,
    required this.tipe,
    this.photoUrl,
  });

  factory RankingSatuModel.fromJson(Map<String, dynamic> json) => RankingSatuModel(
      noRegistrasi: json['noregistrasi'],
      namaLengkap: (json['namalengkap'] as String).substring(0, 6),
      score: json['total'],
      tipe: json['tipe'],
      photoUrl:
          'https://firebasestorage.googleapis.com/v0/b/kreasi-f1f7b.appspot.com/o/avatar%2Fg-4.png?alt=media&token=8bfb2b14-2d49-4d7a-9917-a6966c88773a');

  Map<String, dynamic> toJson() => {
        'noregistrasi': noRegistrasi,
        'namalengkap': namaLengkap,
        'total': score,
        'tipe': tipe,
        'url': photoUrl
      };
}

class UndefinedRankingSatu extends RankingSatuModel {
  UndefinedRankingSatu({required String tipe})
      : super(
            noRegistrasi: '-', namaLengkap: '......', score: '...', tipe: tipe);
}
