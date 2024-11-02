import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';

/// Extensions on [PartialApplication]s.
extension PartialApplicationExtensions on PartialApplication {
  /// Get a URL users can visit to add this bot to a guild.
  Uri getInviteUri({
    List<String> scopes = const ['bot', 'applications.commands'],
    Flags<Permissions>? permissions,
    Snowflake? guildId,
    bool? disableGuildSelect,
  }) =>
      Uri.https(
        'discord.com',
        '/oauth2/authorize',
        {
          'client_id': id.toString(),
          'scope': scopes.join(' '),
          if (permissions != null) 'permissions': permissions.value.toString(),
          if (guildId != null) 'guild_id': guildId.toString(),
          if (disableGuildSelect != null) 'disable_guild_select': disableGuildSelect,
        },
      );
}

extension ApplicationExtensions on Application {
  /// The URL of this application's icon image.
  Uri? iconUrl({CdnFormat? format, int? size}) => icon?.get(format: format, size: size);

  /// The URL of this application's cover image.
  Uri? coverUrl({CdnFormat? format, int? size}) => coverImage?.get(format: format, size: size);
}
