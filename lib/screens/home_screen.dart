import 'package:flutter/material.dart';
import '../models/research.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/research_card.dart';
import '../widgets/shared_widgets.dart';
import 'research_detail_screen.dart';

/// Library screen — shows completed research that users can browse as reference.
class HomeScreen extends StatefulWidget {
  final List<Research> allResearch;
  final void Function(String id) onToggleSave;

  const HomeScreen({
    super.key,
    required this.allResearch,
    required this.onToggleSave,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query   = '';
  String _topic   = 'All Topics';
  String _city    = 'All Cities';
  String _type    = 'All Types';
  String _paid    = 'All';

  List<Research> get _completed => widget.allResearch
      .where((r) => r.status == ResearchStatus.completed)
      .where((r) {
        final q = _query.toLowerCase();
        final matchQ = q.isEmpty ||
            r.title.toLowerCase().contains(q) ||
            r.researcher.toLowerCase().contains(q) ||
            r.topic.toLowerCase().contains(q);
        final matchTopic = _topic == 'All Topics' || r.topic == _topic;
        final matchCity  = _city  == 'All Cities' || r.city  == _city;
        final matchType  = _type  == 'All Types'  || r.researchType == _type;
        final matchPaid  = _paid  == 'All' ||
            (_paid == 'Free' && !r.isPaid) ||
            (_paid == 'Paid' && r.isPaid);
        return matchQ && matchTopic && matchCity && matchType && matchPaid;
      })
      .toList();

  bool get _hasFilters =>
      _topic != 'All Topics' ||
      _city  != 'All Cities' ||
      _type  != 'All Types'  ||
      _paid  != 'All';

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        selectedTopic: _topic,
        selectedCity: _city,
        selectedType: _type,
        selectedPaid: _paid,
        showPaidFilter: true,
        onApply: ({required topic, required city, required type, required paid}) {
          setState(() {
            _topic = topic;
            _city  = city;
            _type  = type;
            _paid  = paid;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _completed;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        title: Image.asset(
          'assets/images/logo.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${items.length} studies',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            color: AppTheme.cardBg,
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Research Library',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Browse completed academic research',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                // Search + filter
                Row(
                  children: [
                    Expanded(
                      child: ScholareSearchBar(
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilterButton(
                      active: _hasFilters,
                      onTap: _openFilter,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── List ─────────────────────────────────────────────────
          Expanded(
            child: items.isEmpty
                ? EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: 'No research found',
                    subtitle: 'Try adjusting your search or filters',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final r = items[i];
                      return ResearchCard(
                        research: r,
                        onTap: () => _openDetail(context, r),
                        onBookmark: () => widget.onToggleSave(r.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Research r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResearchDetailScreen(
          research: r,
          onToggleSave: widget.onToggleSave,
        ),
      ),
    );
  }
}

