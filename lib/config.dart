import 'dart:io';

class Environments {
  static const String PRODUCTION = 'prod';
  static const String DEV = 'dev';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Environments.DEV;
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.DEV,
      'url': Platform.isIOS
          ? 'http://localhost:8000/api/v1'
          : 'http://10.0.2.2:8000/api/v1',
    },
    {
      'env': Environments.PRODUCTION,
      'url': Platform.isIOS
          ? 'http://localhost:8000/api/v1'
          : 'http://10.0.2.2:8000/api/v1',
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
