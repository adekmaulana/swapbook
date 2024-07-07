class Environments {
  static const String PRODUCTION = 'prod';
  static const String DEV = 'dev';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Environments.DEV;
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.DEV,
      'url': 'http://127.0.0.1:8000/api/v1',
    },
    {
      'env': Environments.PRODUCTION,
      'url': 'http://127.0.0.1:8000/api/v1',
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
