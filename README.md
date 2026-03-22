# webapp

Flutter-приложение (погода / карта / города — UI-заглушка).

## Требования

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (стабильный канал)
- Android SDK и принятые лицензии

Проверка окружения:

```bash
flutter doctor
```

При необходимости принять лицензии Android:

```bash
flutter doctor --android-licenses
```

## Сборка APK

Из корня проекта (где лежит `pubspec.yaml`):

```bash
flutter pub get
flutter build apk
```

По умолчанию собирается **release**-сборка. Готовый файл:

`build/app/outputs/flutter-apk/app-release.apk`

### Уменьшить размер (отдельный APK под архитектуру)

```bash
flutter build apk --split-per-abi
```

APK появятся в той же папке `build/app/outputs/flutter-apk/` (например, `app-arm64-v8a-release.apk`).

### Отладочная сборка

```bash
flutter build apk --debug
```

Первая сборка может занять **10–20+ минут** (Gradle скачивает зависимости); последующие обычно быстрее.

## Запуск для разработки

```bash
flutter run
```

Выбор устройства: `flutter devices`, затем `flutter run -d <id>` (например `-d chrome` или эмулятор Android).
