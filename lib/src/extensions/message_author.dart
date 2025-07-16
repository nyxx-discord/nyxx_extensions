import 'package:nyxx/nyxx.dart';

/// Extensions on [MessageAuthor].
extension MessageAuthorExtensions on MessageAuthor {
  /// Whether this author is a bot.
  ///
  /// For [User]s, this returns the same as [User.isBot]. For [WebhookAuthor]s, this returns `true`.
  bool get isBot => switch (this) {
        User(:final isBot) => isBot,
        _ => true,
      };
}
