// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BorrowersTable extends Borrowers
    with TableInfo<$BorrowersTable, BorrowerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BorrowersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDay, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDay>($BorrowersTable.$convertercreatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameKey,
    phone,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'borrowers';
  @override
  VerificationContext validateIntegrity(
    Insertable<BorrowerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BorrowerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BorrowerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: $BorrowersTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
    );
  }

  @override
  $BorrowersTable createAlias(String alias) {
    return $BorrowersTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDay, int> $convertercreatedAt =
      const LocalDayConverter();
}

class BorrowerRow extends DataClass implements Insertable<BorrowerRow> {
  final int id;
  final String name;

  /// Normalized name, unique to forbid duplicates (RG-02).
  final String nameKey;
  final String? phone;
  final String? note;
  final LocalDay createdAt;
  const BorrowerRow({
    required this.id,
    required this.name,
    required this.nameKey,
    this.phone,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_key'] = Variable<String>(nameKey);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['created_at'] = Variable<int>(
        $BorrowersTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    return map;
  }

  BorrowersCompanion toCompanion(bool nullToAbsent) {
    return BorrowersCompanion(
      id: Value(id),
      name: Value(name),
      nameKey: Value(nameKey),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory BorrowerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BorrowerRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      phone: serializer.fromJson<String?>(json['phone']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<LocalDay>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameKey': serializer.toJson<String>(nameKey),
      'phone': serializer.toJson<String?>(phone),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<LocalDay>(createdAt),
    };
  }

  BorrowerRow copyWith({
    int? id,
    String? name,
    String? nameKey,
    Value<String?> phone = const Value.absent(),
    Value<String?> note = const Value.absent(),
    LocalDay? createdAt,
  }) => BorrowerRow(
    id: id ?? this.id,
    name: name ?? this.name,
    nameKey: nameKey ?? this.nameKey,
    phone: phone.present ? phone.value : this.phone,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  BorrowerRow copyWithCompanion(BorrowersCompanion data) {
    return BorrowerRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      phone: data.phone.present ? data.phone.value : this.phone,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BorrowerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('phone: $phone, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameKey, phone, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BorrowerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameKey == this.nameKey &&
          other.phone == this.phone &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BorrowersCompanion extends UpdateCompanion<BorrowerRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameKey;
  final Value<String?> phone;
  final Value<String?> note;
  final Value<LocalDay> createdAt;
  const BorrowersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BorrowersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameKey,
    this.phone = const Value.absent(),
    this.note = const Value.absent(),
    required LocalDay createdAt,
  }) : name = Value(name),
       nameKey = Value(nameKey),
       createdAt = Value(createdAt);
  static Insertable<BorrowerRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameKey,
    Expression<String>? phone,
    Expression<String>? note,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameKey != null) 'name_key': nameKey,
      if (phone != null) 'phone': phone,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BorrowersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameKey,
    Value<String?>? phone,
    Value<String?>? note,
    Value<LocalDay>? createdAt,
  }) {
    return BorrowersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      phone: phone ?? this.phone,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $BorrowersTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BorrowersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('phone: $phone, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, LoanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _borrowerIdMeta = const VerificationMeta(
    'borrowerId',
  );
  @override
  late final GeneratedColumn<int> borrowerId = GeneratedColumn<int>(
    'borrower_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES borrowers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(amountMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDay, int> loanDate =
      GeneratedColumn<int>(
        'loan_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDay>($LoansTable.$converterloanDate);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDay?, int>
  promisedReturnDate = GeneratedColumn<int>(
    'promised_return_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<LocalDay?>($LoansTable.$converterpromisedReturnDaten);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    borrowerId,
    amountMinor,
    loanDate,
    promisedReturnDate,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('borrower_id')) {
      context.handle(
        _borrowerIdMeta,
        borrowerId.isAcceptableOrUnknown(data['borrower_id']!, _borrowerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_borrowerIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      borrowerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}borrower_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      loanDate: $LoansTable.$converterloanDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}loan_date'],
        )!,
      ),
      promisedReturnDate: $LoansTable.$converterpromisedReturnDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}promised_return_date'],
        ),
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDay, int> $converterloanDate =
      const LocalDayConverter();
  static TypeConverter<LocalDay, int> $converterpromisedReturnDate =
      const LocalDayConverter();
  static TypeConverter<LocalDay?, int?> $converterpromisedReturnDaten =
      NullAwareTypeConverter.wrap($converterpromisedReturnDate);
}

