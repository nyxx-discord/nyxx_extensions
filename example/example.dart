import "dart:io";

import "package:nyxx/nyxx.dart";
import "package:nyxx_extensions/nyxx_extensions.dart";

void main() async {
  final client = await Nyxx.connectGateway(Platform.environment['TOKEN']!, GatewayIntents.guildMessages | GatewayIntents.messageContent);

  // Get an emoji by its unicode character...
  final heartEmoji = client.getTextEmoji('❤️');

  // ...or list all available emojis
  final allEmojis = await client.getTextEmojis();
  print('There are currently ${allEmojis.length} emojis!');

  // Get information about a text emoji!
  final heartEmojiInformation = await heartEmoji.getDefinition();
  print('The primary name of ${heartEmojiInformation.surrogates} is ${heartEmojiInformation.primaryName}');

  // Sanitizing content makes it safe to send to Discord without triggering any mentions
  client.onMessageCreate.listen((event) async {
    if (event.message.content.startsWith('!sanitize')) {
      event.message.channel.sendMessage(MessageBuilder(
        content: 'Sanitized content: ${await sanitizeContent(event.message.content, channel: event.message.channel)}',
      ));
    }
  });

  // ...and more!
}
