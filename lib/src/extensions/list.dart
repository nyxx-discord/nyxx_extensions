import 'package:nyxx/nyxx.dart';

/// Extensions for fetching lists of [SnowflakeEntity]s.
extension PartialList<T extends SnowflakeEntity<T>>
    on List<SnowflakeEntity<T>> {
  /// Get all the entities in this list using the cached entity if possible.
  Future<List<T>> get() => Future.wait(map((entity) => entity.get()));

  /// Fetch all the entities in this list.
  Future<List<T>> fetch() => Future.wait(map((entity) => entity.fetch()));
}
