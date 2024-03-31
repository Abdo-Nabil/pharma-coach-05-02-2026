import 'base_env_config.dart';
import 'global_env_config.dart';
import 'pharcoo_env_config.dart';

/// Enum representing different environments.
///
/// Use this [Environment] enum to specify the desired environment
/// for managing environment-specific configurations and behaviors.
enum Environment { global, pharcoo }

/// EnvConfig class for managing environment-specific configurations.
class EnvConfig {
  late BaseEnvConfig config;

  /// Initializes the configuration based on the specified [environment].
  ///
  /// If [environment] is not provided, it defaults to `null`.
  initConfig({Environment? environment}) {
    config = _getConfig(environment ?? null);
  }

  /// Retrieves the configuration for the specified [environment].
  ///
  /// Returns an instance of a subclass of [BaseEnvConfig] corresponding to the
  /// provided [environment], or specified default environment if the environment
  /// is not recognized.
  _getConfig([Environment? environment]) {
    switch (environment) {
      case Environment.global:
        return GlobalEnvConfig();
      case Environment.pharcoo:
        return PharcooEnvConfig();
      default:
        return GlobalEnvConfig();
    }
  }
}
