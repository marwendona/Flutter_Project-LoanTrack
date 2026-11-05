import 'package:material_ui/material_ui.dart';

/// Buttons at the bottom of a form, aligned to the end. When they do not fit
/// on one line (narrow screen, enlarged system font — ENF-08), they are
/// stacked instead of overflowing.
class FormActions extends StatelessWidget {
  const FormActions({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
      alignment: MainAxisAlignment.end,
      overflowAlignment: OverflowBarAlignment.end,
      spacing: 8,
      overflowSpacing: 8,
      children: children,
    );
  }
}
