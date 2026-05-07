import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/core/widgets/app_search_field.dart';
import 'package:worldscope/data/weather/models/weather_model.dart';
import 'package:worldscope/data/weather/utils/wmo_codes.dart';
import 'package:worldscope/features/weather/bloc/weather/weather_bloc.dart';
import 'package:worldscope/features/weather/presentation/widgets/weather_forecast_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<WeatherBloc>().add(const WeatherInitialized());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(BuildContext context, String city) {
    context.read<WeatherBloc>().add(WeatherSearchSubmitted(city));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.lastSearchedCity != null &&
              state.lastSearchedCity!.isNotEmpty &&
              _searchController.text.isEmpty) {
            _searchController.text = state.lastSearchedCity!;
          }

          final weather =
              state is WeatherSuccess ? state.weather : null;
          final city =
              state is WeatherSuccess ? state.city : state.lastSearchedCity;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppSearchField(
                  controller: _searchController,
                  hintText: 'Search a city (e.g. Tunis)',
                  onTap: () {
                    context.read<WeatherBloc>().add(const WeatherSearchFieldTapped());
                  },
                  onChanged: (_) {},
                  onFieldSubmitted: (value) => _submitSearch(context, value),
                ),
                const SizedBox(height: 10),
                if (state.showLastSearchSuggestion &&
                    state.lastSearchedCity != null &&
                    state.lastSearchedCity!.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ActionChip(
                      label: Text('Use last search: ${state.lastSearchedCity}'),
                      onPressed: () {
                        final last = state.lastSearchedCity!;
                        _searchController.text = last;
                        _submitSearch(context, last);
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => _submitSearch(context, _searchController.text),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Search'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildContent(
                    context: context,
                    state: state,
                    weather: weather,
                    city: city,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required WeatherState state,
    required WeatherModel? weather,
    required String? city,
  }) {
    if (state is WeatherLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WeatherFailure) {
      return AppErrorWidget(
        message: state.message,
        onRetry: state.lastSearchedCity == null
            ? null
            : () => _submitSearch(context, state.lastSearchedCity!),
      );
    }

    if (weather == null) {
      return const Center(
        child: Text(
          'Search for a city to see today\'s weather and 7-day forecast.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city ?? 'Selected city',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weather.tempNow.round()}°C',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text('Wind: ${weather.windSpeed.round()} km/h'),
                  const SizedBox(height: 4),
                  Text('Condition: ${wmoLabel(weather.weatherCode)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '7-day forecast',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weather.forecast.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return WeatherForecastCard(day: weather.forecast[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
