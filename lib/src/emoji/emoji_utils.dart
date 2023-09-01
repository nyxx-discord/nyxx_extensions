import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/nyxx_extensions.dart';

List<EmojiDefinition> _emojisCache = [];

Future<RawApiMap> _downloadEmojiData() async {
  final request = http.Request("GET", emojiDataUri);
  final requestBody = await (await request.send()).stream.bytesToString();

  return jsonDecode(requestBody) as RawApiMap;
}

/// Emoji definitions uri
final Uri emojiDataUri = Uri.parse("https://emzi0767.gl-pages.emzi0767.dev/discord-emoji/discordEmojiMap.min.json");

/// Returns emoji based on given [predicate]. Allows to cache results via [cache] parameter.
Stream<EmojiDefinition> filterEmojiDefinitions(bool Function(EmojiDefinition) predicate, {bool cache = false}) =>
    getAllEmojiDefinitions(cache: cache).where(predicate);

/// Returns all possible [EmojiDefinition]s. Allows to cache results via [cache] parameter.
/// If emojis are cached it will resolve immediately with result.
Stream<EmojiDefinition> getAllEmojiDefinitions({bool cache = false}) async* {
  if (_emojisCache.isNotEmpty) {
    yield* Stream.fromIterable(_emojisCache);
  }

  final rawData = await _downloadEmojiData();

  for (final emojiDefinition in rawData["emojiDefinitions"]) {
    final definition = EmojiDefinition(emojiDefinition as RawApiMap);

    if (cache) {
      _emojisCache.add(definition);
    }

    yield definition;
  }
}
