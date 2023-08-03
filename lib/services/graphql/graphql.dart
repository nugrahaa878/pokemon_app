import 'package:graphql/client.dart';

import './helpers/create_exception_metadata.dart';
import './models/models.dart';
import './models/request.dart';
import './utils/http_client.dart';

typedef Normalizer<T> = T Function(
  Map<String, dynamic> rawData,
);

final class GraphQLService {
  final GraphQLClient _client;

  GraphQLService._({required GraphQLClient client}) : _client = client;

  factory GraphQLService.init({required String schemaUrl}) {
    final link = HttpLink(schemaUrl, httpClient: GraphQLHTTPClient());

    return GraphQLService._(
      client: GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }

  Future<QueryResult> rawQuery(
    String query, {
    Map<String, dynamic>? variables,
    GraphQLOptions? options,
  }) async {
    return await _client.query(
      QueryOptions(
        document: gql(query),
        variables: variables ?? {},
        context: options?.context,
        fetchPolicy: options?.fetchPolicy,
      ),
    );
  }

  Future<QueryResult> rawMutate(
    String mutation, {
    Map<String, dynamic>? variables,
    GraphQLOptions? options,
  }) async {
    return await _client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables ?? {},
        context: options?.context,
        fetchPolicy: options?.fetchPolicy,
      ),
    );
  }

  Future<GraphQLResponse> _parseOperationResponse<D>({
    required Future<QueryResult<Object?>> Function() getResponse,
    required Normalizer<D> normalizer,
  }) async {
    try {
      final QueryResult(:data, :exception) = await getResponse();

      if (data != null) {
        return GraphQLResponseSuccess(normalizer(data));
      }

      if (exception != null) {
        throw exception;
      }

      throw Exception('No data!');
    } //
    catch (ex, st) {
      return GraphQLResponseFailed(
        ex.toString(),
        errorType: switch (ex) {
          OperationException() => GraphQLErrorType.operation,
          Exception() => GraphQLErrorType.general,
          _ => GraphQLErrorType.unknown,
        },
        stackTrace: st,
        additionalMetadata: createExceptionMetadata(ex),
      );
    }
  }

  Future<GraphQLResponse> query<D, I extends GraphQLInput<I>>(
    QueryBase<D, I> queryPayload,
  ) async {
    final QueryBase<D, I>(:requestPayload, :normalizer) = queryPayload;
    final (query: queryDocument, :input, :options) = await requestPayload;

    return _parseOperationResponse(
      getResponse: () => rawQuery(
        queryDocument,
        variables: input?.convertToJson(),
        options: options,
      ),
      normalizer: normalizer,
    );
  }

  Future<GraphQLResponse> mutate<D, I extends GraphQLInput<I>>(
    MutationBase<D, I> mutationPayload,
  ) async {
    //
    final MutationBase<D, I>(:requestPayload, :normalizer) = mutationPayload;
    final (query: queryDocument, :input, :options) = await requestPayload;

    return _parseOperationResponse(
      getResponse: () => rawQuery(
        queryDocument,
        variables: input?.convertToJson(),
        options: options,
      ),
      normalizer: normalizer,
    );
  }
}
