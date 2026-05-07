import 'package:flutter/material.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/data/weather/utils/wmo_codes.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';
import 'package:worldscope/features/weather/presentation/widgets/weather_forecast_card.dart';

class DeepDiveWeatherTab extends StatelessWidget {
  const DeepDiveWeatherTab({
    super.key,
    required this.state,
  });

  final DeepDiveSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state.weatherError != null || state.weather == null) {
      return AppErrorWidget(
        message: state.weatherError ?? 'Unable to load weather data.',
      );
    }

    final weather = state.weather!;
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
                    '${weather.tempNow.round()}°C',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Wind: ${weather.windSpeed.round()} km/h'),
                  Text('Condition: ${wmoLabel(weather.weatherCode)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weather.forecast.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) =>
                  WeatherForecastCard(day: weather.forecast[index]),
            ),
          ),
        ],
      ),
    );
  }
}
