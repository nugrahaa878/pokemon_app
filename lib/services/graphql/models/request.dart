import 'package:graphql/client.dart';

final class GraphQLOptions {
  final FetchPolicy? fetchPolicy;
  final Context? context;

  const GraphQLOptions({
    this.fetchPolicy,
    this.context,
  });
}

abstract interface class GraphQLInput<T> {
  Map<String, dynamic> convertToJson();
}
