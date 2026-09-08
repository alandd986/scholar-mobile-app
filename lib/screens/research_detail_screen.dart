import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/research.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class ResearchDetailScreen extends StatelessWidget {
  final Research research;
  final void Function(String id) onToggleSave;

  const ResearchDetailScreen({
    super.key,
    required this.research,
    required this.onToggleSave,
  });

  bool get _isCompleted => research.status == ResearchStatus.completed;

  // Opens a URL in the browser; shows a snackbar on failure
  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open the link'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_isCompleted ? 'Research Details' : 'Participate'),
        actions: [
          IconButton(
            icon: Icon(
              research.isSaved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: research.isSaved
                  ? AppTheme.primary
                  : AppTheme.textSecondary,
            ),
            onPressed: () {
              onToggleSave(research.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(research.isSaved
                      ? 'Removed from saved'
                      : 'Saved to your list'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(research: research, isCompleted: _isCompleted),
            const SizedBox(height: 14),
            _MetaCard(research: research, isCompleted: _isCompleted),
            const SizedBox(height: 14),
            _SummaryCard(summary: research.summary),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: _BottomAction(
        research: research,
        isCompleted: _isCompleted,
        onOpenUrl: (url) => _openUrl(context, url),
      ),
    );
  }
}

// ── Header card ──────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final Research research;
  final bool isCompleted;
  const _HeaderCard({required this.research, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              _TopicChip(topic: research.topic),
              const SizedBox(width: 8),
              StatusBadge(status: research.status),
              if (isCompleted) ...[
                const SizedBox(width: 8),
                PriceBadge(
                  isPaid: research.isPaid,
                  price: research.price,
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),

          // Title
          Text(
            research.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1.3,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 14),

          // Researcher
          Row(
            children: [
              _Avatar(name: research.researcher),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      research.researcher,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      research.institution,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Meta info card ────────────────────────────────────────────────

class _MetaCard extends StatelessWidget {
  final Research research;
  final bool isCompleted;
  const _MetaCard({required this.research, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetaItem(
                  icon: Icons.location_on_outlined,
                  label: 'City',
                  value: research.city,
                ),
              ),
              Expanded(
                child: _MetaItem(
                  icon: Icons.assignment_outlined,
                  label: 'Type',
                  value: research.researchType,
                ),
              ),
              Expanded(
                child: _MetaItem(
                  icon: Icons.schedule_outlined,
                  label: 'Duration',
                  value: research.duration,
                ),
              ),
            ],
          ),
          // Extra row for participation-specific info
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                if (research.targetParticipants != null)
                  Expanded(
                    child: _MetaItem(
                      icon: Icons.people_outline_rounded,
                      label: 'Participants needed',
                      value: research.targetParticipants!,
                    ),
                  ),
                if (research.deadline != null)
                  Expanded(
                    child: _MetaItem(
                      icon: Icons.calendar_today_outlined,
                      label: 'Deadline',
                      value: research.deadline!,
                      valueColor: AppTheme.warning,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String summary;
  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Research',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom action button ──────────────────────────────────────────

class _BottomAction extends StatelessWidget {
  final Research research;
  final bool isCompleted;
  final void Function(String url) onOpenUrl;

  const _BottomAction({
    required this.research,
    required this.isCompleted,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasLink = isCompleted
        ? (research.googleFormUrl != null)
        : (research.googleFormUrl != null);

    final label = isCompleted ? 'View Research Link' : 'Open Google Form';
    final icon  = isCompleted ? Icons.open_in_new_rounded : Icons.edit_note_rounded;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: hasLink
              ? () => onOpenUrl(research.googleFormUrl!)
              : null,
          icon: Icon(icon, size: 18),
          label: Text(hasLink ? label : 'No link available'),
        ),
      ),
    );
  }
}

// ── Tiny helper widgets ───────────────────────────────────────────

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

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppTheme.primarySoft,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 15,
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
  final String value;
  final Color? valueColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
