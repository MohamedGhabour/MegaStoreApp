import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mega_shop/utility/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';
import 'provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء تحميل العناصر بعد بناء الـ widget بالكامل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.favoriteProvider.loadFavoriteItems();
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AppBar(
              leading: const Icon(Icons.arrow_back, color: Colors.black),
              elevation: 0.0,
              title: const Text(
                "Favorites",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkAccent,
                ),
              ),
              backgroundColor: Colors.black.withAlpha(0),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            return ProductGridView(
              items: favoriteProvider.favoriteProduct,
            );
          },
        ),
      ),
    );
  }
}
