import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/reliability_grouping.dart';
import '../borrowers/borrowers_providers.dart';

/// Borrowers grouped by reliability color (ECR-07), recomputed whenever a
/// borrower, loan or repayment changes (RG-63). Ignores the ECR-02 search.
final borrowersByColorProvider = Provider<List<ReliabilityGroup>>(
  (ref) => ReliabilityGrouping.group(
    ref.watch(borrowerSummariesProvider).value ?? const [],
  ),
);
