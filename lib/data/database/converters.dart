import 'package:drift/drift.dart';

import '../../core/date/local_day.dart';

/// Stores a [LocalDay] as its epochDay (`int`).
class LocalDayConverter extends TypeConverter<LocalDay, int> {
  const LocalDayConverter();

  @override
  LocalDay fromSql(int fromDb) => LocalDay.fromEpochDay(fromDb);

  @override
  int toSql(LocalDay value) => value.epochDay;
}
