import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../theme/app_theme.dart';

/// Post screen — lets researchers submit a new study (demo only).
class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey = GlobalKey<FormState>();

  // Which type of post the user wants to create
  bool _isCompleted = true; // true = Completed Research, false = Participation Request

  String _selectedTopic = 'Medicine';
  String _selectedType  = 'Survey';
  bool   _isPaid        = false;

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.rocket_launch_outlined,
                size: 32,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Demo Version',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Posting will be available in the full release. '
              'Thank you for your interest in Scholare!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBg,
        title: const Text('Post Research'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Segmented toggle ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    _SegmentButton(
                      label: 'Completed Research',
                      selected: _isCompleted,
                      onTap: () => setState(() => _isCompleted = true),
                    ),
                    _SegmentButton(
                      label: 'Participation Request',
                      selected: !_isCompleted,
                      onTap: () => setState(() => _isCompleted = false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isCompleted
                    ? 'Share a finished study for others to reference'
                    : 'Find participants for your ongoing study',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Shared fields ─────────────────────────────────────
              _SectionLabel('Researcher Info'),
              const SizedBox(height: 12),
              _Field(
                label: 'Research Title',
                hint: 'Enter the full title',
                validator: _required,
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Your Name',
                hint: 'Full name',
                validator: _required,
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'Institution / University',
                hint: 'e.g. University of Baghdad',
                validator: _required,
              ),
              const SizedBox(height: 24),

              _SectionLabel('Research Details'),
              const SizedBox(height: 12),

              // Topic dropdown
              _DropdownField(
                label: 'Topic',
                value: _selectedTopic,
                items: topicOptions.where((t) => t != 'All Topics').toList(),
                onChanged: (v) => setState(() => _selectedTopic = v!),
              ),
              const SizedBox(height: 14),

              // Research type dropdown
              _DropdownField(
                label: 'Research Type',
                value: _selectedType,
                items: researchTypeOptions
                    .where((t) => t != 'All Types')
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 14),

              _Field(label: 'City', hint: 'e.g. Erbil', validator: _required),
              const SizedBox(height: 24),

              // ── Completed-specific fields ────────────────────────
              if (_isCompleted) ...[
                _SectionLabel('Study Summary'),
                const SizedBox(height: 12),
                _Field(
                  label: 'Summary / Abstract',
                  hint: 'Briefly describe your research and key findings...',
                  maxLines: 4,
                  validator: _required,
                ),
                const SizedBox(height: 14),

                // Free / Paid toggle
                _FieldLabel('Access'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ChoiceChip(
                      label: 'Free',
                      selected: !_isPaid,
                      onTap: () => setState(() => _isPaid = false),
                    ),
                    const SizedBox(width: 8),
                    _ChoiceChip(
                      label: 'Paid',
                      selected: _isPaid,
                      onTap: () => setState(() => _isPaid = true),
                    ),
                  ],
                ),
                if (_isPaid) ...[
                  const SizedBox(height: 14),
                  _Field(
                    label: 'Price',
                    hint: 'e.g. 5,000 IQD',
                    validator: _required,
                  ),
                ],
              ],

              // ── Participation-specific fields ────────────────────
              if (!_isCompleted) ...[
                _SectionLabel('Participation Info'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _Field(
                        label: 'Target Participants',
                        hint: 'e.g. 100',
                        keyboardType: TextInputType.number,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Field(
                        label: 'Deadline',
                        hint: 'e.g. July 30, 2025',
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Field(
                  label: 'Google Form Link',
                  hint: 'https://forms.google.com/...',
                  keyboardType: TextInputType.url,
                  validator: _required,
                ),
                const SizedBox(height: 14),
                _Field(
                  label: 'Short Description',
                  hint: 'What will participants do? How long does it take?',
                  maxLines: 3,
                  validator: _required,
                ),
              ],

              const SizedBox(height: 32),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Demo only — no data will be stored',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;
}

// ── Small form widgets ────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

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

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        Container(
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
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
