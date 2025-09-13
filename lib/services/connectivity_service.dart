import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkService {
  NetworkService._();
  static final NetworkService instance = NetworkService._();

  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    try {
      final lookup = await InternetAddress.lookup('supabase.io');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Stream<bool> get onConnectionChange =>
      _connectivity.onConnectivityChanged.asyncMap((result) async {
        if (result == ConnectivityResult.none) return false;
        return await hasConnection();
      });
}

final connectivityProvider = StreamProvider<bool>((ref) {
  return NetworkService.instance.onConnectionChange;
});
