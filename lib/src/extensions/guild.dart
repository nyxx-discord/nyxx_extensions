import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/managers/guild_manager.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';

/// Extensions on [PartialGuild]s.
extension PartialGuildExtensions on PartialGuild {
  /// A URL clients can visit to navigate to this guild.
  Uri get url => Uri.https(manager.client.apiOptions.host, '/guilds/$id');

  /// Same as [listBans], but has no limit on the number of bans returned.
  ///
  /// {@macro paginated_endpoint_streaming_parameters}
  Stream<Ban> streamBans({Snowflake? after, Snowflake? before, int? pageSize}) => manager.streamBans(id, after: after, before: before, pageSize: pageSize);

  /// Return a list of channels in the client's cache that are in this guild.
  List<GuildChannel> get cachedChannels => manager.client.channels.cache.values.whereType<GuildChannel>().where((element) => element.guildId == id).toList();

  /// The date this guild was created at.
  DateTime get createdAt => id.timestamp;
}

/// Extensions on [Guild]s.
extension GuildExtensions on Guild {
  /// The acronym of the guild if no icon is chosen.
  String get acronym {
    return name.replaceAll(r"'s ", ' ').replaceAllMapped(RegExp(r'\w+'), (match) => match[0]![0]).replaceAll(RegExp(r'\s'), '');
  }

  /// The URL of this guild's icon image.
  Uri? iconUrl({CdnFormat? format, int? size}) => icon?.get(format: format, size: size);

  /// The URL of this guild's banner image.
  Uri? bannerUrl({CdnFormat? format, int? size}) => banner?.get(format: format, size: size);

  /// The URL of this guild's splash image.
  Uri? splashUrl({CdnFormat? format, int? size}) => splash?.get(format: format, size: size);

  /// The URL of this guild's discovery splash image.
  Uri? discoverySplashUrl({CdnFormat? format, int? size}) => discoverySplash?.get(format: format, size: size);
}
