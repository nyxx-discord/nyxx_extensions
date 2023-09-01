import 'package:nyxx/nyxx.dart';

/// Wrapper class around discords emojis data
class EmojiDefinition {
  /// Name of emoji
  late final String primaryName;

  /// List of alternative names of emoji
  late final Iterable<String> names;

  /// Literal emoji
  late final String rawEmoji;

  /// List of utf32 code points
  late final Iterable<int> codePoints;

  /// Name of asset used in discords frontend for this emoji
  late final String assetFileName;

  /// Url of emoji picture
  late final String assetUrl;

  EmojiDefinition(RawApiMap raw) {
    primaryName = raw["primaryName"] as String;
    names = (raw["names"] as Iterable<dynamic>).cast();
    rawEmoji = raw["surrogates"] as String;
    codePoints = (raw["utf32codepoints"] as Iterable<dynamic>).cast();
    assetFileName = raw["assetFileName"] as String;
    assetUrl = raw["assetUrl"] as String;
  }

  /// Returns [UnicodeEmoji] object of this
  UnicodeEmoji toEmoji() => UnicodeEmoji(rawEmoji);
}
