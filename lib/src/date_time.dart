import 'package:nyxx_extensions/src/utils/formatters.dart';

extension TimestampStyleDateTime on DateTime {
  /// Formats the [DateTime] into a date string timestamp.
  String format([TimestampStyle style = TimestampStyle.none]) => formatDate(this, style);
}

extension TimestampStyleDuration on Duration {
  /// Formats the [Duration] into a date string timestamp.
  /// The style will always be relative to represent as a duration on Discord.
  String format() => formatDate(DateTime.now().add(this), TimestampStyle.relativeTime);
}
