import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';

/// ECR-02 — Borrowers list. Skeleton, content comes with epic E1.
class BorrowersScreen extends StatelessWidget {
  const BorrowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navBorrowers)),
    );
  }
}
