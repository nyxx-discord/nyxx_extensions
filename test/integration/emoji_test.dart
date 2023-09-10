import 'package:nyxx_extensions/nyxx_extensions.dart';
import 'package:test/test.dart';

void main() {
  test('getEmojiDefinitions', () async {
    final emojis = await getEmojiDefinitions();

    expect(emojis, isNotEmpty);
  });
}
