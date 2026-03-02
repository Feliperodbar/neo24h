import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../shared/models/incident.dart';
import '../../shared/widgets/incident_type_card.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tipos de ocorrência')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: IncidentType.values.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final type = IncidentType.values[index];
            return IncidentTypeCard(
              type: type,
              onTap: () => context.goNamed(
                AppRoute.confirm,
                pathParameters: {'incidentType': type.id},
              ),
            );
          },
        ),
      ),
    );
  }
}
