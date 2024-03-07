import 'package:logger/logger.dart' as logger_package;

class Logger {
  static logger_package.Logger? _logger;
  static getLogger() {
    if (_logger == null) {
      _logger = logger_package.Logger();
    }
    return _logger;
  }
}
