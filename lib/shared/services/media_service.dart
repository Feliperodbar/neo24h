import 'package:image_picker/image_picker.dart';

class MediaResult {
  const MediaResult.success(this.filePath) : errorMessage = null;

  const MediaResult.cancelled()
      : filePath = null,
        errorMessage = null;

  const MediaResult.failure(this.errorMessage) : filePath = null;

  final String? filePath;
  final String? errorMessage;

  bool get isSuccess => filePath != null;
  bool get isCancelled => filePath == null && errorMessage == null;
}

class MediaService {
  MediaService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<MediaResult> pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 80);

      if (file == null) {
        return const MediaResult.cancelled();
      }

      return MediaResult.success(file.path);
    } catch (_) {
      return const MediaResult.failure(
        'Não foi possível anexar a foto. Verifique permissões de câmera/galeria.',
      );
    }
  }
}
