import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/guild.dart';
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

  /// Create a builder with the properties of this channel
  GuildChannelBuilder toBuilder() => GuildChannelBuilder(
      name: name,
      type: type,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList());
}

/// Extensions on [Thread]s.
extension ThreadExtensions on Thread {
  /// Same as [listThreadMembers], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<ThreadMember> streamThreadMembers({bool? withMembers, Snowflake? after, Snowflake? before, int? pageSize}) =>
      manager.streamThreadMembers(id, withMembers: withMembers, after: after, before: before, pageSize: pageSize);

  /// Create a builder with the properties of this thread
  ThreadBuilder toBuilder() => ThreadBuilder(name: name, type: type, autoArchiveDuration: autoArchiveDuration, rateLimitPerUser: rateLimitPerUser);
}

/// Extensions on [GuildCategory]s.
extension GuildCategoryExtensions on GuildCategory {
  /// Fetch the channels in this category.
  Future<List<GuildChannel>> fetchChannels() async {
    final guildChannels = await guild.fetchChannels();

    return guildChannels.where((element) => element.parentId == id).toList();
  }

  /// Return a list of channels in the client's cache that are in this category.
  List<GuildChannel> get cachedChannels => guild.cachedChannels.where((element) => element.parentId == id).toList();

  /// Create a builder with the properties of this category
  GuildCategoryBuilder toBuilder() => GuildCategoryBuilder(
      name: name,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
      position: position);
}

/// Extensions on [GuildTextChannel]s.
extension GuildTextChannelExtensions on GuildTextChannel {
  /// Create a builder with the properties of this channel
  GuildTextChannelBuilder toBuilder() => GuildTextChannelBuilder(
      name: name,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
      position: position,
      defaultAutoArchiveDuration: defaultAutoArchiveDuration,
      isNsfw: isNsfw,
      parentId: parentId,
      rateLimitPerUser: rateLimitPerUser,
      topic: topic);
}

/// Extensions on [GuildVoiceChannel]s.
extension GuildVoiceChannelExtensions on GuildVoiceChannel {
  /// Create a builder with the properties of this channel
  GuildVoiceChannelBuilder toBuilder() => GuildVoiceChannelBuilder(
      name: name,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
      position: position,
      isNsfw: isNsfw,
      parentId: parentId,
      bitRate: bitrate,
      rtcRegion: rtcRegion,
      userLimit: userLimit,
      videoQualityMode: videoQualityMode);
}

/// Extensions on [GuildAnnouncementChannel]s.
extension GuildAnnouncementChannelExtensions on GuildAnnouncementChannel {
  /// Create a builder with the properties of this channel
  GuildAnnouncementChannelBuilder toBuilder() => GuildAnnouncementChannelBuilder(
      name: name,
      defaultAutoArchiveDuration: defaultAutoArchiveDuration,
      isNsfw: isNsfw,
      parentId: parentId,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
      position: position,
      topic: topic);
}

extension Test on GuildStageChannel {
  /// Create a builder with the properties of this channel
  GuildStageChannelBuilder toBuilder() => GuildStageChannelBuilder(
      name: name,
      bitRate: bitrate,
      isNsfw: isNsfw,
      parentId: parentId,
      permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
      position: position,
      rtcRegion: rtcRegion,
      userLimit: userLimit,
      videoQualityMode: videoQualityMode);
}
