// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, email, displayName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.email,
      required this.displayName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          String? email,
          String? displayName,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        email = Value(email),
        displayName = Value(displayName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? email,
      Value<String>? displayName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, Household> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inviteCodeMeta =
      const VerificationMeta('inviteCode');
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
      'invite_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, inviteCode, createdBy, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(Insertable<Household> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('invite_code')) {
      context.handle(
          _inviteCodeMeta,
          inviteCode.isAcceptableOrUnknown(
              data['invite_code']!, _inviteCodeMeta));
    } else if (isInserting) {
      context.missing(_inviteCodeMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Household map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Household(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      inviteCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invite_code'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class Household extends DataClass implements Insertable<Household> {
  final String id;
  final String name;
  final String inviteCode;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Household(
      {required this.id,
      required this.name,
      required this.inviteCode,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['invite_code'] = Variable<String>(inviteCode);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      name: Value(name),
      inviteCode: Value(inviteCode),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Household.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Household(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      inviteCode: serializer.fromJson<String>(json['inviteCode']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'inviteCode': serializer.toJson<String>(inviteCode),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Household copyWith(
          {String? id,
          String? name,
          String? inviteCode,
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Household(
        id: id ?? this.id,
        name: name ?? this.name,
        inviteCode: inviteCode ?? this.inviteCode,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Household copyWithCompanion(HouseholdsCompanion data) {
    return Household(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      inviteCode:
          data.inviteCode.present ? data.inviteCode.value : this.inviteCode,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Household(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, inviteCode, createdBy, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Household &&
          other.id == this.id &&
          other.name == this.name &&
          other.inviteCode == this.inviteCode &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdsCompanion extends UpdateCompanion<Household> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> inviteCode;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String id,
    required String name,
    required String inviteCode,
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        inviteCode = Value(inviteCode),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Household> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? inviteCode,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? inviteCode,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HouseholdMembersTable extends HouseholdMembers
    with TableInfo<$HouseholdMembersTable, HouseholdMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('UNIQUE REFERENCES users (id)'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<HouseholdRole, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<HouseholdRole>($HouseholdMembersTable.$converterrole);
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, householdId, userId, role, joinedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_members';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    context.handle(_roleMeta, const VerificationResult.success());
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      role: $HouseholdMembersTable.$converterrole.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at'])!,
    );
  }

  @override
  $HouseholdMembersTable createAlias(String alias) {
    return $HouseholdMembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HouseholdRole, String, String> $converterrole =
      const EnumNameConverter<HouseholdRole>(HouseholdRole.values);
}

class HouseholdMember extends DataClass implements Insertable<HouseholdMember> {
  final String id;
  final String householdId;
  final String userId;
  final HouseholdRole role;
  final DateTime joinedAt;
  const HouseholdMember(
      {required this.id,
      required this.householdId,
      required this.userId,
      required this.role,
      required this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['user_id'] = Variable<String>(userId);
    {
      map['role'] =
          Variable<String>($HouseholdMembersTable.$converterrole.toSql(role));
    }
    map['joined_at'] = Variable<DateTime>(joinedAt);
    return map;
  }

  HouseholdMembersCompanion toCompanion(bool nullToAbsent) {
    return HouseholdMembersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      userId: Value(userId),
      role: Value(role),
      joinedAt: Value(joinedAt),
    );
  }

  factory HouseholdMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdMember(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: $HouseholdMembersTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer
          .toJson<String>($HouseholdMembersTable.$converterrole.toJson(role)),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
    };
  }

  HouseholdMember copyWith(
          {String? id,
          String? householdId,
          String? userId,
          HouseholdRole? role,
          DateTime? joinedAt}) =>
      HouseholdMember(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        joinedAt: joinedAt ?? this.joinedAt,
      );
  HouseholdMember copyWithCompanion(HouseholdMembersCompanion data) {
    return HouseholdMember(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMember(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, userId, role, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdMember &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt);
}

class HouseholdMembersCompanion extends UpdateCompanion<HouseholdMember> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> userId;
  final Value<HouseholdRole> role;
  final Value<DateTime> joinedAt;
  final Value<int> rowid;
  const HouseholdMembersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdMembersCompanion.insert({
    required String id,
    required String householdId,
    required String userId,
    required HouseholdRole role,
    required DateTime joinedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        userId = Value(userId),
        role = Value(role),
        joinedAt = Value(joinedAt);
  static Insertable<HouseholdMember> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? userId,
      Value<HouseholdRole>? role,
      Value<DateTime>? joinedAt,
      Value<int>? rowid}) {
    return HouseholdMembersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
          $HouseholdMembersTable.$converterrole.toSql(role.value));
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdMembersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _purposeMeta =
      const VerificationMeta('purpose');
  @override
  late final GeneratedColumnWithTypeConverter<AccountPurpose, String> purpose =
      GeneratedColumn<String>('purpose', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AccountPurpose>($AccountsTable.$converterpurpose);
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<int> initialBalance = GeneratedColumn<int>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        name,
        type,
        purpose,
        initialBalance,
        isArchived,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    context.handle(_purposeMeta, const VerificationResult.success());
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    } else if (isInserting) {
      context.missing(_initialBalanceMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $AccountsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      purpose: $AccountsTable.$converterpurpose.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose'])!),
      initialBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}initial_balance'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
  static JsonTypeConverter2<AccountPurpose, String, String> $converterpurpose =
      const EnumNameConverter<AccountPurpose>(AccountPurpose.values);
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String householdId;
  final String name;
  final AccountType type;
  final AccountPurpose purpose;
  final int initialBalance;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  const Account(
      {required this.id,
      required this.householdId,
      required this.name,
      required this.type,
      required this.purpose,
      required this.initialBalance,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    {
      map['purpose'] =
          Variable<String>($AccountsTable.$converterpurpose.toSql(purpose));
    }
    map['initial_balance'] = Variable<int>(initialBalance);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      type: Value(type),
      purpose: Value(purpose),
      initialBalance: Value(initialBalance),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      purpose: $AccountsTable.$converterpurpose
          .fromJson(serializer.fromJson<String>(json['purpose'])),
      initialBalance: serializer.fromJson<int>(json['initialBalance']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'type':
          serializer.toJson<String>($AccountsTable.$convertertype.toJson(type)),
      'purpose': serializer
          .toJson<String>($AccountsTable.$converterpurpose.toJson(purpose)),
      'initialBalance': serializer.toJson<int>(initialBalance),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
    };
  }

  Account copyWith(
          {String? id,
          String? householdId,
          String? name,
          AccountType? type,
          AccountPurpose? purpose,
          int? initialBalance,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? createdBy,
          String? updatedBy}) =>
      Account(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        name: name ?? this.name,
        type: type ?? this.type,
        purpose: purpose ?? this.purpose,
        initialBalance: initialBalance ?? this.initialBalance,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('purpose: $purpose, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, name, type, purpose,
      initialBalance, isArchived, createdAt, updatedAt, createdBy, updatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.type == this.type &&
          other.purpose == this.purpose &&
          other.initialBalance == this.initialBalance &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<AccountPurpose> purpose;
  final Value<int> initialBalance;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.purpose = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required AccountType type,
    required AccountPurpose purpose,
    required int initialBalance,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    required String updatedBy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        name = Value(name),
        type = Value(type),
        purpose = Value(purpose),
        initialBalance = Value(initialBalance),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy),
        updatedBy = Value(updatedBy);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? purpose,
    Expression<int>? initialBalance,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (purpose != null) 'purpose': purpose,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? name,
      Value<AccountType>? type,
      Value<AccountPurpose>? purpose,
      Value<int>? initialBalance,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? createdBy,
      Value<String>? updatedBy,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      initialBalance: initialBalance ?? this.initialBalance,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(
          $AccountsTable.$converterpurpose.toSql(purpose.value));
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<int>(initialBalance.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('purpose: $purpose, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<CategoryType>($CategoriesTable.$convertertype);
  static const VerificationMeta _iconKeyMeta =
      const VerificationMeta('iconKey');
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
      'icon_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        name,
        type,
        iconKey,
        isDefault,
        isArchived,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('icon_key')) {
      context.handle(_iconKeyMeta,
          iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta));
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $CategoriesTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      iconKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_key'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryType, String, String> $convertertype =
      const EnumNameConverter<CategoryType>(CategoryType.values);
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String householdId;
  final String name;
  final CategoryType type;
  final String iconKey;
  final bool isDefault;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  const Category(
      {required this.id,
      required this.householdId,
      required this.name,
      required this.type,
      required this.iconKey,
      required this.isDefault,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    {
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type));
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      type: Value(type),
      iconKey: Value(iconKey),
      isDefault: Value(isDefault),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      type: $CategoriesTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'type': serializer
          .toJson<String>($CategoriesTable.$convertertype.toJson(type)),
      'iconKey': serializer.toJson<String>(iconKey),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
    };
  }

  Category copyWith(
          {String? id,
          String? householdId,
          String? name,
          CategoryType? type,
          String? iconKey,
          bool? isDefault,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? createdBy,
          String? updatedBy}) =>
      Category(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        name: name ?? this.name,
        type: type ?? this.type,
        iconKey: iconKey ?? this.iconKey,
        isDefault: isDefault ?? this.isDefault,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, name, type, iconKey,
      isDefault, isArchived, createdAt, updatedAt, createdBy, updatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.type == this.type &&
          other.iconKey == this.iconKey &&
          other.isDefault == this.isDefault &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<CategoryType> type;
  final Value<String> iconKey;
  final Value<bool> isDefault;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required CategoryType type,
    required String iconKey,
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    required String updatedBy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        name = Value(name),
        type = Value(type),
        iconKey = Value(iconKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy),
        updatedBy = Value(updatedBy);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? iconKey,
    Expression<bool>? isDefault,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iconKey != null) 'icon_key': iconKey,
      if (isDefault != null) 'is_default': isDefault,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? name,
      Value<CategoryType>? type,
      Value<String>? iconKey,
      Value<bool>? isDefault,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? createdBy,
      Value<String>? updatedBy,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      type: type ?? this.type,
      iconKey: iconKey ?? this.iconKey,
      isDefault: isDefault ?? this.isDefault,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type.value));
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconKey: $iconKey, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _expenseTypeMeta =
      const VerificationMeta('expenseType');
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseType?, String>
      expenseType = GeneratedColumn<String>('expense_type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<ExpenseType?>(
              $TransactionsTable.$converterexpenseTypen);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceAccountIdMeta =
      const VerificationMeta('sourceAccountId');
  @override
  late final GeneratedColumn<String> sourceAccountId = GeneratedColumn<String>(
      'source_account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>(
          'destination_account_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints:
              GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>('sync_status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SyncStatus>($TransactionsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        type,
        expenseType,
        amount,
        sourceAccountId,
        destinationAccountId,
        categoryId,
        description,
        transactionDate,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        syncStatus,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    context.handle(_expenseTypeMeta, const VerificationResult.success());
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
          _sourceAccountIdMeta,
          sourceAccountId.isAcceptableOrUnknown(
              data['source_account_id']!, _sourceAccountIdMeta));
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
          _destinationAccountIdMeta,
          destinationAccountId.isAcceptableOrUnknown(
              data['destination_account_id']!, _destinationAccountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    context.handle(_syncStatusMeta, const VerificationResult.success());
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      expenseType: $TransactionsTable.$converterexpenseTypen.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}expense_type'])),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      sourceAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}source_account_id']),
      destinationAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}destination_account_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: $TransactionsTable.$convertersyncStatus.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sync_status'])!),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<ExpenseType, String, String> $converterexpenseType =
      const EnumNameConverter<ExpenseType>(ExpenseType.values);
  static JsonTypeConverter2<ExpenseType?, String?, String?>
      $converterexpenseTypen =
      JsonTypeConverter2.asNullable($converterexpenseType);
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String householdId;
  final TransactionType type;
  final ExpenseType? expenseType;
  final int amount;
  final String? sourceAccountId;
  final String? destinationAccountId;
  final String? categoryId;
  final String? description;
  final DateTime transactionDate;
  final String createdBy;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Transaction(
      {required this.id,
      required this.householdId,
      required this.type,
      this.expenseType,
      required this.amount,
      this.sourceAccountId,
      this.destinationAccountId,
      this.categoryId,
      this.description,
      required this.transactionDate,
      required this.createdBy,
      required this.updatedBy,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || expenseType != null) {
      map['expense_type'] = Variable<String>(
          $TransactionsTable.$converterexpenseTypen.toSql(expenseType));
    }
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || sourceAccountId != null) {
      map['source_account_id'] = Variable<String>(sourceAccountId);
    }
    if (!nullToAbsent || destinationAccountId != null) {
      map['destination_account_id'] = Variable<String>(destinationAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    {
      map['sync_status'] = Variable<String>(
          $TransactionsTable.$convertersyncStatus.toSql(syncStatus));
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      type: Value(type),
      expenseType: expenseType == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseType),
      amount: Value(amount),
      sourceAccountId: sourceAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceAccountId),
      destinationAccountId: destinationAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionDate: Value(transactionDate),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      type: $TransactionsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      expenseType: $TransactionsTable.$converterexpenseTypen
          .fromJson(serializer.fromJson<String?>(json['expenseType'])),
      amount: serializer.fromJson<int>(json['amount']),
      sourceAccountId: serializer.fromJson<String?>(json['sourceAccountId']),
      destinationAccountId:
          serializer.fromJson<String?>(json['destinationAccountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      description: serializer.fromJson<String?>(json['description']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: $TransactionsTable.$convertersyncStatus
          .fromJson(serializer.fromJson<String>(json['syncStatus'])),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'type': serializer
          .toJson<String>($TransactionsTable.$convertertype.toJson(type)),
      'expenseType': serializer.toJson<String?>(
          $TransactionsTable.$converterexpenseTypen.toJson(expenseType)),
      'amount': serializer.toJson<int>(amount),
      'sourceAccountId': serializer.toJson<String?>(sourceAccountId),
      'destinationAccountId': serializer.toJson<String?>(destinationAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'description': serializer.toJson<String?>(description),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(
          $TransactionsTable.$convertersyncStatus.toJson(syncStatus)),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Transaction copyWith(
          {String? id,
          String? householdId,
          TransactionType? type,
          Value<ExpenseType?> expenseType = const Value.absent(),
          int? amount,
          Value<String?> sourceAccountId = const Value.absent(),
          Value<String?> destinationAccountId = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? transactionDate,
          String? createdBy,
          String? updatedBy,
          DateTime? createdAt,
          DateTime? updatedAt,
          SyncStatus? syncStatus,
          bool? isDeleted}) =>
      Transaction(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        type: type ?? this.type,
        expenseType: expenseType.present ? expenseType.value : this.expenseType,
        amount: amount ?? this.amount,
        sourceAccountId: sourceAccountId.present
            ? sourceAccountId.value
            : this.sourceAccountId,
        destinationAccountId: destinationAccountId.present
            ? destinationAccountId.value
            : this.destinationAccountId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        description: description.present ? description.value : this.description,
        transactionDate: transactionDate ?? this.transactionDate,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      type: data.type.present ? data.type.value : this.type,
      expenseType:
          data.expenseType.present ? data.expenseType.value : this.expenseType,
      amount: data.amount.present ? data.amount.value : this.amount,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      description:
          data.description.present ? data.description.value : this.description,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('type: $type, ')
          ..write('expenseType: $expenseType, ')
          ..write('amount: $amount, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      type,
      expenseType,
      amount,
      sourceAccountId,
      destinationAccountId,
      categoryId,
      description,
      transactionDate,
      createdBy,
      updatedBy,
      createdAt,
      updatedAt,
      syncStatus,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.type == this.type &&
          other.expenseType == this.expenseType &&
          other.amount == this.amount &&
          other.sourceAccountId == this.sourceAccountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.categoryId == this.categoryId &&
          other.description == this.description &&
          other.transactionDate == this.transactionDate &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<TransactionType> type;
  final Value<ExpenseType?> expenseType;
  final Value<int> amount;
  final Value<String?> sourceAccountId;
  final Value<String?> destinationAccountId;
  final Value<String?> categoryId;
  final Value<String?> description;
  final Value<DateTime> transactionDate;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.type = const Value.absent(),
    this.expenseType = const Value.absent(),
    this.amount = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String householdId,
    required TransactionType type,
    this.expenseType = const Value.absent(),
    required int amount,
    this.sourceAccountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime transactionDate,
    required String createdBy,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        type = Value(type),
        amount = Value(amount),
        transactionDate = Value(transactionDate),
        createdBy = Value(createdBy),
        updatedBy = Value(updatedBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        syncStatus = Value(syncStatus);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? type,
    Expression<String>? expenseType,
    Expression<int>? amount,
    Expression<String>? sourceAccountId,
    Expression<String>? destinationAccountId,
    Expression<String>? categoryId,
    Expression<String>? description,
    Expression<DateTime>? transactionDate,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (type != null) 'type': type,
      if (expenseType != null) 'expense_type': expenseType,
      if (amount != null) 'amount': amount,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<TransactionType>? type,
      Value<ExpenseType?>? expenseType,
      Value<int>? amount,
      Value<String?>? sourceAccountId,
      Value<String?>? destinationAccountId,
      Value<String?>? categoryId,
      Value<String?>? description,
      Value<DateTime>? transactionDate,
      Value<String>? createdBy,
      Value<String>? updatedBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<SyncStatus>? syncStatus,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      type: type ?? this.type,
      expenseType: expenseType ?? this.expenseType,
      amount: amount ?? this.amount,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type.value));
    }
    if (expenseType.present) {
      map['expense_type'] = Variable<String>(
          $TransactionsTable.$converterexpenseTypen.toSql(expenseType.value));
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<String>(sourceAccountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] =
          Variable<String>(destinationAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
          $TransactionsTable.$convertersyncStatus.toSql(syncStatus.value));
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('type: $type, ')
          ..write('expenseType: $expenseType, ')
          ..write('amount: $amount, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringExpensesTable extends RecurringExpenses
    with TableInfo<$RecurringExpensesTable, RecurringExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultAmountMeta =
      const VerificationMeta('defaultAmount');
  @override
  late final GeneratedColumn<int> defaultAmount = GeneratedColumn<int>(
      'default_amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _defaultAccountIdMeta =
      const VerificationMeta('defaultAccountId');
  @override
  late final GeneratedColumn<String> defaultAccountId = GeneratedColumn<String>(
      'default_account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
      'due_day', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        name,
        defaultAmount,
        categoryId,
        defaultAccountId,
        dueDay,
        isActive,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_amount')) {
      context.handle(
          _defaultAmountMeta,
          defaultAmount.isAcceptableOrUnknown(
              data['default_amount']!, _defaultAmountMeta));
    } else if (isInserting) {
      context.missing(_defaultAmountMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('default_account_id')) {
      context.handle(
          _defaultAccountIdMeta,
          defaultAccountId.isAcceptableOrUnknown(
              data['default_account_id']!, _defaultAccountIdMeta));
    }
    if (data.containsKey('due_day')) {
      context.handle(_dueDayMeta,
          dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      defaultAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_amount'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      defaultAccountId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_account_id']),
      dueDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}due_day']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
    );
  }

  @override
  $RecurringExpensesTable createAlias(String alias) {
    return $RecurringExpensesTable(attachedDatabase, alias);
  }
}

class RecurringExpense extends DataClass
    implements Insertable<RecurringExpense> {
  final String id;
  final String householdId;
  final String name;
  final int defaultAmount;
  final String categoryId;
  final String? defaultAccountId;
  final int? dueDay;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  const RecurringExpense(
      {required this.id,
      required this.householdId,
      required this.name,
      required this.defaultAmount,
      required this.categoryId,
      this.defaultAccountId,
      this.dueDay,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['default_amount'] = Variable<int>(defaultAmount);
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || defaultAccountId != null) {
      map['default_account_id'] = Variable<String>(defaultAccountId);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    return map;
  }

  RecurringExpensesCompanion toCompanion(bool nullToAbsent) {
    return RecurringExpensesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      defaultAmount: Value(defaultAmount),
      categoryId: Value(categoryId),
      defaultAccountId: defaultAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultAccountId),
      dueDay:
          dueDay == null && nullToAbsent ? const Value.absent() : Value(dueDay),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
    );
  }

  factory RecurringExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringExpense(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      name: serializer.fromJson<String>(json['name']),
      defaultAmount: serializer.fromJson<int>(json['defaultAmount']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      defaultAccountId: serializer.fromJson<String?>(json['defaultAccountId']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'defaultAmount': serializer.toJson<int>(defaultAmount),
      'categoryId': serializer.toJson<String>(categoryId),
      'defaultAccountId': serializer.toJson<String?>(defaultAccountId),
      'dueDay': serializer.toJson<int?>(dueDay),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
    };
  }

  RecurringExpense copyWith(
          {String? id,
          String? householdId,
          String? name,
          int? defaultAmount,
          String? categoryId,
          Value<String?> defaultAccountId = const Value.absent(),
          Value<int?> dueDay = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? createdBy,
          String? updatedBy}) =>
      RecurringExpense(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        name: name ?? this.name,
        defaultAmount: defaultAmount ?? this.defaultAmount,
        categoryId: categoryId ?? this.categoryId,
        defaultAccountId: defaultAccountId.present
            ? defaultAccountId.value
            : this.defaultAccountId,
        dueDay: dueDay.present ? dueDay.value : this.dueDay,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
      );
  RecurringExpense copyWithCompanion(RecurringExpensesCompanion data) {
    return RecurringExpense(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      defaultAmount: data.defaultAmount.present
          ? data.defaultAmount.value
          : this.defaultAmount,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      defaultAccountId: data.defaultAccountId.present
          ? data.defaultAccountId.value
          : this.defaultAccountId,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpense(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('defaultAmount: $defaultAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultAccountId: $defaultAccountId, ')
          ..write('dueDay: $dueDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      name,
      defaultAmount,
      categoryId,
      defaultAccountId,
      dueDay,
      isActive,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringExpense &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.defaultAmount == this.defaultAmount &&
          other.categoryId == this.categoryId &&
          other.defaultAccountId == this.defaultAccountId &&
          other.dueDay == this.dueDay &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy);
}

class RecurringExpensesCompanion extends UpdateCompanion<RecurringExpense> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<int> defaultAmount;
  final Value<String> categoryId;
  final Value<String?> defaultAccountId;
  final Value<int?> dueDay;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<int> rowid;
  const RecurringExpensesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultAmount = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.defaultAccountId = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringExpensesCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required int defaultAmount,
    required String categoryId,
    this.defaultAccountId = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    required String updatedBy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        name = Value(name),
        defaultAmount = Value(defaultAmount),
        categoryId = Value(categoryId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy),
        updatedBy = Value(updatedBy);
  static Insertable<RecurringExpense> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<int>? defaultAmount,
    Expression<String>? categoryId,
    Expression<String>? defaultAccountId,
    Expression<int>? dueDay,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (defaultAmount != null) 'default_amount': defaultAmount,
      if (categoryId != null) 'category_id': categoryId,
      if (defaultAccountId != null) 'default_account_id': defaultAccountId,
      if (dueDay != null) 'due_day': dueDay,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? name,
      Value<int>? defaultAmount,
      Value<String>? categoryId,
      Value<String?>? defaultAccountId,
      Value<int?>? dueDay,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? createdBy,
      Value<String>? updatedBy,
      Value<int>? rowid}) {
    return RecurringExpensesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      defaultAmount: defaultAmount ?? this.defaultAmount,
      categoryId: categoryId ?? this.categoryId,
      defaultAccountId: defaultAccountId ?? this.defaultAccountId,
      dueDay: dueDay ?? this.dueDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultAmount.present) {
      map['default_amount'] = Variable<int>(defaultAmount.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (defaultAccountId.present) {
      map['default_account_id'] = Variable<String>(defaultAccountId.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringExpensesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('defaultAmount: $defaultAmount, ')
          ..write('categoryId: $categoryId, ')
          ..write('defaultAccountId: $defaultAccountId, ')
          ..write('dueDay: $dueDay, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringPaymentsTable extends RecurringPayments
    with TableInfo<$RecurringPaymentsTable, RecurringPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdIdMeta =
      const VerificationMeta('householdId');
  @override
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
      'household_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES households (id)'));
  static const VerificationMeta _recurringExpenseIdMeta =
      const VerificationMeta('recurringExpenseId');
  @override
  late final GeneratedColumn<String> recurringExpenseId =
      GeneratedColumn<String>('recurring_expense_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES recurring_expenses (id)'));
  static const VerificationMeta _periodYearMeta =
      const VerificationMeta('periodYear');
  @override
  late final GeneratedColumn<int> periodYear = GeneratedColumn<int>(
      'period_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _periodMonthMeta =
      const VerificationMeta('periodMonth');
  @override
  late final GeneratedColumn<int> periodMonth = GeneratedColumn<int>(
      'period_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<RecurringPaymentStatus, String>
      status = GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RecurringPaymentStatus>(
              $RecurringPaymentsTable.$converterstatus);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        householdId,
        recurringExpenseId,
        periodYear,
        periodMonth,
        status,
        transactionId,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_payments';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
          _householdIdMeta,
          householdId.isAcceptableOrUnknown(
              data['household_id']!, _householdIdMeta));
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('recurring_expense_id')) {
      context.handle(
          _recurringExpenseIdMeta,
          recurringExpenseId.isAcceptableOrUnknown(
              data['recurring_expense_id']!, _recurringExpenseIdMeta));
    } else if (isInserting) {
      context.missing(_recurringExpenseIdMeta);
    }
    if (data.containsKey('period_year')) {
      context.handle(
          _periodYearMeta,
          periodYear.isAcceptableOrUnknown(
              data['period_year']!, _periodYearMeta));
    } else if (isInserting) {
      context.missing(_periodYearMeta);
    }
    if (data.containsKey('period_month')) {
      context.handle(
          _periodMonthMeta,
          periodMonth.isAcceptableOrUnknown(
              data['period_month']!, _periodMonthMeta));
    } else if (isInserting) {
      context.missing(_periodMonthMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {recurringExpenseId, periodYear, periodMonth},
      ];
  @override
  RecurringPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      householdId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_id'])!,
      recurringExpenseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_expense_id'])!,
      periodYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_year'])!,
      periodMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_month'])!,
      status: $RecurringPaymentsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
    );
  }

  @override
  $RecurringPaymentsTable createAlias(String alias) {
    return $RecurringPaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecurringPaymentStatus, String, String>
      $converterstatus = const EnumNameConverter<RecurringPaymentStatus>(
          RecurringPaymentStatus.values);
}

class RecurringPayment extends DataClass
    implements Insertable<RecurringPayment> {
  final String id;
  final String householdId;
  final String recurringExpenseId;
  final int periodYear;
  final int periodMonth;
  final RecurringPaymentStatus status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  const RecurringPayment(
      {required this.id,
      required this.householdId,
      required this.recurringExpenseId,
      required this.periodYear,
      required this.periodMonth,
      required this.status,
      this.transactionId,
      required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['recurring_expense_id'] = Variable<String>(recurringExpenseId);
    map['period_year'] = Variable<int>(periodYear);
    map['period_month'] = Variable<int>(periodMonth);
    {
      map['status'] = Variable<String>(
          $RecurringPaymentsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    return map;
  }

  RecurringPaymentsCompanion toCompanion(bool nullToAbsent) {
    return RecurringPaymentsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      recurringExpenseId: Value(recurringExpenseId),
      periodYear: Value(periodYear),
      periodMonth: Value(periodMonth),
      status: Value(status),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
    );
  }

  factory RecurringPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringPayment(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['householdId']),
      recurringExpenseId:
          serializer.fromJson<String>(json['recurringExpenseId']),
      periodYear: serializer.fromJson<int>(json['periodYear']),
      periodMonth: serializer.fromJson<int>(json['periodMonth']),
      status: $RecurringPaymentsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'householdId': serializer.toJson<String>(householdId),
      'recurringExpenseId': serializer.toJson<String>(recurringExpenseId),
      'periodYear': serializer.toJson<int>(periodYear),
      'periodMonth': serializer.toJson<int>(periodMonth),
      'status': serializer.toJson<String>(
          $RecurringPaymentsTable.$converterstatus.toJson(status)),
      'transactionId': serializer.toJson<String?>(transactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
    };
  }

  RecurringPayment copyWith(
          {String? id,
          String? householdId,
          String? recurringExpenseId,
          int? periodYear,
          int? periodMonth,
          RecurringPaymentStatus? status,
          Value<String?> transactionId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? createdBy,
          String? updatedBy}) =>
      RecurringPayment(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        recurringExpenseId: recurringExpenseId ?? this.recurringExpenseId,
        periodYear: periodYear ?? this.periodYear,
        periodMonth: periodMonth ?? this.periodMonth,
        status: status ?? this.status,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
      );
  RecurringPayment copyWithCompanion(RecurringPaymentsCompanion data) {
    return RecurringPayment(
      id: data.id.present ? data.id.value : this.id,
      householdId:
          data.householdId.present ? data.householdId.value : this.householdId,
      recurringExpenseId: data.recurringExpenseId.present
          ? data.recurringExpenseId.value
          : this.recurringExpenseId,
      periodYear:
          data.periodYear.present ? data.periodYear.value : this.periodYear,
      periodMonth:
          data.periodMonth.present ? data.periodMonth.value : this.periodMonth,
      status: data.status.present ? data.status.value : this.status,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPayment(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('recurringExpenseId: $recurringExpenseId, ')
          ..write('periodYear: $periodYear, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('status: $status, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      householdId,
      recurringExpenseId,
      periodYear,
      periodMonth,
      status,
      transactionId,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringPayment &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.recurringExpenseId == this.recurringExpenseId &&
          other.periodYear == this.periodYear &&
          other.periodMonth == this.periodMonth &&
          other.status == this.status &&
          other.transactionId == this.transactionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy);
}

class RecurringPaymentsCompanion extends UpdateCompanion<RecurringPayment> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> recurringExpenseId;
  final Value<int> periodYear;
  final Value<int> periodMonth;
  final Value<RecurringPaymentStatus> status;
  final Value<String?> transactionId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<int> rowid;
  const RecurringPaymentsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.recurringExpenseId = const Value.absent(),
    this.periodYear = const Value.absent(),
    this.periodMonth = const Value.absent(),
    this.status = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringPaymentsCompanion.insert({
    required String id,
    required String householdId,
    required String recurringExpenseId,
    required int periodYear,
    required int periodMonth,
    required RecurringPaymentStatus status,
    this.transactionId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    required String updatedBy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        householdId = Value(householdId),
        recurringExpenseId = Value(recurringExpenseId),
        periodYear = Value(periodYear),
        periodMonth = Value(periodMonth),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        createdBy = Value(createdBy),
        updatedBy = Value(updatedBy);
  static Insertable<RecurringPayment> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? recurringExpenseId,
    Expression<int>? periodYear,
    Expression<int>? periodMonth,
    Expression<String>? status,
    Expression<String>? transactionId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (recurringExpenseId != null)
        'recurring_expense_id': recurringExpenseId,
      if (periodYear != null) 'period_year': periodYear,
      if (periodMonth != null) 'period_month': periodMonth,
      if (status != null) 'status': status,
      if (transactionId != null) 'transaction_id': transactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? householdId,
      Value<String>? recurringExpenseId,
      Value<int>? periodYear,
      Value<int>? periodMonth,
      Value<RecurringPaymentStatus>? status,
      Value<String?>? transactionId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? createdBy,
      Value<String>? updatedBy,
      Value<int>? rowid}) {
    return RecurringPaymentsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      recurringExpenseId: recurringExpenseId ?? this.recurringExpenseId,
      periodYear: periodYear ?? this.periodYear,
      periodMonth: periodMonth ?? this.periodMonth,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (recurringExpenseId.present) {
      map['recurring_expense_id'] = Variable<String>(recurringExpenseId.value);
    }
    if (periodYear.present) {
      map['period_year'] = Variable<int>(periodYear.value);
    }
    if (periodMonth.present) {
      map['period_month'] = Variable<int>(periodMonth.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $RecurringPaymentsTable.$converterstatus.toSql(status.value));
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('recurringExpenseId: $recurringExpenseId, ')
          ..write('periodYear: $periodYear, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('status: $status, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $HouseholdMembersTable householdMembers =
      $HouseholdMembersTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $RecurringExpensesTable recurringExpenses =
      $RecurringExpensesTable(this);
  late final $RecurringPaymentsTable recurringPayments =
      $RecurringPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        households,
        householdMembers,
        accounts,
        categories,
        transactions,
        recurringExpenses,
        recurringPayments
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String email,
  required String displayName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> email,
  Value<String> displayName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HouseholdMembersTable, List<HouseholdMember>>
      _householdMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.householdMembers,
              aliasName: $_aliasNameGenerator(
                  db.users.id, db.householdMembers.userId));

  $$HouseholdMembersTableProcessedTableManager get householdMembersRefs {
    final manager =
        $$HouseholdMembersTableTableManager($_db, $_db.householdMembers)
            .filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> householdMembersRefs(
      Expression<bool> Function($$HouseholdMembersTableFilterComposer f) f) {
    final $$HouseholdMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMembers,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMembersTableFilterComposer(
              $db: $db,
              $table: $db.householdMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> householdMembersRefs<T extends Object>(
      Expression<T> Function($$HouseholdMembersTableAnnotationComposer a) f) {
    final $$HouseholdMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMembers,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.householdMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool householdMembersRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            displayName: displayName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String email,
            required String displayName,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            displayName: displayName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({householdMembersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (householdMembersRefs) db.householdMembers
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdMembersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UsersTableReferences
                            ._householdMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .householdMembersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool householdMembersRefs})>;
typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  required String id,
  required String name,
  required String inviteCode,
  required String createdBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> inviteCode,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$HouseholdsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdsTable, Household> {
  $$HouseholdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HouseholdMembersTable, List<HouseholdMember>>
      _householdMembersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.householdMembers,
              aliasName: $_aliasNameGenerator(
                  db.households.id, db.householdMembers.householdId));

  $$HouseholdMembersTableProcessedTableManager get householdMembersRefs {
    final manager = $$HouseholdMembersTableTableManager(
            $_db, $_db.householdMembers)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_householdMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.accounts,
          aliasName:
              $_aliasNameGenerator(db.households.id, db.accounts.householdId));

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CategoriesTable, List<Category>>
      _categoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.categories,
              aliasName: $_aliasNameGenerator(
                  db.households.id, db.categories.householdId));

  $$CategoriesTableProcessedTableManager get categoriesRefs {
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.households.id, db.transactions.householdId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecurringExpensesTable, List<RecurringExpense>>
      _recurringExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringExpenses,
              aliasName: $_aliasNameGenerator(
                  db.households.id, db.recurringExpenses.householdId));

  $$RecurringExpensesTableProcessedTableManager get recurringExpensesRefs {
    final manager = $$RecurringExpensesTableTableManager(
            $_db, $_db.recurringExpenses)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecurringPaymentsTable, List<RecurringPayment>>
      _recurringPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringPayments,
              aliasName: $_aliasNameGenerator(
                  db.households.id, db.recurringPayments.householdId));

  $$RecurringPaymentsTableProcessedTableManager get recurringPaymentsRefs {
    final manager = $$RecurringPaymentsTableTableManager(
            $_db, $_db.recurringPayments)
        .filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> householdMembersRefs(
      Expression<bool> Function($$HouseholdMembersTableFilterComposer f) f) {
    final $$HouseholdMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMembers,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMembersTableFilterComposer(
              $db: $db,
              $table: $db.householdMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> accountsRefs(
      Expression<bool> Function($$AccountsTableFilterComposer f) f) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> categoriesRefs(
      Expression<bool> Function($$CategoriesTableFilterComposer f) f) {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recurringExpensesRefs(
      Expression<bool> Function($$RecurringExpensesTableFilterComposer f) f) {
    final $$RecurringExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringExpenses,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringExpensesTableFilterComposer(
              $db: $db,
              $table: $db.recurringExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recurringPaymentsRefs(
      Expression<bool> Function($$RecurringPaymentsTableFilterComposer f) f) {
    final $$RecurringPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringPayments,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.recurringPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get inviteCode => $composableBuilder(
      column: $table.inviteCode, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> householdMembersRefs<T extends Object>(
      Expression<T> Function($$HouseholdMembersTableAnnotationComposer a) f) {
    final $$HouseholdMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.householdMembers,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.householdMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> accountsRefs<T extends Object>(
      Expression<T> Function($$AccountsTableAnnotationComposer a) f) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> categoriesRefs<T extends Object>(
      Expression<T> Function($$CategoriesTableAnnotationComposer a) f) {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.householdId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> recurringExpensesRefs<T extends Object>(
      Expression<T> Function($$RecurringExpensesTableAnnotationComposer a) f) {
    final $$RecurringExpensesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringExpenses,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringExpensesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringExpenses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> recurringPaymentsRefs<T extends Object>(
      Expression<T> Function($$RecurringPaymentsTableAnnotationComposer a) f) {
    final $$RecurringPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringPayments,
            getReferencedColumn: (t) => t.householdId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function(
        {bool householdMembersRefs,
        bool accountsRefs,
        bool categoriesRefs,
        bool transactionsRefs,
        bool recurringExpensesRefs,
        bool recurringPaymentsRefs})> {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> inviteCode = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion(
            id: id,
            name: name,
            inviteCode: inviteCode,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String inviteCode,
            required String createdBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion.insert(
            id: id,
            name: name,
            inviteCode: inviteCode,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdMembersRefs = false,
              accountsRefs = false,
              categoriesRefs = false,
              transactionsRefs = false,
              recurringExpensesRefs = false,
              recurringPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (householdMembersRefs) db.householdMembers,
                if (accountsRefs) db.accounts,
                if (categoriesRefs) db.categories,
                if (transactionsRefs) db.transactions,
                if (recurringExpensesRefs) db.recurringExpenses,
                if (recurringPaymentsRefs) db.recurringPayments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (householdMembersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._householdMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .householdMembersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (accountsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$HouseholdsTableReferences._accountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .accountsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (categoriesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._categoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .categoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (recurringExpensesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._recurringExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .recurringExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items),
                  if (recurringPaymentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$HouseholdsTableReferences
                            ._recurringPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .recurringPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.householdId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function(
        {bool householdMembersRefs,
        bool accountsRefs,
        bool categoriesRefs,
        bool transactionsRefs,
        bool recurringExpensesRefs,
        bool recurringPaymentsRefs})>;
typedef $$HouseholdMembersTableCreateCompanionBuilder
    = HouseholdMembersCompanion Function({
  required String id,
  required String householdId,
  required String userId,
  required HouseholdRole role,
  required DateTime joinedAt,
  Value<int> rowid,
});
typedef $$HouseholdMembersTableUpdateCompanionBuilder
    = HouseholdMembersCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> userId,
  Value<HouseholdRole> role,
  Value<DateTime> joinedAt,
  Value<int> rowid,
});

final class $$HouseholdMembersTableReferences extends BaseReferences<
    _$AppDatabase, $HouseholdMembersTable, HouseholdMember> {
  $$HouseholdMembersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias($_aliasNameGenerator(
          db.householdMembers.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users.createAlias(
      $_aliasNameGenerator(db.householdMembers.userId, db.users.id));

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HouseholdMembersTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<HouseholdRole, HouseholdRole, String>
      get role => $composableBuilder(
          column: $table.role,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdMembersTable> {
  $$HouseholdMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HouseholdRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HouseholdMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMember,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (HouseholdMember, $$HouseholdMembersTableReferences),
    HouseholdMember,
    PrefetchHooks Function({bool householdId, bool userId})> {
  $$HouseholdMembersTableTableManager(
      _$AppDatabase db, $HouseholdMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<HouseholdRole> role = const Value.absent(),
            Value<DateTime> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion(
            id: id,
            householdId: householdId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String userId,
            required HouseholdRole role,
            required DateTime joinedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdMembersCompanion.insert(
            id: id,
            householdId: householdId,
            userId: userId,
            role: role,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$HouseholdMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({householdId = false, userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$HouseholdMembersTableReferences._householdIdTable(db),
                    referencedColumn: $$HouseholdMembersTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$HouseholdMembersTableReferences._userIdTable(db),
                    referencedColumn:
                        $$HouseholdMembersTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HouseholdMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdMembersTable,
    HouseholdMember,
    $$HouseholdMembersTableFilterComposer,
    $$HouseholdMembersTableOrderingComposer,
    $$HouseholdMembersTableAnnotationComposer,
    $$HouseholdMembersTableCreateCompanionBuilder,
    $$HouseholdMembersTableUpdateCompanionBuilder,
    (HouseholdMember, $$HouseholdMembersTableReferences),
    HouseholdMember,
    PrefetchHooks Function({bool householdId, bool userId})>;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String householdId,
  required String name,
  required AccountType type,
  required AccountPurpose purpose,
  required int initialBalance,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String createdBy,
  required String updatedBy,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> name,
  Value<AccountType> type,
  Value<AccountPurpose> purpose,
  Value<int> initialBalance,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<int> rowid,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias(
          $_aliasNameGenerator(db.accounts.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RecurringExpensesTable, List<RecurringExpense>>
      _recurringExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringExpenses,
              aliasName: $_aliasNameGenerator(
                  db.accounts.id, db.recurringExpenses.defaultAccountId));

  $$RecurringExpensesTableProcessedTableManager get recurringExpensesRefs {
    final manager =
        $$RecurringExpensesTableTableManager($_db, $_db.recurringExpenses)
            .filter((f) =>
                f.defaultAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<AccountPurpose, AccountPurpose, String>
      get purpose => $composableBuilder(
          column: $table.purpose,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> recurringExpensesRefs(
      Expression<bool> Function($$RecurringExpensesTableFilterComposer f) f) {
    final $$RecurringExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringExpenses,
        getReferencedColumn: (t) => t.defaultAccountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringExpensesTableFilterComposer(
              $db: $db,
              $table: $db.recurringExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountPurpose, String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get initialBalance => $composableBuilder(
      column: $table.initialBalance, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> recurringExpensesRefs<T extends Object>(
      Expression<T> Function($$RecurringExpensesTableAnnotationComposer a) f) {
    final $$RecurringExpensesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringExpenses,
            getReferencedColumn: (t) => t.defaultAccountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringExpensesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringExpenses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool householdId, bool recurringExpensesRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<AccountType> type = const Value.absent(),
            Value<AccountPurpose> purpose = const Value.absent(),
            Value<int> initialBalance = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            householdId: householdId,
            name: name,
            type: type,
            purpose: purpose,
            initialBalance: initialBalance,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String name,
            required AccountType type,
            required AccountPurpose purpose,
            required int initialBalance,
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required String createdBy,
            required String updatedBy,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            householdId: householdId,
            name: name,
            type: type,
            purpose: purpose,
            initialBalance: initialBalance,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AccountsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false, recurringExpensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurringExpensesRefs) db.recurringExpenses
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$AccountsTableReferences._householdIdTable(db),
                    referencedColumn:
                        $$AccountsTableReferences._householdIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurringExpensesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._recurringExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .recurringExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.defaultAccountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function({bool householdId, bool recurringExpensesRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String householdId,
  required String name,
  required CategoryType type,
  required String iconKey,
  Value<bool> isDefault,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String createdBy,
  required String updatedBy,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> name,
  Value<CategoryType> type,
  Value<String> iconKey,
  Value<bool> isDefault,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias(
          $_aliasNameGenerator(db.categories.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.transactions.categoryId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecurringExpensesTable, List<RecurringExpense>>
      _recurringExpensesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringExpenses,
              aliasName: $_aliasNameGenerator(
                  db.categories.id, db.recurringExpenses.categoryId));

  $$RecurringExpensesTableProcessedTableManager get recurringExpensesRefs {
    final manager = $$RecurringExpensesTableTableManager(
            $_db, $_db.recurringExpenses)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringExpensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CategoryType, CategoryType, String> get type =>
      $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> recurringExpensesRefs(
      Expression<bool> Function($$RecurringExpensesTableFilterComposer f) f) {
    final $$RecurringExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringExpenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringExpensesTableFilterComposer(
              $db: $db,
              $table: $db.recurringExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconKey => $composableBuilder(
      column: $table.iconKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> recurringExpensesRefs<T extends Object>(
      Expression<T> Function($$RecurringExpensesTableAnnotationComposer a) f) {
    final $$RecurringExpensesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringExpenses,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringExpensesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringExpenses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool householdId,
        bool transactionsRefs,
        bool recurringExpensesRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<CategoryType> type = const Value.absent(),
            Value<String> iconKey = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            householdId: householdId,
            name: name,
            type: type,
            iconKey: iconKey,
            isDefault: isDefault,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String name,
            required CategoryType type,
            required String iconKey,
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required String createdBy,
            required String updatedBy,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            householdId: householdId,
            name: name,
            type: type,
            iconKey: iconKey,
            isDefault: isDefault,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              transactionsRefs = false,
              recurringExpensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (recurringExpensesRefs) db.recurringExpenses
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$CategoriesTableReferences._householdIdTable(db),
                    referencedColumn:
                        $$CategoriesTableReferences._householdIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (recurringExpensesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoriesTableReferences
                            ._recurringExpensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .recurringExpensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function(
        {bool householdId, bool transactionsRefs, bool recurringExpensesRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String householdId,
  required TransactionType type,
  Value<ExpenseType?> expenseType,
  required int amount,
  Value<String?> sourceAccountId,
  Value<String?> destinationAccountId,
  Value<String?> categoryId,
  Value<String?> description,
  required DateTime transactionDate,
  required String createdBy,
  required String updatedBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  required SyncStatus syncStatus,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> householdId,
  Value<TransactionType> type,
  Value<ExpenseType?> expenseType,
  Value<int> amount,
  Value<String?> sourceAccountId,
  Value<String?> destinationAccountId,
  Value<String?> categoryId,
  Value<String?> description,
  Value<DateTime> transactionDate,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<SyncStatus> syncStatus,
  Value<bool> isDeleted,
  Value<int> rowid,
});

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias(
          $_aliasNameGenerator(db.transactions.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _sourceAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias($_aliasNameGenerator(
          db.transactions.sourceAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get sourceAccountId {
    final $_column = $_itemColumn<String>('source_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _destinationAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias($_aliasNameGenerator(
          db.transactions.destinationAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get destinationAccountId {
    final $_column = $_itemColumn<String>('destination_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item =
        $_typedResult.readTableOrNull(_destinationAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.transactions.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RecurringPaymentsTable, List<RecurringPayment>>
      _recurringPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringPayments,
              aliasName: $_aliasNameGenerator(
                  db.transactions.id, db.recurringPayments.transactionId));

  $$RecurringPaymentsTableProcessedTableManager get recurringPaymentsRefs {
    final manager = $$RecurringPaymentsTableTableManager(
            $_db, $_db.recurringPayments)
        .filter(
            (f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<ExpenseType?, ExpenseType, String>
      get expenseType => $composableBuilder(
          column: $table.expenseType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
      get syncStatus => $composableBuilder(
          column: $table.syncStatus,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get sourceAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get destinationAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> recurringPaymentsRefs(
      Expression<bool> Function($$RecurringPaymentsTableFilterComposer f) f) {
    final $$RecurringPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringPayments,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.recurringPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get expenseType => $composableBuilder(
      column: $table.expenseType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get sourceAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get destinationAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseType?, String> get expenseType =>
      $composableBuilder(
          column: $table.expenseType, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
          column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get sourceAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get destinationAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> recurringPaymentsRefs<T extends Object>(
      Expression<T> Function($$RecurringPaymentsTableAnnotationComposer a) f) {
    final $$RecurringPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringPayments,
            getReferencedColumn: (t) => t.transactionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool householdId,
        bool sourceAccountId,
        bool destinationAccountId,
        bool categoryId,
        bool recurringPaymentsRefs})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<ExpenseType?> expenseType = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String?> sourceAccountId = const Value.absent(),
            Value<String?> destinationAccountId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<SyncStatus> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            householdId: householdId,
            type: type,
            expenseType: expenseType,
            amount: amount,
            sourceAccountId: sourceAccountId,
            destinationAccountId: destinationAccountId,
            categoryId: categoryId,
            description: description,
            transactionDate: transactionDate,
            createdBy: createdBy,
            updatedBy: updatedBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required TransactionType type,
            Value<ExpenseType?> expenseType = const Value.absent(),
            required int amount,
            Value<String?> sourceAccountId = const Value.absent(),
            Value<String?> destinationAccountId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required DateTime transactionDate,
            required String createdBy,
            required String updatedBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            required SyncStatus syncStatus,
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            householdId: householdId,
            type: type,
            expenseType: expenseType,
            amount: amount,
            sourceAccountId: sourceAccountId,
            destinationAccountId: destinationAccountId,
            categoryId: categoryId,
            description: description,
            transactionDate: transactionDate,
            createdBy: createdBy,
            updatedBy: updatedBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              sourceAccountId = false,
              destinationAccountId = false,
              categoryId = false,
              recurringPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurringPaymentsRefs) db.recurringPayments
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable:
                        $$TransactionsTableReferences._householdIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._householdIdTable(db).id,
                  ) as T;
                }
                if (sourceAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceAccountId,
                    referencedTable:
                        $$TransactionsTableReferences._sourceAccountIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._sourceAccountIdTable(db)
                        .id,
                  ) as T;
                }
                if (destinationAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.destinationAccountId,
                    referencedTable: $$TransactionsTableReferences
                        ._destinationAccountIdTable(db),
                    referencedColumn: $$TransactionsTableReferences
                        ._destinationAccountIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurringPaymentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._recurringPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .recurringPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (Transaction, $$TransactionsTableReferences),
    Transaction,
    PrefetchHooks Function(
        {bool householdId,
        bool sourceAccountId,
        bool destinationAccountId,
        bool categoryId,
        bool recurringPaymentsRefs})>;
typedef $$RecurringExpensesTableCreateCompanionBuilder
    = RecurringExpensesCompanion Function({
  required String id,
  required String householdId,
  required String name,
  required int defaultAmount,
  required String categoryId,
  Value<String?> defaultAccountId,
  Value<int?> dueDay,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String createdBy,
  required String updatedBy,
  Value<int> rowid,
});
typedef $$RecurringExpensesTableUpdateCompanionBuilder
    = RecurringExpensesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> name,
  Value<int> defaultAmount,
  Value<String> categoryId,
  Value<String?> defaultAccountId,
  Value<int?> dueDay,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<int> rowid,
});

final class $$RecurringExpensesTableReferences extends BaseReferences<
    _$AppDatabase, $RecurringExpensesTable, RecurringExpense> {
  $$RecurringExpensesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias($_aliasNameGenerator(
          db.recurringExpenses.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias($_aliasNameGenerator(
          db.recurringExpenses.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AccountsTable _defaultAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias($_aliasNameGenerator(
          db.recurringExpenses.defaultAccountId, db.accounts.id));

  $$AccountsTableProcessedTableManager? get defaultAccountId {
    final $_column = $_itemColumn<String>('default_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RecurringPaymentsTable, List<RecurringPayment>>
      _recurringPaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurringPayments,
              aliasName: $_aliasNameGenerator(db.recurringExpenses.id,
                  db.recurringPayments.recurringExpenseId));

  $$RecurringPaymentsTableProcessedTableManager get recurringPaymentsRefs {
    final manager =
        $$RecurringPaymentsTableTableManager($_db, $_db.recurringPayments)
            .filter((f) =>
                f.recurringExpenseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_recurringPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecurringExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultAmount => $composableBuilder(
      column: $table.defaultAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableFilterComposer get defaultAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> recurringPaymentsRefs(
      Expression<bool> Function($$RecurringPaymentsTableFilterComposer f) f) {
    final $$RecurringPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurringPayments,
        getReferencedColumn: (t) => t.recurringExpenseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.recurringPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecurringExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultAmount => $composableBuilder(
      column: $table.defaultAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dueDay => $composableBuilder(
      column: $table.dueDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableOrderingComposer get defaultAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurringExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringExpensesTable> {
  $$RecurringExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get defaultAmount => $composableBuilder(
      column: $table.defaultAmount, builder: (column) => column);

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AccountsTableAnnotationComposer get defaultAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.defaultAccountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> recurringPaymentsRefs<T extends Object>(
      Expression<T> Function($$RecurringPaymentsTableAnnotationComposer a) f) {
    final $$RecurringPaymentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recurringPayments,
            getReferencedColumn: (t) => t.recurringExpenseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringPaymentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringPayments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RecurringExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringExpensesTable,
    RecurringExpense,
    $$RecurringExpensesTableFilterComposer,
    $$RecurringExpensesTableOrderingComposer,
    $$RecurringExpensesTableAnnotationComposer,
    $$RecurringExpensesTableCreateCompanionBuilder,
    $$RecurringExpensesTableUpdateCompanionBuilder,
    (RecurringExpense, $$RecurringExpensesTableReferences),
    RecurringExpense,
    PrefetchHooks Function(
        {bool householdId,
        bool categoryId,
        bool defaultAccountId,
        bool recurringPaymentsRefs})> {
  $$RecurringExpensesTableTableManager(
      _$AppDatabase db, $RecurringExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringExpensesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> defaultAmount = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String?> defaultAccountId = const Value.absent(),
            Value<int?> dueDay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringExpensesCompanion(
            id: id,
            householdId: householdId,
            name: name,
            defaultAmount: defaultAmount,
            categoryId: categoryId,
            defaultAccountId: defaultAccountId,
            dueDay: dueDay,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String name,
            required int defaultAmount,
            required String categoryId,
            Value<String?> defaultAccountId = const Value.absent(),
            Value<int?> dueDay = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required String createdBy,
            required String updatedBy,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringExpensesCompanion.insert(
            id: id,
            householdId: householdId,
            name: name,
            defaultAmount: defaultAmount,
            categoryId: categoryId,
            defaultAccountId: defaultAccountId,
            dueDay: dueDay,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecurringExpensesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              categoryId = false,
              defaultAccountId = false,
              recurringPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurringPaymentsRefs) db.recurringPayments
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$RecurringExpensesTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$RecurringExpensesTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$RecurringExpensesTableReferences._categoryIdTable(db),
                    referencedColumn: $$RecurringExpensesTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (defaultAccountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.defaultAccountId,
                    referencedTable: $$RecurringExpensesTableReferences
                        ._defaultAccountIdTable(db),
                    referencedColumn: $$RecurringExpensesTableReferences
                        ._defaultAccountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurringPaymentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$RecurringExpensesTableReferences
                            ._recurringPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecurringExpensesTableReferences(db, table, p0)
                                .recurringPaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.recurringExpenseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecurringExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringExpensesTable,
    RecurringExpense,
    $$RecurringExpensesTableFilterComposer,
    $$RecurringExpensesTableOrderingComposer,
    $$RecurringExpensesTableAnnotationComposer,
    $$RecurringExpensesTableCreateCompanionBuilder,
    $$RecurringExpensesTableUpdateCompanionBuilder,
    (RecurringExpense, $$RecurringExpensesTableReferences),
    RecurringExpense,
    PrefetchHooks Function(
        {bool householdId,
        bool categoryId,
        bool defaultAccountId,
        bool recurringPaymentsRefs})>;
typedef $$RecurringPaymentsTableCreateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  required String id,
  required String householdId,
  required String recurringExpenseId,
  required int periodYear,
  required int periodMonth,
  required RecurringPaymentStatus status,
  Value<String?> transactionId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required String createdBy,
  required String updatedBy,
  Value<int> rowid,
});
typedef $$RecurringPaymentsTableUpdateCompanionBuilder
    = RecurringPaymentsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> recurringExpenseId,
  Value<int> periodYear,
  Value<int> periodMonth,
  Value<RecurringPaymentStatus> status,
  Value<String?> transactionId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<int> rowid,
});

final class $$RecurringPaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $RecurringPaymentsTable, RecurringPayment> {
  $$RecurringPaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias($_aliasNameGenerator(
          db.recurringPayments.householdId, db.households.id));

  $$HouseholdsTableProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecurringExpensesTable _recurringExpenseIdTable(_$AppDatabase db) =>
      db.recurringExpenses.createAlias($_aliasNameGenerator(
          db.recurringPayments.recurringExpenseId, db.recurringExpenses.id));

  $$RecurringExpensesTableProcessedTableManager get recurringExpenseId {
    final $_column = $_itemColumn<String>('recurring_expense_id')!;

    final manager =
        $$RecurringExpensesTableTableManager($_db, $_db.recurringExpenses)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringExpenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.recurringPayments.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<String>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecurringPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecurringPaymentStatus, RecurringPaymentStatus,
          String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdId {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurringExpensesTableFilterComposer get recurringExpenseId {
    final $$RecurringExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recurringExpenseId,
        referencedTable: $db.recurringExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringExpensesTableFilterComposer(
              $db: $db,
              $table: $db.recurringExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurringPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdId {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurringExpensesTableOrderingComposer get recurringExpenseId {
    final $$RecurringExpensesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recurringExpenseId,
        referencedTable: $db.recurringExpenses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurringExpensesTableOrderingComposer(
              $db: $db,
              $table: $db.recurringExpenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurringPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringPaymentsTable> {
  $$RecurringPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => column);

  GeneratedColumn<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurringPaymentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdId {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdId,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecurringExpensesTableAnnotationComposer get recurringExpenseId {
    final $$RecurringExpensesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.recurringExpenseId,
            referencedTable: $db.recurringExpenses,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecurringExpensesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recurringExpenses,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurringPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPayment,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (RecurringPayment, $$RecurringPaymentsTableReferences),
    RecurringPayment,
    PrefetchHooks Function(
        {bool householdId, bool recurringExpenseId, bool transactionId})> {
  $$RecurringPaymentsTableTableManager(
      _$AppDatabase db, $RecurringPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> householdId = const Value.absent(),
            Value<String> recurringExpenseId = const Value.absent(),
            Value<int> periodYear = const Value.absent(),
            Value<int> periodMonth = const Value.absent(),
            Value<RecurringPaymentStatus> status = const Value.absent(),
            Value<String?> transactionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion(
            id: id,
            householdId: householdId,
            recurringExpenseId: recurringExpenseId,
            periodYear: periodYear,
            periodMonth: periodMonth,
            status: status,
            transactionId: transactionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String householdId,
            required String recurringExpenseId,
            required int periodYear,
            required int periodMonth,
            required RecurringPaymentStatus status,
            Value<String?> transactionId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            required String createdBy,
            required String updatedBy,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringPaymentsCompanion.insert(
            id: id,
            householdId: householdId,
            recurringExpenseId: recurringExpenseId,
            periodYear: periodYear,
            periodMonth: periodMonth,
            status: status,
            transactionId: transactionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            createdBy: createdBy,
            updatedBy: updatedBy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecurringPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdId = false,
              recurringExpenseId = false,
              transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (householdId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdId,
                    referencedTable: $$RecurringPaymentsTableReferences
                        ._householdIdTable(db),
                    referencedColumn: $$RecurringPaymentsTableReferences
                        ._householdIdTable(db)
                        .id,
                  ) as T;
                }
                if (recurringExpenseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recurringExpenseId,
                    referencedTable: $$RecurringPaymentsTableReferences
                        ._recurringExpenseIdTable(db),
                    referencedColumn: $$RecurringPaymentsTableReferences
                        ._recurringExpenseIdTable(db)
                        .id,
                  ) as T;
                }
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable: $$RecurringPaymentsTableReferences
                        ._transactionIdTable(db),
                    referencedColumn: $$RecurringPaymentsTableReferences
                        ._transactionIdTable(db)
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
        ));
}

typedef $$RecurringPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurringPaymentsTable,
    RecurringPayment,
    $$RecurringPaymentsTableFilterComposer,
    $$RecurringPaymentsTableOrderingComposer,
    $$RecurringPaymentsTableAnnotationComposer,
    $$RecurringPaymentsTableCreateCompanionBuilder,
    $$RecurringPaymentsTableUpdateCompanionBuilder,
    (RecurringPayment, $$RecurringPaymentsTableReferences),
    RecurringPayment,
    PrefetchHooks Function(
        {bool householdId, bool recurringExpenseId, bool transactionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$HouseholdMembersTableTableManager get householdMembers =>
      $$HouseholdMembersTableTableManager(_db, _db.householdMembers);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$RecurringExpensesTableTableManager get recurringExpenses =>
      $$RecurringExpensesTableTableManager(_db, _db.recurringExpenses);
  $$RecurringPaymentsTableTableManager get recurringPayments =>
      $$RecurringPaymentsTableTableManager(_db, _db.recurringPayments);
}
