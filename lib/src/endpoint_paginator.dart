import 'package:nyxx/nyxx.dart';

/// Controls the order in which entities from paginated endpoints are streamed.
enum StreamOrder {
  /// Emit the entities in order of most recent to oldest.
  mostRecentFirst,

  /// Emit the entities on order of oldest to most recent.
  oldestFirst,
}

/// Wrap the paginated API call [fetchPage] into a stream.
///
/// Although this function supports bi-directional emitting of events using the
/// [order] parameter, it can be used for API endpoints that only support
/// pagination in one direction by hard-coding the [order] parameter to match
/// the API order.
Stream<T> _streamPaginatedEndpoint<T>(
  Future<List<T>> Function({Snowflake? before, Snowflake? after, int? limit}) fetchPage, {
  required Snowflake Function(T) extractId,
  required Snowflake? before,
  required Snowflake? after,
  required int? pageSize,
  required StreamOrder? order,
}) async* {
  // Both after and before:    oldest first
  // Only after:               oldest first
  // Only before:              most recent first
  // Neither after nor before: oldest first
  order ??= before != null && after == null ? StreamOrder.mostRecentFirst : StreamOrder.oldestFirst;
  before ??= Snowflake.now();
  after ??= Snowflake.zero;

  var nextPageBefore = before;
  var nextPageAfter = after;

  while (true) {
    // We choose the order of the pages by passing either before or after
    // depending on the stream order.
    final page = await switch (order) {
      StreamOrder.mostRecentFirst => fetchPage(limit: pageSize, before: nextPageBefore),
      StreamOrder.oldestFirst => fetchPage(limit: pageSize, after: nextPageAfter),
    };

    if (page.isEmpty) {
      break;
    }

    final pageWithIds = [
      for (final entity in page) (id: extractId(entity), entity: entity),
    ];

    // Some endpoints return entities in the same order regardless of if before
    // or after were passed. Sort the entities according to our stream order to
    // fix this.
    // This could probably be made more efficient by assuming that endpoints
    // always return entities in either ascending or descending order, but for
    // now it's a good sanity check.
    if (order == StreamOrder.oldestFirst) {
      // Oldest first: ascending order.
      pageWithIds.sort((a, b) => a.id.compareTo(b.id));
    } else {
      // Most recent first: descending order.
      pageWithIds.sort((a, b) => -a.id.compareTo(b.id));
    }

    for (final (:id, :entity) in pageWithIds) {
      if (id.isBefore(before) && id.isAfter(after)) {
        yield entity;
      }
    }

    if (order == StreamOrder.oldestFirst) {
      nextPageAfter = pageWithIds.last.id;
    } else {
      nextPageBefore = pageWithIds.last.id;
    }

    // The extra == check isn't strictly necessary, but it saves us an API call
    // in the common case of setting `before` or `after` to an entity's ID.
    if (nextPageAfter.isAfter(before) || nextPageAfter == before) {
      break;
    }
    if (nextPageBefore.isBefore(after) || nextPageBefore == after) {
      break;
    }
  }
}

/// Extensions for streaming [Message]s.
extension StreamMessages on MessageManager {
  /// Same as [fetchMany], but has no limit on the number of messages returned.
  ///
  /// {@template paginated_endpoint_streaming_parameters}
  /// If [after] is set, only entities whose ID is after it will be returned.
  /// If [before] is set, only entities whose ID is before it will be returned.
  ///
  /// [pageSize] can be set to control the `limit` parameter of the underlying
  /// requests to the paginated endpoint. Most users will want to leave this
  /// unset and default to the maximum page size.
  /// {@endtemplate}
  ///
  /// {@template paginated_endpoint_order_parameters}
  /// [order] can be set to change the order in which entities are emitted on
  /// the returned stream. Entities will be emitted oldest first if it is not
  /// set, unless only [before] is provided, in which case entities will be
  /// emitted most recent first.
  /// {@endtemplate}
  Stream<Message> stream({
    Snowflake? before,
    Snowflake? after,
    int? pageSize,
    StreamOrder? order,
  }) =>
      _streamPaginatedEndpoint(
        fetchMany,
        extractId: (message) => message.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: order,
      );
}

// TODO: Add once nyxx 6.2.0 is out.
// extension StreamReactions on MessageManager {
//   Stream<User> streamReactions(Snowflake id, ReactionBuilder emoji, {Snowflake? after, Snowflake? before int? pageSize}) => _streamPaginatedEndpoint(
//         ({after, before, limit}) => fetchReactions(id, emoji, after: after, limit: limit),
//         extractId: (user) => user.id,
//         before: before,
//         after: after,
//         pageSize: pageSize,
//         order: StreamOrder.oldestFirst,
//       );
// }

// extension MessageStreamReactions on PartialMessage {
//   Stream<User> streamReactions(ReactionBuilder emoji, {Snowflake? after, Snowflake? before, int? pageSize}) =>
//       manager.streamReactions(id, emoji, after: after, before: before, pageSize: pageSize);
// }

