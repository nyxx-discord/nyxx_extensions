import 'package:nyxx/nyxx.dart';

extension GuildExtension on Guild {
  /// The acronym of the guild if no icon is chosen.
  String get acronym {
    return name.replaceAll(r"'s ", ' ').replaceAllMapped(RegExp(r'\w+'), (match) => match[0]![0]).replaceAll(RegExp(r'\s'), '');
  }

  /// A URL clients can visit to navigate to this guild.
  Uri get url => Uri.https(manager.client.apiOptions.host, '/channels/$id');
}
