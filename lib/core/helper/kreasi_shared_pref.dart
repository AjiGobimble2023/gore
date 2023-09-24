import 'dart:convert';
import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/global.dart';
import '../config/constant.dart';
import '../util/data_formatter.dart';
import '../../features/auth/model/user_model.dart';

/// [KreasiSharedPref] merupakan class yang akan meng-handle semua transaksi
/// Shared Preferences yang di lakukan.
class KreasiSharedPref {
  // Initiate storage;
  SharedPreferences? _prefs;
  // Kumpulan Key---------------------------------------------------------------
  static const _keyPilihanKelas = 'pilihan-kelas-kreasi';
  static const _keyTokenJWT = 'tokenJWT-kreasi';
  static const _keyUser = 'user-kreasi';
  static const _keyDeviceID = 'deviceId-kreasi';

  static final KreasiSharedPref _instance = KreasiSharedPref._internal();

  factory KreasiSharedPref() => _instance;

  KreasiSharedPref._internal();

  /// [simpanDataLokal] menyimpan data JWT dan user.<br><br>
  /// [gTokenJwt] dan [gUser] merupakan value dari global.dart
  Future<void> simpanDataLokal() async {
    await setTokenJWT(gTokenJwt);
    if (gUser != null) {
      await setUserModel(gUser!);
      await setPilihanKelas(
        Constant.kDataSekolahKelas
            .singleWhere((element) => element['id'] == gUser!.idSekolahKelas),
      );
    }
  }

  /// [setDeviceID] menyimpan data token JWT.
  Future<bool> setDeviceID(String deviceID) async {
    _prefs ??= await SharedPreferences.getInstance();

    bool isBerhasil = false;

    String encryptedUUID = DataFormatter.encryptString(deviceID);

    final deviceIdStoredData = _prefs!.getString(_keyDeviceID);

    if (deviceIdStoredData != null) {
      return false;
    }

    await _prefs!
        .setString(_keyDeviceID, encryptedUUID)
        .onError((error, stackTrace) {
      isBerhasil = false;
      if (kDebugMode) {
        logger.log(
            'KREASI_SHARED_PREF: ERROR setDeviceID => $error\nSTACKTRACE:$stackTrace');
      }
      return isBerhasil;
    }).then((value) {
      isBerhasil = true;
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF: setDeviceID selesai');
      }
    });

    return isBerhasil;
  }

  /// [getDeviceID] mengambil data Token JWT dari Persistent Data.
  Future<String?> getDeviceID() async {
    _prefs ??= await SharedPreferences.getInstance();

    final uuid = _prefs!.getString(_keyDeviceID);

    String? deviceID;

    if (uuid != null) {
      deviceID = DataFormatter.decryptString(uuid);
    }

    if (kDebugMode) {
      logger.log('KREASI_SHARED_PREF: getDeviceID($deviceID)');
    }
    return deviceID;
  }

  /// [setPilihanKelas] merupakan fungsi untuk menyimpan pilihan kelas User Tamu.
  Future<void> setPilihanKelas(Map<String, String> pilihan) async {
    _prefs ??= await SharedPreferences.getInstance();

    // String encryptedPilihanKelas =
    //     DataFormatter.encryptString(jsonEncode(pilihan));

    await _prefs!
        .setString(_keyPilihanKelas, jsonEncode(pilihan))
        .onError((error, stackTrace) {
      if (kDebugMode) {
        logger.log(
            'KREASI_SHARED_PREF: ERROR setPilihanKelas => $error\nSTACKTRACE:$stackTrace');
      }
      return false;
    }).then((value) {
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF: setPilihanKelas selesai');
      }
    });
  }

  /// [getPilihanKelas] merupakan fungsi Getter value pilihan kelas dari secure storage.
  Future<Map<String, dynamic>?> getPilihanKelas() async {
    _prefs ??= await SharedPreferences.getInstance();

    final String? encryptedPilihan = _prefs!.getString(_keyPilihanKelas);
    String? pilihanKelas;

    if (encryptedPilihan != null) {
      // pilihanKelas = DataFormatter.decryptString(encryptedPilihan);
      pilihanKelas = encryptedPilihan;
    }
    if (pilihanKelas != null) {
      return json.decode(pilihanKelas) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  /// [setTokenJWT] menyimpan data token JWT.
  Future<void> setTokenJWT(String tokenJwt) async {
    _prefs ??= await SharedPreferences.getInstance();

    String encryptedTokenJWT =
        DataFormatter.encryptString(jsonEncode(tokenJwt));

    await _prefs!
        .setString(_keyTokenJWT, encryptedTokenJWT)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        logger.log(
            'KREASI_SHARED_PREF: ERROR setTokenJWT => $error\nSTACKTRACE:$stackTrace');
      }
      return false;
    }).then((value) {
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF: setTokenJWT selesai');
      }
    });
  }

  /// [getTokenJWT] mengambil data Token JWT dari Persistent Data.
  Future<String?> getTokenJWT() async {
    _prefs ??= await SharedPreferences.getInstance();

    final encryptedToken = _prefs!.getString(_keyTokenJWT);
    String? tokenJWT;

    if (encryptedToken != null) {
      tokenJWT = DataFormatter.decryptString(encryptedToken);
    }
    if (kDebugMode) {
      logger.log('KREASI_SHARED_PREF: getTokenJWT($tokenJWT)');
    }
    return tokenJWT;
  }

  /// [setUserModel] menyimpan data User.
  Future<void> setUserModel(UserModel userModel) async {
    _prefs ??= await SharedPreferences.getInstance();

    String encryptedUser =
        DataFormatter.encryptString(jsonEncode(userModel.toJson()));

    await _prefs!
        .setString(_keyUser, encryptedUser)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        logger.log(
            'KREASI_SHARED_PREF: ERROR setUserModel => $error\nSTACKTRACE:$stackTrace');
      }
      return false;
    }).then((value) async {
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF: setUserModel selesai');
      }
    });
  }

  /// [getUser] mengambil data user dari Persistent Data.
  Future<UserModel?> getUser() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      final encryptedUser = _prefs!.getString(_keyUser);
      String? user;

      if (encryptedUser != null) {
        user = DataFormatter.decryptString(encryptedUser);
      }
      if (user?.isNotEmpty ?? false) {
        gTokenJwt = await getTokenJWT() ?? '';
        print(user!);
        var userModel = UserModel.fromJson(json.decode(user!));
        gUser = userModel;
        gNoRegistrasi = userModel.noRegistrasi;
        if (kDebugMode) {
          logger.log(
              'KREASI_SHARED_PREF-GetUser: Produk Dibeli >> ${userModel.daftarProdukDibeli}');
        }
        return userModel;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF-GetUser: ERROR >> $e');
      }
      return null;
    }
  }

  Future<void> logout() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.remove(_keyTokenJWT);
      await _prefs!.remove(_keyUser);
    } catch (e) {
      if (kDebugMode) {
        logger.log('KREASI_SHARED_PREF-Logout: ERROR >> $e');
      }
    }
  }
}
