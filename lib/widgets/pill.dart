import 'package:flutter/material.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';

class Pill extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? color;

  const Pill({
    super.key,
    this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? PuventColors.primaryGreen.color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: Colors.white, size: 16),
              if (label != null) ...[
                if (icon != null) const SizedBox(width: 5),
                Text(label!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
