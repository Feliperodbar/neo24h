import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/services/location_service.dart';
import '../../shared/services/media_service.dart';

final confirmControllerProvider = AutoDisposeNotifierProvider<ConfirmController, ConfirmState>(
  ConfirmController.new,
);

class ConfirmState {
  const ConfirmState({
    this.latitude,
    this.longitude,
    this.locationError,
    this.photoPath,
    this.loadingLocation = false,
    this.sending = false,
  });

  final double? latitude;
  final double? longitude;
  final String? locationError;
  final String? photoPath;
  final bool loadingLocation;
  final bool sending;

  ConfirmState copyWith({
    double? latitude,
    double? longitude,
    String? locationError,
    String? photoPath,
    bool? loadingLocation,
    bool? sending,
    bool clearLocationError = false,
    bool clearPhotoPath = false,
  }) {
    return ConfirmState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationError: clearLocationError ? null : (locationError ?? this.locationError),
      photoPath: clearPhotoPath ? null : (photoPath ?? this.photoPath),
      loadingLocation: loadingLocation ?? this.loadingLocation,
      sending: sending ?? this.sending,
    );
  }
}

class ConfirmController extends AutoDisposeNotifier<ConfirmState> {
  final LocationService _locationService = LocationService();
  final MediaService _mediaService = MediaService();

  @override
  ConfirmState build() => const ConfirmState();

  Future<void> fetchLocation() async {
    state = state.copyWith(loadingLocation: true, clearLocationError: true);

    final result = await _locationService.getCurrentLocation();

    if (result.isSuccess) {
      state = state.copyWith(
        latitude: result.position!.latitude,
        longitude: result.position!.longitude,
        loadingLocation: false,
        clearLocationError: true,
      );
      return;
    }

    state = state.copyWith(
      locationError: result.errorMessage,
      loadingLocation: false,
    );
  }

  Future<MediaResult> attachPhoto(ImageSource source) async {
    final result = await _mediaService.pickImage(source);

    if (result.isSuccess) {
      state = state.copyWith(photoPath: result.filePath);
    }

    return result;
  }

  Future<String> submitIncident() async {
    state = state.copyWith(sending: true);
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(sending: false);
    return _buildProtocol();
  }

  String _buildProtocol() {
    final now = DateTime.now();
    final date =
        '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final time =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    return 'INC-$date-$time';
  }
}
