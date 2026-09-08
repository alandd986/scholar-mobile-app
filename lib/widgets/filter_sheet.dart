import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme/app_theme.dart';

class FilterSheet extends StatefulWidget {
  final String selectedTopic;
  final String selectedCity;
  final String selectedType;
  final bool showPaidFilter;      // only shown on Library screen
  final String selectedPaid;      // 'All', 'Free', 'Paid'

  final void Function({
    required String topic,
    required String city,
    required String type,
    required String paid,
  }) onApply;

  const FilterSheet({
    super.key,
    required this.selectedTopic,
    required this.selectedCity,
    required this.selectedType,
    required this.onApply,
    this.showPaidFilter = false,
    this.selectedPaid = 'All',
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String _topic;
  late String _city;
  late String _type;
  late String _paid;

  @override
  void initState() {
    super.initState();
    _topic = widget.selectedTopic;
    _city  = widget.selectedCity;
    _type  = widget.selectedType;
    _paid  = widget.selectedPaid;
  }

  void _reset() => setState(() {
        _topic = 'All Topics';
        _city  = 'All Cities';
        _type  = 'All Types';
        _paid  = 'All';
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _reset,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _Label('Topic'),
          const SizedBox(height: 8),
          _Dropdown(
            value: _topic,
            items: topicOptions,
            onChanged: (v) => setState(() => _topic = v!),
          ),
          const SizedBox(height: 14),

          _Label('City'),
          const SizedBox(height: 8),
          _Dropdown(
            value: _city,
            items: cityOptions,
            onChanged: (v) => setState(() => _city = v!),
          ),
          const SizedBox(height: 14),

          _Label('Research Type'),
          const SizedBox(height: 8),
          _Dropdown(
            value: _type,
            items: researchTypeOptions,
            onChanged: (v) => setState(() => _type = v!),
          ),

          // Paid/Free filter — Library only
          if (widget.showPaidFilter) ...[
            const SizedBox(height: 14),
            _Label('Access'),
            const SizedBox(height: 8),
            Row(
              children: ['All', 'Free', 'Paid'].map((opt) {
                final selected = _paid == opt;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _paid = opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.border,
                        ),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(
                  topic: _topic,
                  city: _city,
                  type: _type,
                  paid: _paid,
                );
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      );
}

class _Dropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textMuted),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
