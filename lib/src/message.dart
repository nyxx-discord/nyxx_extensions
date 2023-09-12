import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/channel.dart';

extension MessageUtils on Message {
  /// A URL clients can visit to navigate to this message.
  Future<Uri> get url async => Uri.https(manager.client.apiOptions.host, '${(await channel.get()).url.path}/$id');
}
