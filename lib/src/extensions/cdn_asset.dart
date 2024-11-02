import 'package:nyxx/nyxx.dart';

extension CdnAssetExtensions on CdnAsset {
  /// Get the URL for this asset whth the given [format] and [size].
  Uri get({CdnFormat? format, int? size}) => getRequest(this, format ?? defaultFormat, size).prepare(client).url;
}

// Re-implementing the private method from CdnAsset
CdnRequest getRequest(CdnAsset asset, CdnFormat format, int? size) {
  final route = HttpRoute();

  for (final part in asset.base.parts) {
    route.add(part);
  }
  route.add(HttpRoutePart('${asset.hash}.${format.extension}'));

  return CdnRequest(
    route,
    queryParameters: {
      if (size != null) 'size': size.toString(),
    },
  );
}
