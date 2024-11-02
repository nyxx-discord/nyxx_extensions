import 'package:nyxx/nyxx.dart';

const mediaProxyUrl = 'https://media.discordapp.net';

extension ActivityAssetsExtension on Activity {
  Uri? assetsLargeImageUrl({CdnFormat? format}) {
    if (assets?.largeImage == null || applicationId == null) {
      return null;
    }

    return parseAssetUrl(assets!.largeImage!, applicationId!, format ?? CdnFormat.png);
  }

  Uri? assetsSmallImageUrl({CdnFormat? format}) {
    if (assets?.smallImage == null || applicationId == null) {
      return null;
    }

    return parseAssetUrl(assets!.smallImage!, applicationId!, format ?? CdnFormat.png);
  }
}

Uri parseAssetUrl(String assetUrl, Snowflake applicationId, CdnFormat format) {
  var isMediaProxy = assetUrl.startsWith('mp:');

  return isMediaProxy
      ? Uri.parse('$mediaProxyUrl/${assetUrl.substring(3)}')
      : Uri.https('cdn.discordapp.com', '/app-assets/$applicationId/$assetUrl.${format.extension}');
}
