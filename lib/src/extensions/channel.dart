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
  CreateBuilder<T> toBuilder() {
    switch (type) {
      case ChannelType.guildText:
        var cast = this as GuildTextChannel;
        return GuildTextChannelBuilder(
          name: name,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          position: position,
          defaultAutoArchiveDuration: cast.defaultAutoArchiveDuration,
          isNsfw: isNsfw,
          parentId: parentId,
          rateLimitPerUser: cast.rateLimitPerUser,
          topic: cast.topic,
        ) as CreateBuilder<T>;
      case ChannelType.privateThread:
        var cast = this as PrivateThread;
        return ThreadBuilder.privateThread(
          name: name,
          autoArchiveDuration: cast.autoArchiveDuration,
          invitable: cast.isInvitable,
          rateLimitPerUser: cast.rateLimitPerUser,
        ) as CreateBuilder<T>;
      case ChannelType.publicThread:
        var cast = this as PublicThread;
        return ThreadBuilder.publicThread(
          name: name,
          autoArchiveDuration: cast.autoArchiveDuration,
          rateLimitPerUser: cast.rateLimitPerUser,
        ) as CreateBuilder<T>;
      case ChannelType.guildCategory:
        return GuildCategoryBuilder(
          name: name,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          position: position,
        ) as CreateBuilder<T>;
      case ChannelType.guildVoice:
        var cast = this as GuildVoiceChannel;
        return GuildVoiceChannelBuilder(
          name: name,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          position: position,
          isNsfw: isNsfw,
          parentId: parentId,
          bitRate: cast.bitrate,
          rtcRegion: cast.rtcRegion,
          userLimit: cast.userLimit,
          videoQualityMode: cast.videoQualityMode,
        ) as CreateBuilder<T>;
      case ChannelType.guildAnnouncement:
        var cast = this as GuildAnnouncementChannel;
        return GuildAnnouncementChannelBuilder(
          name: name,
          defaultAutoArchiveDuration: cast.defaultAutoArchiveDuration,
          isNsfw: isNsfw,
          parentId: parentId,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          position: position,
          topic: cast.topic,
        ) as CreateBuilder<T>;
      case ChannelType.guildStageVoice:
        var cast = this as GuildStageChannel;
        return GuildStageChannelBuilder(
          name: name,
          bitRate: cast.bitrate,
          isNsfw: isNsfw,
          parentId: parentId,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
          position: position,
          rtcRegion: cast.rtcRegion,
          userLimit: cast.userLimit,
          videoQualityMode: cast.videoQualityMode,
        ) as CreateBuilder<T>;
      default:
        return GuildChannelBuilder(
          name: name,
          type: type,
          position: position,
          permissionOverwrites: permissionOverwrites.map((e) => PermissionOverwriteBuilder(id: e.id, type: e.type, allow: e.allow, deny: e.deny)).toList(),
        );
    }
  }
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
