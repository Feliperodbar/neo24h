import 'package:flutter/material.dart';

import '../models/incident.dart';

class IncidentTypeCard extends StatelessWidget {
  const IncidentTypeCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final IncidentType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(child: Icon(type.icon)),
        title: Text(type.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
