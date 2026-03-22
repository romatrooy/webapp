import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Палитра близкая к прототипу
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  late final List<Widget> _screens = [
    const MapScreen(),
    const WeatherScreen(),
    const CityListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.turquoiseBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: _screens[_currentIndex]),
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

// ---------------- WEATHER SCREEN ----------------

class _ForecastItem {
  const _ForecastItem(this.day, this.low, this.high, this.icon);

  final String day;
  final String low;
  final String high;
  final IconData icon;
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  static const _forecast = <_ForecastItem>[
    _ForecastItem('Сегодня', '-31°', '-22°', Icons.cloudy_snowing),
    _ForecastItem('Пн', '-31°', '-22°', Icons.wb_cloudy_outlined),
    _ForecastItem('Вт', '-28°', '-18°', Icons.wb_sunny_outlined),
    _ForecastItem('Ср', '-30°', '-20°', Icons.ac_unit),
    _ForecastItem('Чт', '-27°', '-17°', Icons.grain),
    _ForecastItem('Пт', '-29°', '-19°', Icons.thunderstorm_outlined),
    _ForecastItem('Сб', '-26°', '-16°', Icons.wb_cloudy_outlined),
    _ForecastItem('Вс', '-25°', '-15°', Icons.wb_sunny_outlined),
    _ForecastItem('Пн', '-24°', '-14°', Icons.cloudy_snowing),
    _ForecastItem('Вт', '-23°', '-13°', Icons.wb_cloudy_outlined),
  ];

  static const _navClearance = 88.0;

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
          child: Column(
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
              const Text(
                'Москва',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '-24°',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
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
                                'Прогноз на 10 дней',
                                style: TextStyle(
                                  fontSize: 16,
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
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _forecast.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            itemBuilder: (context, index) {
                              final item = _forecast[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 76,
                                      child: Text(
                                        item.day,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(item.icon, color: Colors.white, size: 22),
                                    const Spacer(),
                                    Text(
                                      item.low,
                                      style: const TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      item.high,
                                      style: const TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- MAP SCREEN ----------------

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const _navClearance = 100.0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.turquoiseBg,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, _navClearance),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    const _StylizedMapBackground(),
                    ..._mapLabels.map(
                      (l) => Positioned(
                        left: w * l.fx,
                        top: h * l.fy,
                        child: Text(
                          l.text,
                          style: TextStyle(
                            fontSize: l.size,
                            color: const Color(0xFF2D4A3E).withValues(alpha: 0.75),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            color: Colors.white.withValues(alpha: 0.28),
                            child: const Text(
                              'Москва -24°',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MapLabel {
  const _MapLabel(this.text, this.fx, this.fy, [this.size = 12.0]);

  final String text;
  final double fx;
  final double fy;
  final double size;
}

const _mapLabels = <_MapLabel>[
  _MapLabel('Москва', 0.38, 0.42, 14),
  _MapLabel('Химки', 0.32, 0.38),
  _MapLabel('Тверь', 0.22, 0.28),
  _MapLabel('Тула', 0.35, 0.58),
  _MapLabel('Рязань', 0.48, 0.62),
  _MapLabel('Владимир', 0.55, 0.35),
];

class _StylizedMapBackground extends StatelessWidget {
  const _StylizedMapBackground();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFB8E8C8),
      child: CustomPaint(
        painter: _MapLandPainter(),
        child: SizedBox.expand(),
      ),
    );
  }
}

class _MapLandPainter extends CustomPainter {
  const _MapLandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final water = Paint()..color = const Color(0xFF9FD4E8);
    canvas.drawRect(Offset.zero & size, water);

    final land = Paint()..color = const Color(0xFFC4EFD4);
    final path = Path()
      ..moveTo(0, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.05, size.width * 0.55, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.95, size.height * 0.35, size.width * 0.88, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.85, size.width * 0.4, size.height * 0.92)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.88, 0, size.height * 0.65)
      ..close();
    canvas.drawPath(path, land);

    final land2 = Paint()..color = const Color(0xFFB5E6C8);
    final path2 = Path()
      ..moveTo(size.width * 0.6, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.25, size.width * 0.6, 0)
      ..close();
    canvas.drawPath(path2, land2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------- CITY LIST ----------------

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  static const _cities = <(String name, String temp)>[
    ('Москва', '-24°'),
    ('Красноярск', '-30°'),
    ('Екатеринбург', '-26°'),
    ('Новосибирск', '-28°'),
    ('Иркутск', '-25°'),
    ('Омск', '-19°'),
    ('Санкт-Петербург', '-14°'),
    ('Калининград', '-10°'),
  ];

  static const _navClearance = 96.0;

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
                  Container(
                    height: 1,
                    color: AppColors.searchText.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Поиск города',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.searchText.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20, 0, 20, _navClearance),
                itemCount: _cities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  return Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          city.$1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          city.$2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
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
        ),
      ),
    );
  }
}
