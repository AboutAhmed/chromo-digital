import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class Helper<T> extends Cubit<T?> {
  Helper([super.initialState]);

  void init(T? state) => emit(state);

  void update(T? state) => emit(state);
}

class Handler<T> extends Cubit<T> {
  Handler(super.initialState);

  void update(T state) => emit(state);
}

@Injectable()
class TimerHelper extends Cubit<int> {
  TimerHelper([super.initialState = 0]);

  Timer? _timer;

  void start({int initialTimeInSeconds = 0, Duration period = const Duration(seconds: 1)}) {
    emit(initialTimeInSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(
      period,
      (Timer timer) {
        emit(state + period.inSeconds);
      },
    );
  }

  void init({int initialTimeInSeconds = 0}) => emit(initialTimeInSeconds);

  void pause() {
    _timer?.cancel();
  }

  void stop() {
    _timer?.cancel();
    emit(0);
  }

  void cancel() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  bool get isRunning => _timer?.isActive ?? false;

  bool get isPaused => !isRunning && state > 0;

  bool get isStopped => !isRunning && state == 0;

  // duration in seconds
  Duration get duration => Duration(seconds: state);

  num get elapsedTime => state;
}
