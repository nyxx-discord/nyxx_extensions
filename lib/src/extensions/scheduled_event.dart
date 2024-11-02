import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/managers/scheduled_event_manager.dart';
import 'package:nyxx_extensions/src/utils/endpoint_paginator.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';

/// Extensions on [PartialScheduledEvent].
extension PartialScheduledEventExtensions on PartialScheduledEvent {
  /// Same as [listUsers], but has no limit on the number of users returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  ///
  /// {@macro paginated_endpoint_order_parameters}
  Stream<ScheduledEventUser> streamUsers({
    bool? withMembers,
    Snowflake? before,
    Snowflake? after,
    int? pageSize,
    StreamOrder? order,
  }) =>
      manager.streamEventUsers(
        id,
        after: after,
        before: before,
        order: order,
        pageSize: pageSize,
        withMembers: withMembers,
      );
}

extension ScheduledEventExtensions on ScheduledEvent {
  /// The URL of this event's icon image.
  Uri? coverUrl({CdnFormat? format, int? size}) => coverImage?.get(format: format, size: size);
}
