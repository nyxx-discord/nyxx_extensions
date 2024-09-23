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

/// Extensions on [List]s of [Role]s.
extension RoleList on List<Role> {
  /// Compare two [Role]s by their positions.
  static int compare(Role a, Role b) {
    final position = a.position.compareTo(b.position);
    if (position != 0) return position;

    return a.id.compareTo(b.id);
  }

  /// The highest role in this list.
  Role get highest => reduce((a, b) => compare(a, b) < 0 ? b : a);

  /// The roles in this list, sorted from lowest to highest.
  List<Role> get sorted => List.of(this)..sort(compare);
}