/// Extensions for streaming [AuditLogEntry]s.
extension StreamAuditLogEntries on AuditLogManager {
  /// Same as [list], but has no limit on the number of entries returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  ///
  /// {@macro paginated_endpoint_order_parameters}
  Stream<AuditLogEntry> stream({
    Snowflake? userId,
    AuditLogEvent? type,
    Snowflake? before,
    Snowflake? after,
    int? pageSize,
    StreamOrder? order,
  }) =>
      _streamPaginatedEndpoint(
        ({after, before, limit}) => list(userId: userId, type: type, after: after, before: before, limit: limit),
        extractId: (entry) => entry.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: order,
      );
}

/// Extensions for streaming [ThreadMember]s.
extension StreamThreadMembers on ChannelManager {
  /// Same as [listThreadMembers], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<ThreadMember> streamThreadMembers(Snowflake id, {bool? withMembers, Snowflake? after, Snowflake? before, int? pageSize}) => _streamPaginatedEndpoint(
        ({after, before, limit}) => listThreadMembers(id, withMembers: withMembers, after: after, limit: limit),
        extractId: (member) => member.userId,
        before: before,
        after: after,
        pageSize: pageSize,
        order: StreamOrder.oldestFirst,
      );
}

/// Extensions for streaming [ThreadMember]s from a [Thread].
extension ThreadStreamThreadMembers on Thread {
  /// Same as [listThreadMembers], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<ThreadMember> streamThreadMembers({bool? withMembers, Snowflake? after, Snowflake? before, int? pageSize}) =>
      manager.streamThreadMembers(id, withMembers: withMembers, after: after, before: before, pageSize: pageSize);
}

/// Extensions for streaming [Entitlement]s.
extension StreamEntitlements on EntitlementManager {
  /// Same as [list], but has no limit on the number of entitlements returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  ///
  /// {@macro paginated_endpoint_order_parameters}
  Stream<Entitlement> stream({
    Snowflake? userId,
    List<Snowflake>? skuIds,
    Snowflake? before,
    Snowflake? after,
    int? pageSize,
    Snowflake? guildId,
    bool? excludeEnded,
    StreamOrder? order,
  }) =>
      _streamPaginatedEndpoint(
        ({after, before, limit}) => list(
          after: after,
          before: before,
          excludeEnded: excludeEnded,
          guildId: guildId,
          limit: limit,
          skuIds: skuIds,
          userId: userId,
        ),
        extractId: (entitlement) => entitlement.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: order,
      );
}

/// Extensions for streaming [Ban]s.
extension StreamBans on GuildManager {
  /// Same as [listBans], but has no limit on the number of bans returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<Ban> streamBans(Snowflake id, {Snowflake? after, Snowflake? before, int? pageSize}) => _streamPaginatedEndpoint(
        ({after, before, limit}) => listBans(id, after: after, before: before, limit: limit),
        extractId: (ban) => ban.user.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: StreamOrder.oldestFirst,
      );
}

/// Extensions for streaming [Ban]s from a [Guild].
extension GuildStreamBans on PartialGuild {
  /// Same as [listBans], but has no limit on the number of bans returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<Ban> streamBans({Snowflake? after, Snowflake? before, int? pageSize}) => manager.streamBans(id, after: after, before: before, pageSize: pageSize);
}

/// Extensions for streaming [Member]s.
extension StreamMembers on MemberManager {
  /// Same as [list], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<Member> stream({Snowflake? after, Snowflake? before, int? pageSize}) => _streamPaginatedEndpoint(
        ({after, before, limit}) => list(after: after, limit: limit),
        extractId: (member) => member.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: StreamOrder.oldestFirst,
      );
}

/// Extensions for streaming [ScheduledEvent]s.
extension StreamEventUsers on ScheduledEventManager {
  /// Same as [listEventUsers], but has no limit on the number of users returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  ///
  /// {@macro paginated_endpoint_order_parameters}
  Stream<ScheduledEventUser> streamEventUsers(Snowflake id, {bool? withMembers, Snowflake? before, Snowflake? after, int? pageSize, StreamOrder? order}) =>
      _streamPaginatedEndpoint(
        ({after, before, limit}) => listEventUsers(id, after: after, before: before, limit: limit, withMembers: withMembers),
        extractId: (user) => user.user.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: order,
      );
}

/// Extensions for streaming the current user's [Guild]s.
extension StreamCurrentUserGuilds on UserManager {
  /// Same as [listCurrentUserGuilds], but has no limit on the number of guilds returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  ///
  /// {@macro paginated_endpoint_order_parameters}
  Stream<PartialGuild> streamCurrentUserGuilds({Snowflake? after, Snowflake? before, bool? withCounts, int? pageSize, StreamOrder? order}) =>
      _streamPaginatedEndpoint(
        ({after, before, limit}) => listCurrentUserGuilds(after: after, before: before, limit: limit, withCounts: withCounts),
        extractId: (guild) => guild.id,
        before: before,
        after: after,
        pageSize: pageSize,
        order: order,
      );
}
