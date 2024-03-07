import 'package:logger/logger.dart' as LoggerPackage;

class Logger {
  static LoggerPackage.Logger? _logger;
  static getLogger() {
    if (_logger == null) {
      _logger = LoggerPackage.Logger();
    }
    return _logger;
  }
}
