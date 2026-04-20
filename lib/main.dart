import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:webapp/data/app_database.dart';
import 'package:webapp/data/open_weather_service.dart';

final OpenWeatherService _weatherService = OpenWeatherService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(MyApp(database: database));
}

class AppColors {
  AppColors._();

  static const Color turquoiseBg = Color(0xFF5AD8DC);
  static const Color turquoiseDeep = Color(0xFF3BC4CC);
  static const Color weatherGradientTop = Color(0xFF7EE8EA);
  static const Color weatherGradientBottom = Color(0xFF4EC8CF);
  static const Color navPink = Color(0xFFE85D7A);
  static const Color navBarFill = Color(0xFFC8F5F5);
  static const Color navChevronCircle = Color(0xFF4AB8B8);
  static const Color forecastCardTop = Color(0xFF3A7FD8);
  static const Color forecastCardBottom = Color(0xFF1E5BB5);
  static const Color cityCardBlueLeft = Color(0xFF3D7FE8);
  static const Color cityCardBlueRight = Color(0xFF5BA3FF);
  static const Color searchText = Color(0xFF2A9CA8);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: MainScreen(database: database),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;
  bool _isDbReady = false;

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    await widget.database.seedMasterCitiesIfEmpty();
    if (!mounted) {
      return;
    }
    setState(() {
      _isDbReady = true;
    });
  }

  @override
  void dispose() {
    widget.database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    if (!_isDbReady) {
      return const Scaffold(
        backgroundColor: AppColors.turquoiseBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.turquoiseBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                MapScreen(database: widget.database),
                WeatherScreen(database: widget.database),
                CityListScreen(database: widget.database),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 12 + bottomInset,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onSelect: (i) => setState(() => _currentIndex = i),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  static const _labels = ['Карта', 'Погода', 'Город'];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.navBarFill.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0)
                Container(
                  width: 1,
                  height: 26,
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(i),
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _labels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: currentIndex == i
                              ? AppColors.navPink
                              : const Color(0xFF1A1A1A).withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 10),
            Material(
              color: AppColors.navChevronCircle,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {},
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.chevron_right, color: Colors.black87, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  static const _navClearance = 88.0;
  final PageController _pageController = PageController();
  int _currentCityPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.weatherGradientTop, AppColors.weatherGradientBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: _navClearance),
          child: StreamBuilder<List<UserCityWithName>>(
            stream: widget.database.watchUserCities(),
            builder: (context, snapshot) {
              final selectedCities = snapshot.data ?? const <UserCityWithName>[];
              final cities = selectedCities.isEmpty
                  ? const <UserCityWithName>[
                      UserCityWithName(
                        userCityId: -1,
                        masterCityId: -1,
                        name: 'Москва',
                        countryCode: 'RU',
                        lat: 55.7558,
                        lon: 37.6173,
                        sortOrder: 0,
                      )
                    ]
                  : selectedCities;
              final tabsCount = cities.length;
              if (_currentCityPage >= tabsCount) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _currentCityPage = tabsCount - 1;
                  });
                  _pageController.jumpToPage(tabsCount - 1);
                });
              }

              return Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'Выбранное место',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cities[_currentCityPage.clamp(0, tabsCount - 1)].name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<WeatherSnapshot>(
                    future: _weatherService.getWeather(
                      cities[_currentCityPage.clamp(0, tabsCount - 1)].lat,
                      cities[_currentCityPage.clamp(0, tabsCount - 1)].lon,
                    ),
                    builder: (context, weatherSnapshot) {
                      final temp = weatherSnapshot.hasData
                          ? '${weatherSnapshot.data!.temperature.round()}°'
                          : '--°';
                      return Text(
                        temp,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.05,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: tabsCount,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCityPage = index;
                        });
                      },
                      itemBuilder: (context, pageIndex) {
                        final city = cities[pageIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [AppColors.forecastCardTop, AppColors.forecastCardBottom],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.white.withValues(alpha: 0.95),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Прогноз на 6 дней',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(alpha: 0.98),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.white.withValues(alpha: 0.22),
                                ),
                                Expanded(
                                  child: FutureBuilder<WeatherSnapshot>(
                                    future: _weatherService.getWeather(city.lat, city.lon),
                                    builder: (context, forecastSnapshot) {
                                      final forecast = forecastSnapshot.data?.forecast ?? const <ForecastItem>[];
                                      if (forecastSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                                      }
                                      if (forecastSnapshot.hasError || forecast.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'Не удалось загрузить прогноз',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      }

                                      final hourly = forecastSnapshot.data?.hourlyToday ?? const <HourlyForecastItem>[];
                                      return Column(
                                        children: [
                                          Expanded(
                                            child: ListView.separated(
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                              itemCount: forecast.length,
                                              separatorBuilder: (_, __) => Divider(
                                                height: 1,
                                                thickness: 0.5,
                                                color: Colors.white.withValues(alpha: 0.15),
                                              ),
                                              itemBuilder: (context, index) {
                                                final item = forecast[index];
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 90,
                                                        child: Text(
                                                          item.label,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(_weatherIcon(item.icon), color: Colors.white, size: 24),
                                                      const Spacer(),
                                                      Text(
                                                        '${item.maxTemp.round()}°/${item.minTemp.round()}°',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          if (hourly.isNotEmpty) ...[
                                            Divider(
                                              height: 1,
                                              thickness: 0.8,
                                              color: Colors.white.withValues(alpha: 0.22),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.schedule,
                                                    size: 18,
                                                    color: Colors.white.withValues(alpha: 0.9),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Почасовой прогноз на сегодня',
                                                    style: TextStyle(
                                                      color: Colors.white.withValues(alpha: 0.95),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 82,
                                              child: ListView.separated(
                                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: hourly.length,
                                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                                itemBuilder: (context, index) {
                                                  final h = hourly[index];
                                                  return Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withValues(alpha: 0.14),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          h.timeLabel,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Icon(_weatherIcon(h.icon), color: Colors.white, size: 16),
                                                        Text(
                                                          '${h.temp.round()}°',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      tabsCount.clamp(1, 8),
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: index == _currentCityPage
                              ? Colors.black87
                              : Colors.black.withValues(alpha: 0.22),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

IconData _weatherIcon(String code) {
  if (code.startsWith('01')) return Icons.wb_sunny_outlined;
  if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) {
    return Icons.wb_cloudy_outlined;
  }
  if (code.startsWith('09') || code.startsWith('10')) return Icons.grain;
  if (code.startsWith('11')) return Icons.thunderstorm_outlined;
  if (code.startsWith('13')) return Icons.cloudy_snowing;
  return Icons.cloud_queue_outlined;
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.database});

  final AppDatabase database;

  static const _navClearance = 100.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserCityWithName>>(
      stream: database.watchUserCities(),
      builder: (context, snapshot) {
        final cities = snapshot.data ?? const <UserCityWithName>[];
        final center = cities.isNotEmpty
            ? latlng.LatLng(cities.first.lat, cities.first.lon)
            : const latlng.LatLng(55.7558, 37.6173);

        return ColoredBox(
          color: AppColors.turquoiseBg,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, _navClearance),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 5.6,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.webapp',
                    ),
                    MarkerLayer(
                      markers: cities
                          .map(
                            (city) => Marker(
                              width: 136,
                              height: 56,
                              point: latlng.LatLng(city.lat, city.lon),
                              child: FutureBuilder<WeatherSnapshot>(
                                future: _weatherService.getWeather(city.lat, city.lon),
                                builder: (context, weatherSnapshot) {
                                  final tempText = weatherSnapshot.hasData
                                      ? '${weatherSnapshot.data!.temperature.round()}°'
                                      : '--°';
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              city.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            tempText,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  static const _navClearance = 96.0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ApiCity> _searchResults = const [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadSearchResults('');
    _searchController.addListener(() {
      _loadSearchResults(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchResults(String query) async {
    setState(() {
      _isSearching = true;
    });
    List<ApiCity> result = const [];
    try {
      result = await _weatherService.searchCities(query);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить города из OpenWeatherMap')),
        );
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _searchResults = result;
      _isSearching = false;
    });
  }

  Future<void> _addCity(ApiCity city) async {
    final master = await widget.database.upsertMasterCity(
      name: city.name,
      countryCode: city.countryCode,
      lat: city.lat,
      lon: city.lon,
    );
    await widget.database.addUserCity(master.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${city.name} добавлен в ваш список')),
    );
  }

  Future<void> _removeCity(UserCityWithName city) async {
    await widget.database.removeUserCity(city.userCityId);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${city.name} удален из вашего списка')),
    );
  }

  Future<void> _reorderUserCities(
    List<UserCityWithName> cities,
    int oldIndex,
    int newIndex,
  ) async {
    final reordered = List<UserCityWithName>.from(cities);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    final orderedIds = reordered.map((c) => c.userCityId).toList();
    await widget.database.reorderUserCities(orderedIds);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.turquoiseBg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: AppColors.searchText.withValues(alpha: 0.35)),
                  const SizedBox(height: 10),
                  Text(
                    'Поиск города',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.searchText.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    autocorrect: false,
                    enableSuggestions: false,
                    onTapOutside: (_) => _searchFocusNode.unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Введите название...',
                      hintStyle: TextStyle(color: AppColors.searchText.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<List<UserCityWithName>>(
              stream: widget.database.watchUserCities(),
              builder: (context, selectedSnapshot) {
                final selectedCityKeys = (selectedSnapshot.data ?? const <UserCityWithName>[])
                    .map((c) => '${c.name.toLowerCase()}_${c.lat}_${c.lon}')
                    .toSet();
                return SizedBox(
                  height: 145,
                  child: _isSearching
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _searchResults.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final city = _searchResults[index];
                            final cityKey = '${city.name.toLowerCase()}_${city.lat}_${city.lon}';
                            final isAdded = selectedCityKeys.contains(cityKey);
                            return Container(
                              width: 180,
                              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${city.name}, ${city.countryCode}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: isAdded ? null : () => _addCity(city),
                                      icon: Icon(isAdded ? Icons.check : Icons.add, size: 16),
                                      label: Text(isAdded ? 'Добавлено' : 'Добавить'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ваши города',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<UserCityWithName>>(
                stream: widget.database.watchUserCities(),
                builder: (context, snapshot) {
                  final userCities = snapshot.data ?? const <UserCityWithName>[];

                  if (userCities.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, _navClearance),
                      child: Center(
                        child: Text(
                          'Пока нет добавленных городов',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }

                  return ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, _navClearance),
                    itemCount: userCities.length,
                    proxyDecorator: (child, _, __) => Material(
                      color: Colors.transparent,
                      child: child,
                    ),
                    onReorder: (oldIndex, newIndex) =>
                        _reorderUserCities(userCities, oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final city = userCities[index];
                      return Padding(
                        key: ValueKey(city.userCityId),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: const LinearGradient(
                              colors: [AppColors.cityCardBlueLeft, AppColors.cityCardBlueRight],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.drag_indicator, color: Colors.white70),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  city.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeCity(city),
                                icon: const Icon(Icons.delete_outline, color: Colors.white),
                                tooltip: 'Удалить',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
