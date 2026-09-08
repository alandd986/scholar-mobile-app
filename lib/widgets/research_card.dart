import 'package:flutter/material.dart';
import '../models/research.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class ResearchCard extends StatelessWidget {
  final Research research;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  const ResearchCard({
    super.key,
    required this.research,
    required this.onTap,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = research.status == ResearchStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──────────────────────────────────────────
            Row(
              children: [
                _TopicChip(topic: research.topic),
                const SizedBox(width: 8),
                // Paid/Free only for completed research
                if (isCompleted)
                  PriceBadge(
                    isPaid: research.isPaid,
                    price: research.price,
                  ),
                const Spacer(),
                _BookmarkButton(
                  isSaved: research.isSaved,
                  onTap: onBookmark,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Title ─────────────────────────────────────────────
            Text(
              research.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                height: 1.35,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // ── Researcher ────────────────────────────────────────
            Row(
              children: [
                _InitialAvatar(name: research.researcher),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${research.researcher} · ${research.institution}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Bottom meta row ───────────────────────────────────
            Row(
              children: [
                _MetaItem(
                  icon: Icons.location_on_outlined,
                  label: research.city,
                ),
                const SizedBox(width: 14),
                _MetaItem(
                  icon: Icons.assignment_outlined,
                  label: research.researchType,
                ),
                const SizedBox(width: 14),
                // Deadline only for active / participate cards
                if (!isCompleted && research.deadline != null)
                  _MetaItem(
                    icon: Icons.calendar_today_outlined,
                    label: research.deadline!,
                    color: AppTheme.warning,
                  ),
                // Target participants
                if (!isCompleted && research.targetParticipants != null)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _MetaItem(
                        icon: Icons.people_outline_rounded,
                        label: '${research.targetParticipants} needed',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable pieces ─────────────────────────────────────────

class _TopicChip extends StatelessWidget {
  final String topic;
  const _TopicChip({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        topic,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;
  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: AppTheme.primarySoft,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaItem({
    required this.icon,
    required this.label,
    this.color = AppTheme.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _BookmarkButton({required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
          size: 22,
          color: isSaved ? AppTheme.primary : AppTheme.textMuted,
        ),
      ),
    );
  }
}
