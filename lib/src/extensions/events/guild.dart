import 'package:nyxx/nyxx.dart';

extension GuildDeleteEventExtensions on GuildDeleteEvent {
  /// Whether the client was removed from the guild, due to a ban or kick.
  bool get wasRemoved => isUnavailable == false;
}
