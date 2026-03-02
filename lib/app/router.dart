import 'package:go_router/go_router.dart';

import '../features/confirm/confirm_page.dart';
import '../features/home/home_page.dart';
import '../features/success/success_page.dart';
import '../features/types/types_page.dart';
import '../shared/models/incident.dart';

class AppRoute {
  static const home = 'home';
  static const types = 'types';
  static const confirm = 'confirm';
  static const success = 'success';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/types',
      name: AppRoute.types,
      builder: (context, state) => const TypesPage(),
    ),
    GoRoute(
      path: '/confirm/:incidentType',
      name: AppRoute.confirm,
      builder: (context, state) {
        final rawType = state.pathParameters['incidentType'] ?? IncidentType.outro.id;
        final incidentType = IncidentTypeX.fromId(rawType);
        return ConfirmPage(incidentType: incidentType);
      },
    ),
    GoRoute(
      path: '/success/:protocol',
      name: AppRoute.success,
      builder: (context, state) {
        final protocol = state.pathParameters['protocol'] ?? '';
        return SuccessPage(protocol: protocol);
      },
    ),
  ],
);
