import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/routes/app_routing.dart';

class ShareProductButton extends StatelessWidget {
  final int productId;

  const ShareProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await SharePlus.instance.share(
          ShareParams(
            text: AppRouting.productDeepLink(
              productId,
              queryParameters: const {'source': 'share'},
            ),
          ),
        );
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.share, size: 18),
      ),
    );
  }
}
