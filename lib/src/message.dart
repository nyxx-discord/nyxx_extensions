import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/channel.dart';

extension MessageUtils on Message {
  /// A URL clients can visit to navigate to this message.
  Future<Uri> get url async => Uri.https(manager.client.apiOptions.host, '${(await channel.get()).url.path}/$id');

  /// Sends a reply to the message.
  Future<Message> sendReply(MessageBuilder builder) {
    final copiedBuilder = MessageBuilder(
      allowedMentions: builder.allowedMentions,
      attachments: builder.attachments,
      components: builder.components,
      content: builder.content,
      embeds: builder.embeds,
      nonce: builder.nonce,
      replyId: id,
      requireReplyToExist: builder.requireReplyToExist,
      stickerIds: builder.stickerIds,
      suppressEmbeds: builder.suppressEmbeds,
      suppressNotifications: builder.suppressNotifications,
      tts: builder.tts,
    );

    return channel.sendMessage(copiedBuilder);
  }
}
