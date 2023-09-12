import 'package:nyxx/nyxx.dart';

extension EmbedExtension on Embed {
  EmbedBuilder toEmbedBuilder() {
    return EmbedBuilder(
      author: author._toEmbedAuthorBuilder(),
      color: color,
      description: description,
      fields: fields?.map((field) => field._toEmbedFieldBuilder()).toList(),
      footer: footer._toEmbedFooterBuilder(),
      image: image._toEmbedImageBuilder(),
      thumbnail: thumbnail._toEmbedThumbnailBuilder(),
      timestamp: timestamp,
      title: title,
      url: url,
    );
  }
}

extension on EmbedAuthor? {
  EmbedAuthorBuilder? _toEmbedAuthorBuilder() {
    return switch (this) {
      EmbedAuthor(:final name, :final iconUrl?, :final url?) =>
        EmbedAuthorBuilder(
          name: name,
          iconUrl: iconUrl,
          url: url,
        ),
      _ => null,
    };
  }
}

extension on EmbedField {
  EmbedFieldBuilder _toEmbedFieldBuilder() =>
      EmbedFieldBuilder(name: name, value: value, isInline: inline);
}

extension on EmbedFooter? {
  EmbedFooterBuilder? _toEmbedFooterBuilder() {
    return switch (this) {
      EmbedFooter(:final text, :final iconUrl?) => EmbedFooterBuilder(
          text: text,
          iconUrl: iconUrl,
        ),
      _ => null,
    };
  }
}

extension on EmbedImage? {
  EmbedImageBuilder? _toEmbedImageBuilder() {
    return switch (this) {
      EmbedImage(:final url) => EmbedImageBuilder(
          url: url,
        ),
      _ => null,
    };
  }
}

extension on EmbedThumbnail? {
  EmbedThumbnailBuilder? _toEmbedThumbnailBuilder() {
    return switch (this) {
      EmbedThumbnail(:final url) => EmbedThumbnailBuilder(
          url: url,
        ),
      _ => null,
    };
  }
}
