import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationResult {
  const LocationResult.success(this.position)
      : errorMessage = null,
        deniedForever = false;

  const LocationResult.failure(this.errorMessage, {this.deniedForever = false}) : position = null;

  final Position? position;
  final String? errorMessage;
  final bool deniedForever;

  bool get isSuccess => position != null;
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult.failure('Ative o GPS do dispositivo para continuar.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return const LocationResult.failure('Precisamos da sua localização para prosseguir.');
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationResult.failure(
        'Permissão de localização negada permanentemente. Habilite nas configurações.',
        deniedForever: true,
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 12));

      return LocationResult.success(position);
    } on TimeoutException {
      return const LocationResult.failure('Não foi possível obter o GPS a tempo. Tente novamente.');
    } catch (_) {
      return const LocationResult.failure('Erro ao obter localização. Verifique sinal e permissões.');
    }
  }
}
