import 'package:flutter/material.dart';
import '../models/research.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final ResearchStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == ResearchStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primarySoft : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isActive ? 'Open' : 'Completed',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold "Paid" badge or soft green "Free" badge
class PriceBadge extends StatelessWidget {
  final bool isPaid;
  final String? price;
  const PriceBadge({super.key, required this.isPaid, this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid ? AppTheme.paidBg : AppTheme.freeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPaid
              ? AppTheme.paid.withOpacity(0.4)
              : AppTheme.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        isPaid ? (price != null ? 'Paid · $price' : 'Paid') : 'Free',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPaid ? AppTheme.paid : AppTheme.primary,
        ),
      ),
    );
  }
}
