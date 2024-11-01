import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/utils/emoji.dart';

/// Extensions on [TextEmoji].
extension TextEmojiExtensions on TextEmoji {
  /// Get the definition of this emoji.
  Future<EmojiDefinition> getDefinition() async => (await getEmojiDefinitions())
      .singleWhere((definition) => definition.surrogates == name || definition.alternateSurrogates == name);
}
