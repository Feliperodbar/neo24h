import 'package:flutter/material.dart';

enum IncidentType {
  fioCaido,
  transformadorEmChamas,
  explosaoCurto,
  arvoreSobreRede,
  posteDanificado,
  faltaEnergiaRua,
  outro,
}

extension IncidentTypeX on IncidentType {
  String get id {
    switch (this) {
      case IncidentType.fioCaido:
        return 'fio-caido';
      case IncidentType.transformadorEmChamas:
        return 'transformador-em-chamas';
      case IncidentType.explosaoCurto:
        return 'explosao-curto-circuito';
      case IncidentType.arvoreSobreRede:
        return 'arvore-sobre-a-rede';
      case IncidentType.posteDanificado:
        return 'poste-danificado';
      case IncidentType.faltaEnergiaRua:
        return 'falta-de-energia-na-rua';
      case IncidentType.outro:
        return 'outro-incidente';
    }
  }

  String get label {
    switch (this) {
      case IncidentType.fioCaido:
        return 'Fio caído';
      case IncidentType.transformadorEmChamas:
        return 'Transformador em chamas';
      case IncidentType.explosaoCurto:
        return 'Explosão / Curto-circuito';
      case IncidentType.arvoreSobreRede:
        return 'Árvore sobre a rede';
      case IncidentType.posteDanificado:
        return 'Poste danificado';
      case IncidentType.faltaEnergiaRua:
        return 'Falta de energia na rua';
      case IncidentType.outro:
        return 'Outro incidente';
    }
  }

  IconData get icon {
    switch (this) {
      case IncidentType.fioCaido:
        return Icons.cable;
      case IncidentType.transformadorEmChamas:
        return Icons.local_fire_department;
      case IncidentType.explosaoCurto:
        return Icons.bolt;
      case IncidentType.arvoreSobreRede:
        return Icons.park;
      case IncidentType.posteDanificado:
        return Icons.construction;
      case IncidentType.faltaEnergiaRua:
        return Icons.power_off;
      case IncidentType.outro:
        return Icons.report_problem;
    }
  }

  static IncidentType fromId(String id) {
    return IncidentType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => IncidentType.outro,
    );
  }
}
