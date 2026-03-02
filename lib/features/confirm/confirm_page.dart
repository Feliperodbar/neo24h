import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/router.dart';
import '../../shared/models/incident.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/primary_action_button.dart';
import 'confirm_controller.dart';

class ConfirmPage extends ConsumerStatefulWidget {
  const ConfirmPage({super.key, required this.incidentType});

  final IncidentType incidentType;

  @override
  ConsumerState<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends ConsumerState<ConfirmPage> {
  @override
  void initState() {
    super.initState();

    Future<void>.microtask(() async {
      final controller = ref.read(confirmControllerProvider.notifier);
      await controller.fetchLocation();

      if (!mounted) return;
      final state = ref.read(confirmControllerProvider);
      if (state.locationError != null) {
        showErrorSnackBar(context, state.locationError!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(confirmControllerProvider);
    final controller = ref.read(confirmControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(widget.incidentType.icon),
                    title: const Text('Tipo selecionado'),
                    subtitle: Text(widget.incidentType.label),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Localização (GPS)', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        if (state.loadingLocation)
                          const Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: Text('Obtendo sua localização...')),
                            ],
                          )
                        else if (state.latitude != null && state.longitude != null)
                          Text(
                            'Lat: ${state.latitude!.toStringAsFixed(6)}\nLng: ${state.longitude!.toStringAsFixed(6)}',
                          )
                        else
                          Text(state.locationError ?? 'Localização indisponível.'),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await controller.fetchLocation();
                            if (!context.mounted) return;

                            final updated = ref.read(confirmControllerProvider);
                            if (updated.locationError != null) {
                              showErrorSnackBar(context, updated.locationError!);
                            } else {
                              showSuccessSnackBar(context, 'Localização atualizada com sucesso.');
                            }
                          },
                          icon: const Icon(Icons.my_location),
                          label: const Text('Atualizar localização'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Foto (opcional)', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        if (state.photoPath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(state.photoPath!),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          const Text('Nenhuma foto anexada.'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _attachPhoto(
                                context: context,
                                controller: controller,
                                source: ImageSource.camera,
                              ),
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Anexar foto (câmera)'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _attachPhoto(
                                context: context,
                                controller: controller,
                                source: ImageSource.gallery,
                              ),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Anexar foto (galeria)'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryActionButton(
                  label: 'Enviar Ocorrência',
                  icon: Icons.send,
                  isLoading: state.sending,
                  onPressed: () async {
                    if (state.latitude == null || state.longitude == null) {
                      showErrorSnackBar(context, 'Precisamos da sua localização para prosseguir.');
                      return;
                    }

                    final protocol = await controller.submitIncident();

                    if (!context.mounted) return;

                    context.goNamed(
                      AppRoute.success,
                      pathParameters: {'protocol': protocol},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _attachPhoto({
    required BuildContext context,
    required ConfirmController controller,
    required ImageSource source,
  }) async {
    final result = await controller.attachPhoto(source);

    if (!context.mounted) return;

    if (result.isCancelled) {
      showErrorSnackBar(context, 'Seleção de foto cancelada.');
      return;
    }

    if (result.errorMessage != null) {
      showErrorSnackBar(context, result.errorMessage!);
      return;
    }

    showSuccessSnackBar(context, 'Foto anexada com sucesso.');
  }
}
