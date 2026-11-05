import 'package:material_ui/material_ui.dart';

/// A label on the start side and its value (often an amount) on the end
/// side. When both do not fit on one line (enlarged system font — ENF-08),
/// the value moves below the label instead of overflowing.
class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.style,
    this.valueStyle,
  });

  final String label;
  final String value;

  /// Style of the label, and of the value unless [valueStyle] is set.
  final TextStyle? style;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    // Read as one item by TalkBack: "label, value".
    return MergeSemantics(
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 16,
          children: [
            Text(label, style: style),
            Text(value, style: valueStyle ?? style),
          ],
        ),
      ),
    );
  }
}
