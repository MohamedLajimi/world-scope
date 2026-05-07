import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:worldscope/core/di/service_locator.dart';
import 'package:worldscope/features/countries/data/models/country_summary_model.dart';
import 'package:worldscope/features/countries/presentation/bloc/country_detail/country_detail_bloc.dart';
import 'package:worldscope/features/countries/presentation/bloc/country_list/country_list_bloc.dart';
import 'package:worldscope/features/countries/presentation/screens/country_detail_screen.dart';
import 'package:worldscope/features/countries/presentation/screens/country_list_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.countries.path,
    routes: <RouteBase>[
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
      GoRoute(
        path: AppRoutes.countryDetails.path,
        name: AppRoutes.countryDetails.name,
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

  static const countryDetails = AppRoute(
    name: 'countryDetails',
    path: '/country-details',
  );
}
