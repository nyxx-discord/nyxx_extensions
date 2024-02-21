import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/utils/formatters.dart';

/// Extensions on [PartialRole]s.
extension PartialRoleExtensions on PartialRole {
  /// A mention of this role.
  String get mention {
    if (id == manager.guildId) {
      return '@everyone';
    }

    return roleMention(id);
  }
}
