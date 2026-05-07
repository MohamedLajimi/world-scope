import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:worldscope/core/di/service_locator.dart';
import 'package:worldscope/core/router/app_shell_screen.dart';
import 'package:worldscope/data/countries/models/country_summary_model.dart';
import 'package:worldscope/features/countries/bloc/country_detail/country_detail_bloc.dart';
import 'package:worldscope/features/countries/bloc/country_list/country_list_bloc.dart';
import 'package:worldscope/features/countries/presentation/screens/country_detail_screen.dart';
import 'package:worldscope/features/countries/presentation/screens/country_list_screen.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';
import 'package:worldscope/features/deep_dive/presentation/screens/deep_dive_screen.dart';
import 'package:worldscope/features/weather/presentation/screens/weather_screen.dart';
import 'package:worldscope/features/weather/bloc/weather/weather_bloc.dart';

class AppRouter {
  const AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.countries.path,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.countries.path,
                name: AppRoutes.countries.name,
                builder: (BuildContext context, GoRouterState state) {
                  return BlocProvider(
                    create: (context) => sl<CountryListBloc>(),
                    child: const CountryListScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.weather.path,
                name: AppRoutes.weather.name,
                builder: (BuildContext context, GoRouterState state) {
                  return BlocProvider(
                    create: (context) => sl<WeatherBloc>(),
                    child: const WeatherScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.deepDive.path,
                name: AppRoutes.deepDive.name,
                builder: (BuildContext context, GoRouterState state) {
                  return BlocProvider(
                    create: (context) => sl<DeepDiveBloc>(),
                    child: const DeepDiveScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.countryDetails.path,
        name: AppRoutes.countryDetails.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final country = state.extra as CountrySummaryModel;
          return BlocProvider(
            create: (context) => sl<CountryDetailBloc>(),
            child: CountryDetailScreen(country: country),
          );
        },
      ),
    ],
  );
}

class AppRoute {
  const AppRoute({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

class AppRoutes {
  const AppRoutes._();

  static const countries = AppRoute(
    name: 'countries',
    path: '/countries',
  );
  static const weather = AppRoute(
    name: 'weather',
    path: '/weather',
  );
  static const deepDive = AppRoute(
    name: 'deepDive',
    path: '/deep-dive',
  );

  static const countryDetails = AppRoute(
    name: 'countryDetails',
    path: '/country-details',
  );
}
