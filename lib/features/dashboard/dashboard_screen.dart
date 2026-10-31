import 'package:material_ui/material_ui.dart';

import '../../l10n/generated/app_localizations.dart';

/// ECR-01 — Dashboard (home). Skeleton, content comes with epic E4.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).navDashboard)),
    );
  }
}
