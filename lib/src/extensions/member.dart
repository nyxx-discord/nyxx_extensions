import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/utils/permissions.dart';

/// Extensions on [PartialMember]s.
extension PartialMemberExtensions on PartialMember {
  /// Compute this member's permissions in [channel].
  ///
  /// {@macro compute_permissions_detail}
  Future<Permissions> computePermissionsIn(GuildChannel channel) async => await computePermissions(channel, await get());
}
