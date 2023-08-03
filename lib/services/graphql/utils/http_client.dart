import 'package:http/http.dart' as http;
import 'package:pokemonapp/services/services.dart';

final class GraphQLHTTPClient extends http.BaseClient {
  static const _headerKeyUserAgent = "User-Agent";
  static const _headerKeyAuthority = "authority";
  static const _headerKeyReferer = "referer";
  static const _headerValueReferer = "TOKOPEDIA-ACADEMY-APP";
  static const _headerValueAuthority = "gql.tokopedia.com";

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[_headerKeyUserAgent] = _getHeaderUserAgent();
    request.headers[_headerKeyAuthority] = _headerValueAuthority;
    request.headers[_headerKeyReferer] = _headerValueReferer;

    // TODO: Read from ENV
    // if (kDebugMode) {
    //   print("Headers: ${request.headers}");
    // }

    return request.send().timeout(const Duration(seconds: 15));
  }

  String _getHeaderUserAgent() {
    final deviceUserAgent = CoreServices.systemInfo.getUserAgent();

    return deviceUserAgent.replaceAll(RegExp('[^\u0001-\u007F]'), '_');
  }
}
