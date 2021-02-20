import 'dart:async';

/// Simple class helper used for preventing function to execute multiple time.
///
/// when using Debounce, a single Function will only be called after a certain period of time.
class Debouncer {
  /// how long should it wait before executing the function
  final Duration delay;
  Timer _timer;

  Debouncer({this.delay});

  run(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
