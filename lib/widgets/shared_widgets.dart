import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Simple search text field used on Library and Participate screens.
class ScholareSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ScholareSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Search...',
          prefixIcon:
              Icon(Icons.search_rounded, color: AppTheme.textMuted, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

/// Filter icon button — turns green when filters are active.
class FilterButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const FilterButton({super.key, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 20,
          color: active ? Colors.white : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

/// Centered empty state with an icon, heading, and subtitle.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 36, color: AppTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
