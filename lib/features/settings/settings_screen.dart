import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';

/// ECR-06 — Settings. Skeleton, content comes with epic E5.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navSettings)),
    );
  }
}
