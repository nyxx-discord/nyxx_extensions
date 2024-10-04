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
}

/// Extensions on all [GuildChannel] types
extension GuildChannelsExtension<T extends GuildChannel> on T {
  /// Create a builder with the properties of this channel
  GuildChannelBuilder<T> toBuilder() => switch (this) {
        GuildTextChannel channel => GuildTextChannelBuilder(
            name: channel.name,
            defaultAutoArchiveDuration: channel.defaultAutoArchiveDuration,
            isNsfw: channel.isNsfw,
            parentId: channel.parentId,
            permissionOverwrites: channel.permissionOverwrites
                .map((e) => PermissionOverwriteBuilder(
                      id: e.id,
                      type: e.type,
                      allow: e.allow,
                      deny: e.deny,
                    ))
                .toList(),
            position: channel.position,
            rateLimitPerUser: channel.rateLimitPerUser,
            topic: channel.topic,
          ) as GuildChannelBuilder<T>,
        GuildVoiceChannel channel => GuildVoiceChannelBuilder(
            name: channel.name,
            permissionOverwrites:
                channel.permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
            position: channel.position,
            isNsfw: channel.isNsfw,
            parentId: channel.parentId,
            bitRate: channel.bitrate,
            rtcRegion: channel.rtcRegion,
            userLimit: channel.userLimit,
            videoQualityMode: channel.videoQualityMode,
          ) as GuildChannelBuilder<T>,
        GuildStageChannel channel => GuildStageChannelBuilder(
            name: channel.name,
            bitRate: channel.bitrate,
            isNsfw: channel.isNsfw,
            parentId: channel.parentId,
            permissionOverwrites:
                channel.permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
            position: channel.position,
            rtcRegion: channel.rtcRegion,
            userLimit: channel.userLimit,
            videoQualityMode: channel.videoQualityMode,
          ) as GuildChannelBuilder<T>,
        PrivateThread thread => ThreadBuilder.privateThread(
            name: thread.name,
            autoArchiveDuration: thread.autoArchiveDuration,
            invitable: thread.isInvitable,
            rateLimitPerUser: thread.rateLimitPerUser,
          ) as GuildChannelBuilder<T>,
        PublicThread thread => ThreadBuilder.publicThread(
            name: thread.name,
            autoArchiveDuration: thread.autoArchiveDuration,
            rateLimitPerUser: thread.rateLimitPerUser,
          ) as GuildChannelBuilder<T>,
        GuildCategory category => GuildCategoryBuilder(
            name: category.name,
            permissionOverwrites:
                category.permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
            position: category.position,
          ) as GuildChannelBuilder<T>,
        GuildAnnouncementChannel channel => GuildAnnouncementChannelBuilder(
            name: channel.name,
            defaultAutoArchiveDuration: channel.defaultAutoArchiveDuration,
            isNsfw: channel.isNsfw,
            parentId: channel.parentId,
            permissionOverwrites:
                channel.permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
            position: channel.position,
            topic: channel.topic,
          ) as GuildChannelBuilder<T>,
        _ => GuildChannelBuilder(
            name: name,
            type: type,
            position: position,
            permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          ),
      };
}

/// Extensions on [Thread]s.
extension ThreadExtensions on Thread {
  /// Same as [listThreadMembers], but has no limit on the number of members returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<ThreadMember> streamThreadMembers({bool? withMembers, Snowflake? after, Snowflake? before, int? pageSize}) =>
      manager.streamThreadMembers(id, withMembers: withMembers, after: after, before: before, pageSize: pageSize);
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
}
