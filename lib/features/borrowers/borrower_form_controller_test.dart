import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loantrack/data/providers.dart';
import 'package:loantrack/domain/repositories/borrower_repository.dart';
import 'package:loantrack/domain/services/borrower_validator.dart';
import 'package:loantrack/features/borrowers/borrower_form_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockBorrowerRepository extends Mock implements BorrowerRepository {}

void main() {
  late _MockBorrowerRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockBorrowerRepository();
    container = ProviderContainer(
      overrides: [borrowerRepositoryProvider.overrideWithValue(repository)],
    );
    // Keeps the auto-dispose controller alive during the test.
    container.listen(borrowerFormControllerProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  BorrowerFormController controller() =>
      container.read(borrowerFormControllerProvider.notifier);
  BorrowerFormState state() => container.read(borrowerFormControllerProvider);

  void stubAdd(Future<int> Function() answer) => when(
    () => repository.add(
      name: any(named: 'name'),
      phone: any(named: 'phone'),
      note: any(named: 'note'),
    ),
  ).thenAnswer((_) => answer());

  test('saves a valid borrower', () async {
    stubAdd(() async => 1);

    final saved = await controller().save(
      name: 'Ali',
      phone: '20 000 000',
      note: '',
    );

    expect(saved, isTrue);
    verify(() => repository.add(name: 'Ali', phone: '20 000 000', note: ''))
        .called(1);
    expect(state().isSaving, isFalse);
    expect(state().isDuplicateName, isFalse);
  });

  test('does not save an invalid name', () async {
    final saved = await controller().save(name: '  ');

    expect(saved, isFalse);
    verifyNever(
      () => repository.add(
        name: any(named: 'name'),
        phone: any(named: 'phone'),
        note: any(named: 'note'),
      ),
    );
  });

  test('reports a duplicate name, cleared when the name changes', () async {
    stubAdd(() async => throw const DuplicateBorrowerNameException('Ali'));

    final saved = await controller().save(name: 'Ali');

    expect(saved, isFalse);
    expect(state().isDuplicateName, isTrue);
    controller().nameChanged();
    expect(state().isDuplicateName, isFalse);
  });

  test('reports an unexpected save failure', () async {
    stubAdd(() async => throw Exception('disk full'));

    final saved = await controller().save(name: 'Ali');

    expect(saved, isFalse);
    expect(state().hasSaveFailed, isTrue);
    expect(state().isSaving, isFalse);
  });
}
