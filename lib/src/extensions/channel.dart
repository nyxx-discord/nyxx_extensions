import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/managers/channel_manager.dart';
import 'package:nyxx_extensions/src/utils/formatters.dart';
import 'package:nyxx_extensions/src/utils/permissions.dart';

/// Extensions on [PartialChannel]s.
extension PartialChannelExtensions on PartialChannel {
  /// A mention of this channel.
  String get mention => channelMention(id);
}

/// Extensions on [Channel]s.
extension ChannelExtensions on Channel {
  /// A URL clients can visit to navigate to this channel.
  Uri get url => Uri.https(manager.client.apiOptions.host, '/channels/${this is GuildChannel ? '${(this as GuildChannel).guildId}' : '@me'}/$id');
}

/// Extensions on [GuildChannel]s.
extension GuildChannelExtensions on GuildChannel {
  /// Compute [member]'s permissions in this channel.
  ///
  /// {@macro compute_permissions_detail}
  Future<Permissions> computePermissionsFor(PartialMember member) async => await computePermissions(this, await member.get());
}

/// Extensions on [Thread]s.
extension ThreadExtensions on Thread {
  /// Same as [listThreadMembers], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<ThreadMember> streamThreadMembers({bool? withMembers, Snowflake? after, Snowflake? before, int? pageSize}) =>
      manager.streamThreadMembers(id, withMembers: withMembers, after: after, before: before, pageSize: pageSize);
}
