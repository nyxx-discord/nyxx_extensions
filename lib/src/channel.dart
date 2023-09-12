import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/utils/formatters.dart';

extension PartialChannelUtils on PartialChannel {
  /// A mention of this channel.
  String get mention => channelMention(id);
}

extension ChannelUtils on Channel {
  /// A URL clients can visit to navigate to this channel.
  Uri get url => Uri.https(manager.client.apiOptions.host, '/channels/${this is GuildChannel ? '${(this as GuildChannel).guildId}' : '@me'}/$id');
}
