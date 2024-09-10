import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef PlaceholderBuilder = Widget Function(BuildContext context, String url);
typedef ErrorWidgetBuilder = Widget Function(
    BuildContext context, String url, dynamic error);

class AppImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final PlaceholderBuilder? placeholder;
  final ErrorWidgetBuilder? errorWidget;
  final VoidCallback? onTap;

  const AppImageNetwork({
    Key? key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.onTap,
  }) : super(key: key);

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');

  Widget _buildImage(BuildContext context, ImageProvider imageProvider) {
    final image = Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: image) : image;
  }

  Widget _buildSvg(BuildContext context) {
    final svg = SvgPicture.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (context) =>
          placeholder?.call(context, imageUrl) ??
          const CircularProgressIndicator(),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: svg) : svg;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          placeholder ?? (context, url) => const CircularProgressIndicator(),
      errorWidget:
          errorWidget ?? (context, url, error) => const Icon(Icons.error),
      imageBuilder: (context, imageProvider) {
        return _isSvg
            ? _buildSvg(context)
            : _buildImage(context, imageProvider);
      },
    );
  }
}
