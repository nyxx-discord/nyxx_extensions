import "package:nyxx/nyxx.dart";

/// Collection of extensions for [EmbedFieldBuilder]
extension EmbedFieldBuilderJson on EmbedFieldBuilder {
  /// Returns a [EmbedFieldBuilder] with data from the raw json
  EmbedFieldBuilder importJson(RawApiMap raw) {
    name = raw["name"];
    content = raw["value"];
    inline = raw["inline"] as bool?;
    return this;
  }
}

/// Collection of extensions for [EmbedFooterBuilder]
extension EmbedFooterBuilderJson on EmbedFooterBuilder {
  /// Returns a [EmbedFooterBuilder] with data from the raw json
  EmbedFooterBuilder importJson(Map<String, String?> raw) {
    text = raw["text"];
    iconUrl = raw["icon_url"];
    return this;
  }
}

/// Collection of extensions for [EmbedAuthorBuilder]
extension EmbedAuthorBuilderJson on EmbedAuthorBuilder {
  /// Returns a [EmbedAuthorBuilder] with data from the raw json
  EmbedAuthorBuilder importJson(Map<String, String?> raw) {
    name = raw["name"];
    url = raw["url"];
    iconUrl = raw["icon_url"];
    return this;
  }
}

/// Collection of extensions for [EmbedBuilder]
extension EmbedBuilderJson on EmbedBuilder {
  /// Returns a [EmbedBuilder] with data from the raw json
  EmbedBuilder importJson(RawApiMap raw) {
    title = raw["title"] as String?;
    description = raw["description"] as String?;
    url = raw["url"] as String?;
    color = raw["color"] != null ? DiscordColor.fromInt(raw["color"] as int) : null;
    timestamp = raw["timestamp"] != null ? DateTime.parse(raw["timestamp"] as String) : null;
    footer = raw["footer"] != null ? EmbedFooterBuilder().importJson(raw["footer"] as Map<String, String?>) : null;
    imageUrl = raw["image"]["url"] as String?;
    thumbnailUrl = raw["thumbnail"]["url"] as String?;
    author = raw["author"] != null ? EmbedAuthorBuilder().importJson(raw["author"] as Map<String, String?>) : null;

    for (final rawFields in raw["fields"] as List<dynamic>) {
      fields.add(EmbedFieldBuilder().importJson(rawFields as RawApiMap));
    }

    return this;
  }
}
