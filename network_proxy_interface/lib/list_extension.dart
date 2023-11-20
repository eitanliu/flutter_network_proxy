extension ListAsyncExt<E> on List<E> {
  Future<void> asyncEach(Future<void> Function(E element) action) async {
    for (final e in this) {
      await action(e);
    }
  }

  Future<List<T>> asyncMap<T>(Future<T> Function(E element) action) async {
    final result = List<T>.empty(growable: true);
    for (final e in this) {
      result.add(await action(e));
    }
    return result;
  }

  Future<List<T>> asyncFlatMap<T>(
    Future<List<T>> Function(E element) action,
  ) async {
    final result = List<T>.empty(growable: true);
    for (final e in this) {
      result.addAll(await action(e));
    }
    return result;
  }

  Future<bool> asyncAny(
    Future<bool> Function(E element) test,
  ) async {
    for (final element in this) {
      if (await test(element)) return true;
    }
    return false;
  }

  Future<bool> asyncEvery(
    Future<bool> Function(E element) test,
  ) async {
    for (E element in this) {
      if (!await test(element)) return false;
    }
    return true;
  }
}

extension FutureListAsyncExt<E> on Future<List<E>> {
  Future<void> asyncEach(Future<void> Function(E element) action) {
    return then((value) => value.asyncEach(action));
  }

  Future<List<T>> asyncMap<T>(Future<T> Function(E element) action) {
    return then((value) => value.asyncMap(action));
  }

  Future<List<T>> asyncFlatMap<T>(
    Future<List<T>> Function(E element) action,
  ) {
    return then((value) => value.asyncFlatMap(action));
  }

  Future<bool> asyncAny(
    Future<bool> Function(E element) test,
  ) {
    return then((value) => value.asyncAny(test));
  }

  Future<bool> asyncEvery(
    Future<bool> Function(E element) test,
  ) {
    return then((value) => value.asyncEvery(test));
  }
}
