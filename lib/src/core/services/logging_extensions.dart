import 'package:logger/logger.dart';

extension LoggerExtension on Logger {
  void trace(String message) => t(message);
  void debug(String message) => d(message);
  void info(String message) => i(message);
  void warning(String message) => w(message);
  void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      e(message, error: error, stackTrace: stackTrace);
  void fatal(String message) => f(message);
}
