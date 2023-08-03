import 'package:pokemonapp/services/graphql/graphql.dart';
import 'package:pokemonapp/services/system_info/system_info.dart';

final class _CoreServicesInternal {
  final GraphQLService graphQL;
  final SystemInfoService systemInfo;

  const _CoreServicesInternal({
    required this.graphQL,
    required this.systemInfo,
  });
}

final class CoreServices {
  static _CoreServicesInternal? _instance;

  static Future<void> init() async {
    if (_instance != null) return;

    // This is according to its initialization order.
    final serviceSystemInfo = await SystemInfoService.init();
    final serviceGraphQL = GraphQLService.init(
      // TODO: Read from ENV
      schemaUrl: 'https://gql-staging.tokopedia.com/',
    );

    _instance = _CoreServicesInternal(
      systemInfo: serviceSystemInfo,
      graphQL: serviceGraphQL,
    );
  }

  static _CoreServicesInternal get _i {
    if (_instance == null) {
      throw Exception('CoreServices has not been initialized yet!');
    }

    return _instance!;
  }

  /// Provides the necessary actions (query and mutation) for handling GraphQL
  /// operations.
  static GraphQLService get graphQL => _i.graphQL;

  /// Provides the necessary informations regarding the current device and also
  /// the app metadata.
  static SystemInfoService get systemInfo => _i.systemInfo;
}
