import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../shared/widgets/primary_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: PrimaryActionButton(
                label: 'Reportar Incidente',
                icon: Icons.report,
                onPressed: () => context.goNamed(AppRoute.types),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
