import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';
import 'package:nyxx_extensions/src/utils/formatters.dart';

/// Extensions on [PartialUser].
extension PartialUserExtensions on PartialUser {
  /// Fetch all the mutual guilds the client shares with this user.
  ///
  /// Returns a mapping of the guilds the client and this user share mapped to this user's member in each guild.
  ///
  /// This method only operates on guilds in the client's cache.
  Future<Map<Guild, Member>> fetchMutualGuilds() async {
    final result = <Guild, Member>{};

    for (final guild in List.of(manager.client.guilds.cache.values)) {
      try {
        result[guild] = await guild.members[id].get();
      } on HttpResponseError {
        // Member was not found in the guild
      }
    }

    return result;
  }

  /// A URL clients can visit to open the user's profile.
  Uri get url => Uri.https(manager.client.apiOptions.host, '/users/$id');

  /// A mention of this user.
  String get mention => userMention(id);

  /// Returns when the user was created.
  DateTime get createdAt => id.timestamp;
}

extension UserExtensions on User {
  /// The user's unique username, if migrated, else a combination of their username and discriminator.
  String get tag => discriminator == '0' ? username : '$username#$discriminator';

  /// The URL of this user's avatar image.
  Uri avatarUrl({CdnFormat? format, int? size}) => avatar.get(format: format, size: size);

  /// The URL of this user's banner image.
  Uri? bannerUrl({CdnFormat? format, int? size}) => banner?.get(format: format, size: size);

  /// The URL of this user's default avatar image.
  Uri get defaultAvatarUrl => defaultAvatar.url;

  /// The URL of this user's avatar decoration.
  // Forcefully add the `.png` extension, otherwise it's converted as a GIF if the hash starts with `a_`, and GIFs are not supported.
  Uri? get avatarDecorationUrl => avatarDecoration?.get(format: CdnFormat.png);
}
