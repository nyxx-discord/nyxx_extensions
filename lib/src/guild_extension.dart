import 'package:nyxx/nyxx.dart';

extension GuildExtension on IGuild {
  /// The acronym of the guild if no icon is chosen.
  String get acronym {
    return name.replaceAll(r"'s ", '').replaceAllMapped(r'\w+', (match) => match.group(0)!).replaceAll(r'\s', '');
  }
}
