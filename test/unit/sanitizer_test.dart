import 'package:mockito/mockito.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:test/test.dart';

const _whitespaceCharacter = "‎";

final sampleContent =
    '<@1234> test <@!2345> test2 <@&3456> test3 <#4567> test4 <a:test_emoji:5678> test5 <:test_emoji:6789> test6 </test command:123456789123456789> test7 <https://dart.dev>';
final removed = ' test  test2  test3  test4  test5  test6  test7 ';
final sanitized =
    '<@${_whitespaceCharacter}1234> test <@${_whitespaceCharacter}2345> test2 <@&${_whitespaceCharacter}3456> test3 <#${_whitespaceCharacter}4567> test4 <${_whitespaceCharacter}a\\:test_emoji\\:5678> test5 <$_whitespaceCharacter\\:test_emoji\\:6789> test6 </${_whitespaceCharacter}test command:123456789123456789> test7 <<https://dart.dev>>';

class MockNyxxRest with Mock implements NyxxRest {}

class MockChannelManager with Mock implements ChannelManager {
  @override
  NyxxRest get client => MockNyxxRest();
}

class MockTextChannel with Mock implements TextChannel {
  @override
  ChannelManager get manager => MockChannelManager();

  @override
  Future<Channel> get() async => this;
}

void main() {
  group('sanitizeContent', () {
    final channel = MockTextChannel();

    test(
      'ignore',
      () async => expect(await sanitizeContent(sampleContent, channel: channel, action: SanitizerAction.ignore), equals(sampleContent)),
    );

    test(
      'remove',
      () async => expect(await sanitizeContent(sampleContent, channel: channel, action: SanitizerAction.remove), equals(removed)),
    );

    test(
      'sanitize',
      () async => expect(await sanitizeContent(sampleContent, channel: channel, action: SanitizerAction.sanitize), equals(sanitized)),
    );
  });
}
