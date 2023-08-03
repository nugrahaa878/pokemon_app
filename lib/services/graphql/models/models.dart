import 'package:pokemonapp/services/graphql/models/request.dart';

sealed class GraphQLResponse {}

class GraphQLResponseSuccess<T> extends GraphQLResponse {
  final T data;

  GraphQLResponseSuccess(this.data);

  @override
  String toString() => 'GraphQLResponseSuccess(data: $data)';
}

class GraphQLResponseLoading extends GraphQLResponse {
  final bool isRefetch;

  GraphQLResponseLoading({this.isRefetch = false});
}

enum GraphQLErrorType {
  operation,
  general,
  unknown,
}

class GraphQLResponseFailed extends GraphQLResponse {
  final String errorMessage;
  final GraphQLErrorType errorType;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? additionalMetadata;

  GraphQLResponseFailed(
    this.errorMessage, {
    required this.errorType,
    this.stackTrace,
    this.additionalMetadata,
  });

  @override
  String toString() {
    return 'GraphQLResponseFailed(errorMessage: $errorMessage, errorType: $errorType, stackTrace: $stackTrace, additionalMetadata: $additionalMetadata)';
  }
}

typedef QueryRequestPayload<I extends GraphQLInput<I>> = ({
  String query,
  I? input,
  GraphQLOptions? options,
});

abstract interface class QueryBase<D, I extends GraphQLInput<I>> {
  D normalizer(Map<String, dynamic> rawData);

  Future<QueryRequestPayload<I>> get requestPayload;
}

typedef MutationRequestPayload<I extends GraphQLInput<I>> = ({
  String query,
  I? input,
  GraphQLOptions? options,
});

abstract interface class MutationBase<D, I extends GraphQLInput<I>> {
  D normalizer(Map<String, dynamic> rawData);

  Future<MutationRequestPayload<I>> get requestPayload;
}
