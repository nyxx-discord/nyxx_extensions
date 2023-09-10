import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';

import 'package:nyxx/src/utils/to_string_helper/to_string_helper.dart';
import 'package:nyxx/src/utils/parsing_helpers.dart';

/// {@template emoji_definition}
/// Information about a text emoji.
/// {@endtemplate}
class EmojiDefinition with ToStringHelper {
  /// The primary name of this emoji.
  final String primaryName;

  /// A list of all the names of this emoji.
  final List<String> names;

  /// The surrogates (string) that make up this emoji.
  final String surrogates;

  /// The UTF-32 codepoints that make up this emoji.
  final List<int> utf32Codepoints;

  /// The filename of the asset containing this emoji's image.
  final String assetFilename;

  /// The URI to this emoji's asset image.
  final Uri assetUrl;

  /// The category this emoji belongs to.
  final String category;

  /// An alternate representation of this emoji.
  final String? alternateSurrogates;

  /// Alternate UTF-32 codepoints for this emoji.
  final List<int>? alternateUtf32Codepoints;

  /// {@macro emoji_definition}
  EmojiDefinition({
    required this.primaryName,
    required this.names,
    required this.surrogates,
    required this.utf32Codepoints,
    required this.assetFilename,
    required this.assetUrl,
    required this.category,
    required this.alternateSurrogates,
    required this.alternateUtf32Codepoints,
  });
}

/// Extensions relating to [EmojiDefinition]s on [TextEmoji].
extension TextEmojiDefinition on TextEmoji {
  /// Get the definition of this emoji.
  Future<EmojiDefinition> getDefinition() async =>
      (await getEmojiDefinitions()).singleWhere((definition) => definition.surrogates == name || definition.alternateSurrogates == name);
}

/// Extensions relating to [EmojiDefinition]s on [NyxxRest].
extension NyxxEmojiDefinitions on NyxxRest {
  /// List all the text emoji available to this client.
  Future<List<TextEmoji>> getTextEmojis() async => (await getEmojiDefinitions())
      .map((definition) => TextEmoji(id: Snowflake.zero, manager: guilds[Snowflake.zero].emojis, name: definition.surrogates))
      .toList();

  /// Get a text emoji by name.
  TextEmoji getTextEmoji(String name) => TextEmoji(id: Snowflake.zero, manager: guilds[Snowflake.zero].emojis, name: name);
}

final _emojiDefinitionsUrl = Uri.parse("https://emzi0767.gl-pages.emzi0767.dev/discord-emoji/discordEmojiMap.min.json");
List<EmojiDefinition>? _cachedEmojiDefinitions;
DateTime? _cachedAt;

/// List all the emoji definitions currently available.
///
/// This method caches results for 4 hours.
Future<List<EmojiDefinition>> getEmojiDefinitions() async {
  if (_cachedEmojiDefinitions != null && _cachedAt!.add(Duration(hours: 4)).isAfter(DateTime.timestamp())) {
    return _cachedEmojiDefinitions!;
  } else {
    final response = await http.get(_emojiDefinitionsUrl);
    final data = jsonDecode(response.body)['emojiDefinitions'];

    _cachedAt = DateTime.timestamp();
    return _cachedEmojiDefinitions = [
      for (final raw in data)
        EmojiDefinition(
          primaryName: raw['primaryName'] as String,
          names: parseMany(raw['names']),
          surrogates: raw['surrogates'] as String,
          utf32Codepoints: parseMany(raw['utf32codepoints']),
          assetFilename: raw['assetFileName'] as String,
          assetUrl: Uri.parse(raw['assetUrl']),
          category: raw['category'] as String,
          alternateSurrogates: raw['alternativeSurrogates'] as String?,
          alternateUtf32Codepoints: maybeParseMany(raw['alternativeUtf32codepoints']),
        ),
    ];
  }
}
