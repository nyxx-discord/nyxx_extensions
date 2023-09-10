import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:test/test.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

void main() {
  final testToken = Platform.environment['TEST_TOKEN'];
  final testGuild = Platform.environment['TEST_GUILD'];

  test(
    'fetchMutualGuilds',
    skip: testToken == null
        ? 'No token provided'
        : testGuild == null
            ? 'No test guild provided'
            : false,
    () async {
      final client = await Nyxx.connectRest(testToken!);

      // Populate guild in cache.
      await client.guilds.fetch(Snowflake.parse(testGuild!));
      final self = await client.users.fetchCurrentUser();

      final mutualGuilds = await self.fetchMutualGuilds();

      expect(mutualGuilds, isNotEmpty);
    },
  );
}
