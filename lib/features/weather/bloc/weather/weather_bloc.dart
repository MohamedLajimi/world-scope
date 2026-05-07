import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worldscope/data/weather/models/weather_model.dart';
import 'package:worldscope/data/weather/services/weather_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required WeatherService weatherService,
  })  : _weatherService = weatherService,
        super(const WeatherLoading()) {
    on<WeatherInitialized>(_onInitialized);
    on<WeatherSearchFieldTapped>(_onSearchFieldTapped);
    on<WeatherSearchSubmitted>(_onSearchSubmitted);
  }

  static const String _lastCityKey = 'last_city';

  final WeatherService _weatherService;
  String? _lastSavedCity;
  WeatherModel? _latestWeather;
  String? _latestCity;

  Future<void> _onInitialized(
    WeatherInitialized event,
    Emitter<WeatherState> emit,
  ) async {
    _lastSavedCity = await _readLastSavedCity();
    final cachedCity = _lastSavedCity?.trim() ?? '';
    if (cachedCity.isNotEmpty) {
      emit(WeatherLoading(lastSearchedCity: cachedCity));
      final result = await _weatherService.getWeatherForCity(cachedCity);
      await result.fold(
        (failure) async {
          emit(
            WeatherFailure(
              message: failure.message,
              lastSearchedCity: cachedCity,
            ),
          );
        },
        (weather) async {
          _latestWeather = weather;
          _latestCity = cachedCity;
          emit(
            WeatherSuccess(
              weather: weather,
              city: cachedCity,
              lastSearchedCity: cachedCity,
            ),
          );
        },
      );
      return;
    }

    emit(
      WeatherSuccess(
        weather: _latestWeather,
        city: _latestCity,
        lastSearchedCity: _lastSavedCity,
      ),
    );
  }

  Future<void> _onSearchFieldTapped(
    WeatherSearchFieldTapped event,
    Emitter<WeatherState> emit,
  ) async {
    _lastSavedCity ??= await _readLastSavedCity();
    if (_lastSavedCity == null || _lastSavedCity!.isEmpty) {
      return;
    }

    final currentState = state;
    if (currentState is WeatherFailure) {
      emit(
        WeatherFailure(
          message: currentState.message,
          lastSearchedCity: _lastSavedCity,
          showLastSearchSuggestion: true,
        ),
      );
      return;
    }

    emit(
      WeatherSuccess(
        weather: _latestWeather,
        city: _latestCity,
        lastSearchedCity: _lastSavedCity,
        showLastSearchSuggestion: true,
      ),
    );
  }

  Future<void> _onSearchSubmitted(
    WeatherSearchSubmitted event,
    Emitter<WeatherState> emit,
  ) async {
    final normalizedCity = event.city.trim();
    if (normalizedCity.isEmpty) {
      emit(
        WeatherFailure(
          message: 'Please enter a city name.',
          lastSearchedCity: _lastSavedCity,
        ),
      );
      return;
    }

    emit(WeatherLoading(lastSearchedCity: _lastSavedCity));

    final result = await _weatherService.getWeatherForCity(normalizedCity);
    await result.fold(
      (failure) async {
        emit(
          WeatherFailure(
            message: failure.message,
            lastSearchedCity: _lastSavedCity,
          ),
        );
      },
      (weather) async {
        _latestWeather = weather;
        _latestCity = normalizedCity;
        _lastSavedCity = normalizedCity;
        await _saveLastCity(normalizedCity);
        emit(
          WeatherSuccess(
            weather: weather,
            city: normalizedCity,
            lastSearchedCity: _lastSavedCity,
          ),
        );
      },
    );
  }

  Future<String?> _readLastSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCityKey);
  }

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, city);
  }
}
