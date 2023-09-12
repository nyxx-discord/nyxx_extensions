import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/channel.dart';

extension MessageUtils on Message {
  /// A URL clients can visit to navigate to this message.
  Uri get url => Uri.https(manager.client.apiOptions.host, '${channel.url.path}/$id');
}
