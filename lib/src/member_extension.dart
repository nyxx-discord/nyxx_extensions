import "package:nyxx/nyxx.dart";

/// Collection of extensions for [Member]
extension MemberExtension on User {
  /// Fetches all mutual guilds for [User] that bot has access to.
  /// Note it will try to download users via REST api so bot could get rate limited.
  Future<Map<Guild, Member>> fetchMutualGuilds() async {
    final result = <Guild, Member>{};

    for (final guild in client.guilds.values) {
      try {
        final member = guild.members[id] ?? await guild.fetchMember(id);

        result[guild] = member;
        // ignore: empty_catches
      } on Exception {}
    }

    return result;
  }
}
