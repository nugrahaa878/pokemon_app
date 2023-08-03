import 'package:graphql/client.dart';

Map<String, dynamic> createExceptionMetadata(Object exception) {
  if (exception is OperationException) {
    final OperationException(
      :graphqlErrors,
      :linkException,
      :originalStackTrace,
    ) = exception;

    return {
      'graphqlErrors': graphqlErrors,
      'linkException': linkException,
      'originalStackTrace': originalStackTrace,
    };
  }

  return {};
}
