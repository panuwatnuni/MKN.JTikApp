import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers/data_providers.dart';
import 'core/providers/shared_preferences_provider.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ]);
  await container.read(mockDataSourceProvider).ensureLoaded();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const JTikApp(),
  ));
}
