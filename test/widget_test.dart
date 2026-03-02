import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neo24h/app/app.dart';

void main() {
  testWidgets('Botão Reportar Incidente existe e navega para a lista', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Neo24hApp()));

    expect(find.text('Reportar Incidente'), findsOneWidget);

    await tester.tap(find.text('Reportar Incidente'));
    await tester.pumpAndSettle();

    expect(find.text('Tipos de ocorrência'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
