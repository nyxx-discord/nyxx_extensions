import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/utils/permissions.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';

/// Extensions on [PartialMember]s.
extension PartialMemberExtensions on PartialMember {
  /// Compute this member's permissions in [channel].
  ///
  /// {@macro compute_permissions_detail}
  Future<Permissions> computePermissionsIn(GuildChannel channel) async => await computePermissions(channel, await get());

  /// Kick this member from the guild.
  ///
  /// External references:
  ///
  /// - [MemberManager.delete]
  /// - Discord API Reference: https://discord.com/developers/docs/resources/guild#remove-guild-member
  Future<void> kick({String? auditLogReason}) => delete(auditLogReason: auditLogReason);
}

extension MemberExtensions on Member {
  /// The URL of this member's avatar decoration.
  // Same as in UserExtensions.
  Uri? get avatarDecorationUrl => avatarDecoration?.get(format: CdnFormat.png);
}
