import 'package:flutter/material.dart';
import 'package:pre_techwiz/models/model_banner.dart';
import 'package:pre_techwiz/shared/widgets/app_image_network.dart';

import 'app_placeholder.dart';

class AppBannerWidget extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback? onTap;

  const AppBannerWidget({
    Key? key,
    required this.banner,
    this.onTap,
  }) : super(key: key);

  void _makeAction() {
    if (onTap != null) {
      onTap!();
    }
  }

  Widget _buildHeader(BuildContext context) {
    final hasTitle = banner.title?.isNotEmpty ?? false;
    final hasDescription = banner.description?.isNotEmpty ?? false;

    if (!hasTitle && !hasDescription) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle)
          Text(
            banner.title!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        if (hasDescription)
          Text(
            banner.description!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImageNetwork(
              imageUrl: banner.image ?? '',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              onTap: onTap,
              placeholder: (context, url) => const AppPlaceholder(
                child: SizedBox(
                  height: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                height: 120,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
