import 'package:nyxx/nyxx.dart';
import 'package:nyxx_extensions/src/extensions/cdn_asset.dart';

extension TeamExtensions on Team {
  /// Returns the URL of the team's icon.
  Uri? iconUrl({CdnFormat? format, int? size}) => icon?.get(format: format, size: size);
}
