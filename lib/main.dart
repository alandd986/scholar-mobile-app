import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/sample_data.dart';
import 'models/research.dart';
import 'screens/explore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/submit_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ScholareApp());
}

class ScholareApp extends StatelessWidget {
  const ScholareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _AppEntry(),
    );
  }
}

/// Decides whether to show onboarding or the main shell.
/// Onboarding is session-only — it appears every restart (no persistence).
class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_onboardingDone) {
      return OnboardingScreen(
        onFinish: () => setState(() => _onboardingDone = true),
      );
    }
    return const ScholareShell();
  }
}

// ── Main shell — owns all research state ─────────────────────────

class ScholareShell extends StatefulWidget {
  const ScholareShell({super.key});

  @override
  State<ScholareShell> createState() => _ScholareShellState();
}

class _ScholareShellState extends State<ScholareShell> {
  int _tab = 0;

  // Single mutable list for the whole session.
  // Copied from sampleResearch so the const list is never mutated.
  late final List<Research> _research;

  @override
  void initState() {
    super.initState();
    _research = sampleResearch
        .map((r) => Research(
              id: r.id,
              title: r.title,
              researcher: r.researcher,
              institution: r.institution,
              topic: r.topic,
              researchType: r.researchType,
              city: r.city,
              duration: r.duration,
              status: r.status,
              summary: r.summary,
              googleFormUrl: r.googleFormUrl,
              deadline: r.deadline,
              targetParticipants: r.targetParticipants,
              isPaid: r.isPaid,
              price: r.price,
              isSaved: r.isSaved,
            ))
        .toList();
  }

  void _toggleSave(String id) {
    setState(() {
      final i = _research.indexWhere((r) => r.id == id);
      if (i != -1) _research[i].isSaved = !_research[i].isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screens are kept alive by IndexedStack so state is not lost on tab switch.
    final screens = [
      HomeScreen(allResearch: _research, onToggleSave: _toggleSave),
      ExploreScreen(allResearch: _research, onToggleSave: _toggleSave),
      const SubmitScreen(),
      SavedScreen(allResearch: _research, onToggleSave: _toggleSave),
    ];

    final savedCount = _research.where((r) => r.isSaved).length;

    return Scaffold(
      body: IndexedStack(index: _tab, children: screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: _tab,
        savedCount: savedCount,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ── Bottom navigation bar ─────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final int savedCount;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.savedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: AppTheme.cardBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppTheme.primarySoft,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon:
                Icon(Icons.menu_book_rounded, color: AppTheme.primary),
            label: 'Library',
          ),
          const NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon:
                Icon(Icons.group_rounded, color: AppTheme.primary),
            label: 'Participate',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded,
                color: AppTheme.primary),
            label: 'Post',
          ),
          NavigationDestination(
            icon: savedCount > 0
                ? Badge(
                    label: Text('$savedCount'),
                    child: const Icon(Icons.bookmark_outline_rounded),
                  )
                : const Icon(Icons.bookmark_outline_rounded),
            selectedIcon: savedCount > 0
                ? Badge(
                    label: Text('$savedCount'),
                    child: const Icon(Icons.bookmark_rounded,
                        color: AppTheme.primary),
                  )
                : const Icon(Icons.bookmark_rounded,
                    color: AppTheme.primary),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
