import 'base_env_config.dart';

/// Pharcoo environment-specific configurations.
///
/// Extends [BaseEnvConfig] and provides the environment values specific
/// to the Pharcoo environment.
class PharcooEnvConfig extends BaseEnvConfig {
  @override
  String get baseUrl =>
      'http://37.61.217.36:8090/Pharcoo-master/public/index.php/api/v1';
}
