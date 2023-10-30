import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class Service {
  const Service({
    required this.id,
    required this.title,
    this.color = ThemeColors.primary,
    required this.iconAssetPath,
    required this.description,
  });

  final String id;
  final String title;
  final Color color;
  final String iconAssetPath;
  final String description;
}
