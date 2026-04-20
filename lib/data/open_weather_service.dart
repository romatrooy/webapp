import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiCity {
  const ApiCity({
    required this.name,
    required this.countryCode,
    required this.lat,
    required this.lon,
  });

  final String name;
  final String countryCode;
  final double lat;
  final double lon;
}

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperature,
    required this.description,
    required this.forecast,
    required this.hourlyToday,
  });

  final double temperature;
  final String description;
  final List<ForecastItem> forecast;
  final List<HourlyForecastItem> hourlyToday;
}

class ForecastItem {
  const ForecastItem({
    required this.label,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
  });

  final String label;
  final double maxTemp;
  final double minTemp;
  final String icon;
}

class HourlyForecastItem {
  const HourlyForecastItem({
    required this.timeLabel,
    required this.temp,
    required this.icon,
  });

  final String timeLabel;
  final double temp;
  final String icon;
}

class OpenWeatherService {
  OpenWeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const String _apiKey = '0ac1c1e4ed8bd44594547f92684093de';
  final http.Client _client;

  Future<List<ApiCity>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const [];
    }

    final uri = Uri.https('api.openweathermap.org', '/geo/1.0/direct', {
      'q': trimmed,
      'limit': '10',
      'appid': _apiKey,
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Не удалось загрузить список городов');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => e as Map<String, dynamic>)
        .map(
          (e) => ApiCity(
            name: (e['name'] as String?) ?? '',
            countryCode: (e['country'] as String?) ?? '',
            lat: (e['lat'] as num).toDouble(),
            lon: (e['lon'] as num).toDouble(),
          ),
        )
        .where((c) => c.name.isNotEmpty)
        .toList();
  }

  Future<WeatherSnapshot> getWeather(double lat, double lon) async {
    final currentUri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'ru',
    });
    final currentRes = await _client.get(currentUri);
    if (currentRes.statusCode != 200) {
      throw Exception('Не удалось загрузить текущую погоду');
    }
    final currentData = jsonDecode(currentRes.body) as Map<String, dynamic>;
    final main = currentData['main'] as Map<String, dynamic>;
    final weatherList = currentData['weather'] as List<dynamic>;
    final description = weatherList.isEmpty
        ? ''
        : ((weatherList.first as Map<String, dynamic>)['description'] as String? ?? '');

    final threeHour = await _loadThreeHourForecast(lat, lon);
    final dailyForecast = await _loadDailyForecast(lat, lon, threeHour);
    final hourlyToday = _buildHourlyToday(threeHour);

    return WeatherSnapshot(
      temperature: (main['temp'] as num).toDouble(),
      description: description,
      forecast: dailyForecast,
      hourlyToday: hourlyToday,
    );
  }

  Future<List<ForecastItem>> _loadDailyForecast(
    double lat,
    double lon,
    List<Map<String, dynamic>> threeHour,
  ) async {
    final dailyUri = Uri.https('api.openweathermap.org', '/data/2.5/forecast/daily', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'ru',
      'cnt': '10',
    });
    final dailyRes = await _client.get(dailyUri);
    if (dailyRes.statusCode == 200) {
      final data = jsonDecode(dailyRes.body) as Map<String, dynamic>;
      final list = (data['list'] as List<dynamic>? ?? const []);
      final parsed = list.map((e) => e as Map<String, dynamic>).map((entry) {
        final dt = (entry['dt'] as num?)?.toInt();
        final date = dt == null
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true).toLocal();
        final temp = entry['temp'] as Map<String, dynamic>? ?? const {};
        final max = (temp['max'] as num?)?.toDouble() ?? 0;
        final min = (temp['min'] as num?)?.toDouble() ?? 0;
        final weather = (entry['weather'] as List<dynamic>? ?? const []);
        final icon = weather.isEmpty
            ? '01d'
            : ((weather.first as Map<String, dynamic>)['icon'] as String? ?? '01d');
        return ForecastItem(
          label: _weekdayLabel(date),
          maxTemp: max,
          minTemp: min,
          icon: icon,
        );
      }).toList();
      if (parsed.isNotEmpty) {
        return parsed.take(6).toList();
      }
    }

    return _buildDailyFromThreeHour(threeHour);
  }

  Future<List<Map<String, dynamic>>> _loadThreeHourForecast(double lat, double lon) async {
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/forecast', {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'ru',
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Не удалось загрузить прогноз погоды');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = (data['list'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
    return list;
  }

  List<ForecastItem> _buildDailyFromThreeHour(List<Map<String, dynamic>> list) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final entry in list) {
      final dtTxt = (entry['dt_txt'] as String?) ?? '';
      final key = dtTxt.length >= 10 ? dtTxt.substring(0, 10) : dtTxt;
      grouped.putIfAbsent(key, () => <Map<String, dynamic>>[]).add(entry);
    }

    return grouped.entries.take(6).map((group) {
      final samples = group.value;
      var max = -1000.0;
      var min = 1000.0;
      String icon = '01d';
      for (final sample in samples) {
        final main = sample['main'] as Map<String, dynamic>? ?? const {};
        final temp = (main['temp'] as num?)?.toDouble() ?? 0;
        if (temp > max) max = temp;
        if (temp < min) min = temp;
        final weather = (sample['weather'] as List<dynamic>? ?? const []);
        if (weather.isNotEmpty) {
          icon = ((weather.first as Map<String, dynamic>)['icon'] as String? ?? icon);
        }
      }
      final date = DateTime.tryParse(group.key) ?? DateTime.now();
      return ForecastItem(
        label: _weekdayLabel(date),
        maxTemp: max,
        minTemp: min,
        icon: icon,
      );
    }).toList();
  }

  List<HourlyForecastItem> _buildHourlyToday(List<Map<String, dynamic>> list) {
    final now = DateTime.now();
    final todayKey = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final items = list.where((entry) {
      final dtTxt = (entry['dt_txt'] as String?) ?? '';
      return dtTxt.startsWith(todayKey);
    }).take(8).map((entry) {
      final dtTxt = (entry['dt_txt'] as String?) ?? '';
      final timeLabel = dtTxt.length >= 16 ? dtTxt.substring(11, 16) : '--:--';
      final main = entry['main'] as Map<String, dynamic>? ?? const {};
      final temp = (main['temp'] as num?)?.toDouble() ?? 0;
      final weather = (entry['weather'] as List<dynamic>? ?? const []);
      final icon = weather.isEmpty
          ? '01d'
          : ((weather.first as Map<String, dynamic>)['icon'] as String? ?? '01d');
      return HourlyForecastItem(timeLabel: timeLabel, temp: temp, icon: icon);
    }).toList();

    if (items.isNotEmpty) {
      return items;
    }

    return list.take(8).map((entry) {
      final dtTxt = (entry['dt_txt'] as String?) ?? '';
      final timeLabel = dtTxt.length >= 16 ? dtTxt.substring(11, 16) : '--:--';
      final main = entry['main'] as Map<String, dynamic>? ?? const {};
      final temp = (main['temp'] as num?)?.toDouble() ?? 0;
      final weather = (entry['weather'] as List<dynamic>? ?? const []);
      final icon = weather.isEmpty
          ? '01d'
          : ((weather.first as Map<String, dynamic>)['icon'] as String? ?? '01d');
      return HourlyForecastItem(timeLabel: timeLabel, temp: temp, icon: icon);
    }).toList();
  }

  String _weekdayLabel(DateTime date) {
    final now = DateTime.now();
    if (now.year == date.year && now.month == date.month && now.day == date.day) {
      return 'Сегодня';
    }
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[date.weekday - 1];
  }
}
