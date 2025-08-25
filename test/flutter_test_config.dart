import 'dart:async';

import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

/// This is the main entry point for running tests with leak detection enabled.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  LeakTesting.enable();

  await testMain();
}
