import 'package:fpdart/fpdart.dart';

import '../error/error.dart';

abstract interface class Usecase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(
    Params params,
  );
}
class NoParams {
}