class LoanRow extends DataClass implements Insertable<LoanRow> {
  final int id;
  final int borrowerId;
  final int amountMinor;
  final LocalDay loanDate;
  final LocalDay? promisedReturnDate;
  final String? note;
  const LoanRow({
    required this.id,
    required this.borrowerId,
    required this.amountMinor,
    required this.loanDate,
    this.promisedReturnDate,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['borrower_id'] = Variable<int>(borrowerId);
    map['amount_minor'] = Variable<int>(amountMinor);
    {
      map['loan_date'] = Variable<int>(
        $LoansTable.$converterloanDate.toSql(loanDate),
      );
    }
    if (!nullToAbsent || promisedReturnDate != null) {
      map['promised_return_date'] = Variable<int>(
        $LoansTable.$converterpromisedReturnDaten.toSql(promisedReturnDate),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      borrowerId: Value(borrowerId),
      amountMinor: Value(amountMinor),
      loanDate: Value(loanDate),
      promisedReturnDate: promisedReturnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(promisedReturnDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory LoanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanRow(
      id: serializer.fromJson<int>(json['id']),
      borrowerId: serializer.fromJson<int>(json['borrowerId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      loanDate: serializer.fromJson<LocalDay>(json['loanDate']),
      promisedReturnDate: serializer.fromJson<LocalDay?>(
        json['promisedReturnDate'],
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'borrowerId': serializer.toJson<int>(borrowerId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'loanDate': serializer.toJson<LocalDay>(loanDate),
      'promisedReturnDate': serializer.toJson<LocalDay?>(promisedReturnDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  LoanRow copyWith({
    int? id,
    int? borrowerId,
    int? amountMinor,
    LocalDay? loanDate,
    Value<LocalDay?> promisedReturnDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => LoanRow(
    id: id ?? this.id,
    borrowerId: borrowerId ?? this.borrowerId,
    amountMinor: amountMinor ?? this.amountMinor,
    loanDate: loanDate ?? this.loanDate,
    promisedReturnDate: promisedReturnDate.present
        ? promisedReturnDate.value
        : this.promisedReturnDate,
    note: note.present ? note.value : this.note,
  );
  LoanRow copyWithCompanion(LoansCompanion data) {
    return LoanRow(
      id: data.id.present ? data.id.value : this.id,
      borrowerId: data.borrowerId.present
          ? data.borrowerId.value
          : this.borrowerId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      loanDate: data.loanDate.present ? data.loanDate.value : this.loanDate,
      promisedReturnDate: data.promisedReturnDate.present
          ? data.promisedReturnDate.value
          : this.promisedReturnDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanRow(')
          ..write('id: $id, ')
          ..write('borrowerId: $borrowerId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('loanDate: $loanDate, ')
          ..write('promisedReturnDate: $promisedReturnDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    borrowerId,
    amountMinor,
    loanDate,
    promisedReturnDate,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanRow &&
          other.id == this.id &&
          other.borrowerId == this.borrowerId &&
          other.amountMinor == this.amountMinor &&
          other.loanDate == this.loanDate &&
          other.promisedReturnDate == this.promisedReturnDate &&
          other.note == this.note);
}

class LoansCompanion extends UpdateCompanion<LoanRow> {
  final Value<int> id;
  final Value<int> borrowerId;
  final Value<int> amountMinor;
  final Value<LocalDay> loanDate;
  final Value<LocalDay?> promisedReturnDate;
  final Value<String?> note;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.borrowerId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.loanDate = const Value.absent(),
    this.promisedReturnDate = const Value.absent(),
    this.note = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required int borrowerId,
    required int amountMinor,
    required LocalDay loanDate,
    this.promisedReturnDate = const Value.absent(),
    this.note = const Value.absent(),
  }) : borrowerId = Value(borrowerId),
       amountMinor = Value(amountMinor),
       loanDate = Value(loanDate);
  static Insertable<LoanRow> custom({
    Expression<int>? id,
    Expression<int>? borrowerId,
    Expression<int>? amountMinor,
    Expression<int>? loanDate,
    Expression<int>? promisedReturnDate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (borrowerId != null) 'borrower_id': borrowerId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (loanDate != null) 'loan_date': loanDate,
      if (promisedReturnDate != null)
        'promised_return_date': promisedReturnDate,
      if (note != null) 'note': note,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<int>? borrowerId,
    Value<int>? amountMinor,
    Value<LocalDay>? loanDate,
    Value<LocalDay?>? promisedReturnDate,
    Value<String?>? note,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      borrowerId: borrowerId ?? this.borrowerId,
      amountMinor: amountMinor ?? this.amountMinor,
      loanDate: loanDate ?? this.loanDate,
      promisedReturnDate: promisedReturnDate ?? this.promisedReturnDate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (borrowerId.present) {
      map['borrower_id'] = Variable<int>(borrowerId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (loanDate.present) {
      map['loan_date'] = Variable<int>(
        $LoansTable.$converterloanDate.toSql(loanDate.value),
      );
    }
    if (promisedReturnDate.present) {
      map['promised_return_date'] = Variable<int>(
        $LoansTable.$converterpromisedReturnDaten.toSql(
          promisedReturnDate.value,
        ),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('borrowerId: $borrowerId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('loanDate: $loanDate, ')
          ..write('promisedReturnDate: $promisedReturnDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $RepaymentsTable extends Repayments
    with TableInfo<$RepaymentsTable, RepaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    check: () => ComparableExpr(amountMinor).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDay, int> repaymentDate =
      GeneratedColumn<int>(
        'repayment_date',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LocalDay>($RepaymentsTable.$converterrepaymentDate);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loanId,
    amountMinor,
    repaymentDate,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repayments';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      repaymentDate: $RepaymentsTable.$converterrepaymentDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}repayment_date'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $RepaymentsTable createAlias(String alias) {
    return $RepaymentsTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDay, int> $converterrepaymentDate =
      const LocalDayConverter();
}

class RepaymentRow extends DataClass implements Insertable<RepaymentRow> {
  final int id;
  final int loanId;
  final int amountMinor;
  final LocalDay repaymentDate;
  final String? note;
  const RepaymentRow({
    required this.id,
    required this.loanId,
    required this.amountMinor,
    required this.repaymentDate,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['amount_minor'] = Variable<int>(amountMinor);
    {
      map['repayment_date'] = Variable<int>(
        $RepaymentsTable.$converterrepaymentDate.toSql(repaymentDate),
      );
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  RepaymentsCompanion toCompanion(bool nullToAbsent) {
    return RepaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amountMinor: Value(amountMinor),
      repaymentDate: Value(repaymentDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory RepaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepaymentRow(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      repaymentDate: serializer.fromJson<LocalDay>(json['repaymentDate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'repaymentDate': serializer.toJson<LocalDay>(repaymentDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  RepaymentRow copyWith({
    int? id,
    int? loanId,
    int? amountMinor,
    LocalDay? repaymentDate,
    Value<String?> note = const Value.absent(),
  }) => RepaymentRow(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    amountMinor: amountMinor ?? this.amountMinor,
    repaymentDate: repaymentDate ?? this.repaymentDate,
    note: note.present ? note.value : this.note,
  );
  RepaymentRow copyWithCompanion(RepaymentsCompanion data) {
    return RepaymentRow(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      repaymentDate: data.repaymentDate.present
          ? data.repaymentDate.value
          : this.repaymentDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepaymentRow(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('repaymentDate: $repaymentDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loanId, amountMinor, repaymentDate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepaymentRow &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amountMinor == this.amountMinor &&
          other.repaymentDate == this.repaymentDate &&
          other.note == this.note);
}

class RepaymentsCompanion extends UpdateCompanion<RepaymentRow> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> amountMinor;
  final Value<LocalDay> repaymentDate;
  final Value<String?> note;
  const RepaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.repaymentDate = const Value.absent(),
    this.note = const Value.absent(),
  });
  RepaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int amountMinor,
    required LocalDay repaymentDate,
    this.note = const Value.absent(),
  }) : loanId = Value(loanId),
       amountMinor = Value(amountMinor),
       repaymentDate = Value(repaymentDate);
  static Insertable<RepaymentRow> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? amountMinor,
    Expression<int>? repaymentDate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (repaymentDate != null) 'repayment_date': repaymentDate,
      if (note != null) 'note': note,
    });
  }

  RepaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<int>? amountMinor,
    Value<LocalDay>? repaymentDate,
    Value<String?>? note,
  }) {
    return RepaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amountMinor: amountMinor ?? this.amountMinor,
      repaymentDate: repaymentDate ?? this.repaymentDate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (repaymentDate.present) {
      map['repayment_date'] = Variable<int>(
        $RepaymentsTable.$converterrepaymentDate.toSql(repaymentDate.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('repaymentDate: $repaymentDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BorrowersTable borrowers = $BorrowersTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $RepaymentsTable repayments = $RepaymentsTable(this);
  late final Index idxLoansBorrower = Index(
    'idx_loans_borrower',
    'CREATE INDEX idx_loans_borrower ON loans (borrower_id)',
  );
  late final Index idxRepaymentsLoan = Index(
    'idx_repayments_loan',
    'CREATE INDEX idx_repayments_loan ON repayments (loan_id)',
  );
  late final BorrowersDao borrowersDao = BorrowersDao(this as AppDatabase);
  late final LoansDao loansDao = LoansDao(this as AppDatabase);
  late final RepaymentsDao repaymentsDao = RepaymentsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    borrowers,
    loans,
    repayments,
    idxLoansBorrower,
    idxRepaymentsLoan,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'borrowers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('loans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'loans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('repayments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BorrowersTableCreateCompanionBuilder = BorrowersCompanion Function({
  Value<int> id,
  required String name,
  required String nameKey,
  Value<String?> phone,
  Value<String?> note,
  required LocalDay createdAt,
});
typedef $$BorrowersTableUpdateCompanionBuilder = BorrowersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> nameKey,
  Value<String?> phone,
  Value<String?> note,
  Value<LocalDay> createdAt,
});

final class $$BorrowersTableReferences
    extends BaseReferences<_$AppDatabase, $BorrowersTable, BorrowerRow> {
  $$BorrowersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoansTable, List<LoanRow>> _loansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.loans,
    aliasName: 'borrowers__id__loans__borrower_id',
  );

  $$LoansTableProcessedTableManager get loansRefs {
    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.borrowerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BorrowersTableFilterComposer
    extends Composer<_$AppDatabase, $BorrowersTable> {
  $$BorrowersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDay, LocalDay, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> loansRefs(
    Expression<bool> Function($$LoansTableFilterComposer f) f,
  ) {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.borrowerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BorrowersTableOrderingComposer
    extends Composer<_$AppDatabase, $BorrowersTable> {
  $$BorrowersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BorrowersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BorrowersTable> {
  $$BorrowersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDay, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> loansRefs<T extends Object>(
    Expression<T> Function($$LoansTableAnnotationComposer a) f,
  ) {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.borrowerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BorrowersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BorrowersTable,
          BorrowerRow,
          $$BorrowersTableFilterComposer,
          $$BorrowersTableOrderingComposer,
          $$BorrowersTableAnnotationComposer,
          $$BorrowersTableCreateCompanionBuilder,
          $$BorrowersTableUpdateCompanionBuilder,
          (BorrowerRow, $$BorrowersTableReferences),
          BorrowerRow,
          PrefetchHooks Function({bool loansRefs})
        > {
  $$BorrowersTableTableManager(_$AppDatabase db, $BorrowersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BorrowersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BorrowersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BorrowersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<LocalDay> createdAt = const Value.absent(),
              }) => BorrowersCompanion(
                id: id,
                name: name,
                nameKey: nameKey,
                phone: phone,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameKey,
                Value<String?> phone = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required LocalDay createdAt,
              }) => BorrowersCompanion.insert(
                id: id,
                name: name,
                nameKey: nameKey,
                phone: phone,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BorrowersTable, BorrowerRow>(table),
                  $$BorrowersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loansRefs) db.loans],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loansRefs)
                    await $_getPrefetchedDataByColumns<
                      BorrowerRow,
                      $BorrowersTable,
                      LoanRow,
                      $LoansTable
                    >(
                      currentTable: table,
                      referencedTable: $$BorrowersTableReferences
                          ._loansRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BorrowersTableReferences(db, table, p0).loansRefs,
                      currentColumn: 'id',
                      referencedColumn: 'borrower_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BorrowersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BorrowersTable,
      BorrowerRow,
      $$BorrowersTableFilterComposer,
      $$BorrowersTableOrderingComposer,
      $$BorrowersTableAnnotationComposer,
      $$BorrowersTableCreateCompanionBuilder,
      $$BorrowersTableUpdateCompanionBuilder,
      (BorrowerRow, $$BorrowersTableReferences),
      BorrowerRow,
      PrefetchHooks Function({bool loansRefs})
    >;
typedef $$LoansTableCreateCompanionBuilder = LoansCompanion Function({
  Value<int> id,
  required int borrowerId,
  required int amountMinor,
  required LocalDay loanDate,
  Value<LocalDay?> promisedReturnDate,
  Value<String?> note,
});
typedef $$LoansTableUpdateCompanionBuilder = LoansCompanion Function({
  Value<int> id,
  Value<int> borrowerId,
  Value<int> amountMinor,
  Value<LocalDay> loanDate,
  Value<LocalDay?> promisedReturnDate,
  Value<String?> note,
});

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, LoanRow> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BorrowersTable _borrowerIdTable(_$AppDatabase db) =>
      db.borrowers.createAlias('loans__borrower_id__borrowers__id');

  $$BorrowersTableProcessedTableManager get borrowerId {
    final $_column = $_itemColumn<int>('borrower_id')!;

    final manager = $$BorrowersTableTableManager(
      $_db,
      $_db.borrowers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_borrowerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RepaymentsTable, List<RepaymentRow>>
  _repaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.repayments,
    aliasName: 'loans__id__repayments__loan_id',
  );

  $$RepaymentsTableProcessedTableManager get repaymentsRefs {
    final manager = $$RepaymentsTableTableManager(
      $_db,
      $_db.repayments,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_repaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDay, LocalDay, int> get loanDate =>
      $composableBuilder(
        column: $table.loanDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LocalDay?, LocalDay, int>
  get promisedReturnDate => $composableBuilder(
    column: $table.promisedReturnDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$BorrowersTableFilterComposer get borrowerId {
    final $$BorrowersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.borrowerId,
      referencedTable: $db.borrowers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BorrowersTableFilterComposer(
            $db: $db,
            $table: $db.borrowers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> repaymentsRefs(
    Expression<bool> Function($$RepaymentsTableFilterComposer f) f,
  ) {
    final $$RepaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepaymentsTableFilterComposer(
            $db: $db,
            $table: $db.repayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loanDate => $composableBuilder(
    column: $table.loanDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promisedReturnDate => $composableBuilder(
    column: $table.promisedReturnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$BorrowersTableOrderingComposer get borrowerId {
    final $$BorrowersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.borrowerId,
      referencedTable: $db.borrowers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BorrowersTableOrderingComposer(
            $db: $db,
            $table: $db.borrowers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDay, int> get loanDate =>
      $composableBuilder(column: $table.loanDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDay?, int> get promisedReturnDate =>
      $composableBuilder(
        column: $table.promisedReturnDate,
        builder: (column) => column,
      );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$BorrowersTableAnnotationComposer get borrowerId {
    final $$BorrowersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.borrowerId,
      referencedTable: $db.borrowers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BorrowersTableAnnotationComposer(
            $db: $db,
            $table: $db.borrowers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> repaymentsRefs<T extends Object>(
    Expression<T> Function($$RepaymentsTableAnnotationComposer a) f,
  ) {
    final $$RepaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.repayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          LoanRow,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (LoanRow, $$LoansTableReferences),
          LoanRow,
          PrefetchHooks Function({bool borrowerId, bool repaymentsRefs})
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> borrowerId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<LocalDay> loanDate = const Value.absent(),
                Value<LocalDay?> promisedReturnDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                borrowerId: borrowerId,
                amountMinor: amountMinor,
                loanDate: loanDate,
                promisedReturnDate: promisedReturnDate,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int borrowerId,
                required int amountMinor,
                required LocalDay loanDate,
                Value<LocalDay?> promisedReturnDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                borrowerId: borrowerId,
                amountMinor: amountMinor,
                loanDate: loanDate,
                promisedReturnDate: promisedReturnDate,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LoansTable, LoanRow>(table),
                  $$LoansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({borrowerId = false, repaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (repaymentsRefs) db.repayments],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (borrowerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.borrowerId,
                            referencedTable: $$LoansTableReferences
                                ._borrowerIdTable(db),
                            referencedColumn: $$LoansTableReferences
                                ._borrowerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (repaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          LoanRow,
                          $LoansTable,
                          RepaymentRow,
                          $RepaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$LoansTableReferences
                              ._repaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LoansTableReferences(
                                db,
                                table,
                                p0,
                              ).repaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'loan_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      LoanRow,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (LoanRow, $$LoansTableReferences),
      LoanRow,
      PrefetchHooks Function({bool borrowerId, bool repaymentsRefs})
    >;
typedef $$RepaymentsTableCreateCompanionBuilder = RepaymentsCompanion Function({
  Value<int> id,
  required int loanId,
  required int amountMinor,
  required LocalDay repaymentDate,
  Value<String?> note,
});
typedef $$RepaymentsTableUpdateCompanionBuilder = RepaymentsCompanion Function({
  Value<int> id,
  Value<int> loanId,
  Value<int> amountMinor,
  Value<LocalDay> repaymentDate,
  Value<String?> note,
});

final class $$RepaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $RepaymentsTable, RepaymentRow> {
  $$RepaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDatabase db) =>
      db.loans.createAlias('repayments__loan_id__loans__id');

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $RepaymentsTable> {
  $$RepaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LocalDay, LocalDay, int> get repaymentDate =>
      $composableBuilder(
        column: $table.repaymentDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RepaymentsTable> {
  $$RepaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repaymentDate => $composableBuilder(
    column: $table.repaymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepaymentsTable> {
  $$RepaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LocalDay, int> get repaymentDate =>
      $composableBuilder(
        column: $table.repaymentDate,
        builder: (column) => column,
      );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RepaymentsTable,
          RepaymentRow,
          $$RepaymentsTableFilterComposer,
          $$RepaymentsTableOrderingComposer,
          $$RepaymentsTableAnnotationComposer,
          $$RepaymentsTableCreateCompanionBuilder,
          $$RepaymentsTableUpdateCompanionBuilder,
          (RepaymentRow, $$RepaymentsTableReferences),
          RepaymentRow,
          PrefetchHooks Function({bool loanId})
        > {
  $$RepaymentsTableTableManager(_$AppDatabase db, $RepaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<LocalDay> repaymentDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => RepaymentsCompanion(
                id: id,
                loanId: loanId,
                amountMinor: amountMinor,
                repaymentDate: repaymentDate,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required int amountMinor,
                required LocalDay repaymentDate,
                Value<String?> note = const Value.absent(),
              }) => RepaymentsCompanion.insert(
                id: id,
                loanId: loanId,
                amountMinor: amountMinor,
                repaymentDate: repaymentDate,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RepaymentsTable, RepaymentRow>(table),
                  $$RepaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (loanId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.loanId,
                        referencedTable: $$RepaymentsTableReferences
                            ._loanIdTable(db),
                        referencedColumn: $$RepaymentsTableReferences
                            ._loanIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RepaymentsTable,
      RepaymentRow,
      $$RepaymentsTableFilterComposer,
      $$RepaymentsTableOrderingComposer,
      $$RepaymentsTableAnnotationComposer,
      $$RepaymentsTableCreateCompanionBuilder,
      $$RepaymentsTableUpdateCompanionBuilder,
      (RepaymentRow, $$RepaymentsTableReferences),
      RepaymentRow,
      PrefetchHooks Function({bool loanId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BorrowersTableTableManager get borrowers =>
      $$BorrowersTableTableManager(_db, _db.borrowers);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$RepaymentsTableTableManager get repayments =>
      $$RepaymentsTableTableManager(_db, _db.repayments);
}
