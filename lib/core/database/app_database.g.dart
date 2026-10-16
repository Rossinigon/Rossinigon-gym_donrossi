// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutLogsTable extends WorkoutLogs
    with TableInfo<$WorkoutLogsTable, WorkoutLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Normal'),
  );
  static const VerificationMeta _recommendationMeta = const VerificationMeta(
    'recommendation',
  );
  @override
  late final GeneratedColumn<String> recommendation = GeneratedColumn<String>(
    'recommendation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseName,
    weight,
    reps,
    rpe,
    rir,
    setType,
    recommendation,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    } else if (isInserting) {
      context.missing(_rpeMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    }
    if (data.containsKey('recommendation')) {
      context.handle(
        _recommendationMeta,
        recommendation.isAcceptableOrUnknown(
          data['recommendation']!,
          _recommendationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recommendationMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      )!,
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir'],
      ),
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      recommendation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendation'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $WorkoutLogsTable createAlias(String alias) {
    return $WorkoutLogsTable(attachedDatabase, alias);
  }
}

class WorkoutLog extends DataClass implements Insertable<WorkoutLog> {
  final int id;
  final String exerciseName;
  final double weight;
  final int reps;
  final double rpe;
  final int? rir;
  final String setType;
  final String recommendation;
  final DateTime date;
  const WorkoutLog({
    required this.id,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.rpe,
    this.rir,
    required this.setType,
    required this.recommendation,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    map['rpe'] = Variable<double>(rpe);
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    map['set_type'] = Variable<String>(setType);
    map['recommendation'] = Variable<String>(recommendation);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  WorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutLogsCompanion(
      id: Value(id),
      exerciseName: Value(exerciseName),
      weight: Value(weight),
      reps: Value(reps),
      rpe: Value(rpe),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      setType: Value(setType),
      recommendation: Value(recommendation),
      date: Value(date),
    );
  }

  factory WorkoutLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutLog(
      id: serializer.fromJson<int>(json['id']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double>(json['rpe']),
      rir: serializer.fromJson<int?>(json['rir']),
      setType: serializer.fromJson<String>(json['setType']),
      recommendation: serializer.fromJson<String>(json['recommendation']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double>(rpe),
      'rir': serializer.toJson<int?>(rir),
      'setType': serializer.toJson<String>(setType),
      'recommendation': serializer.toJson<String>(recommendation),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  WorkoutLog copyWith({
    int? id,
    String? exerciseName,
    double? weight,
    int? reps,
    double? rpe,
    Value<int?> rir = const Value.absent(),
    String? setType,
    String? recommendation,
    DateTime? date,
  }) => WorkoutLog(
    id: id ?? this.id,
    exerciseName: exerciseName ?? this.exerciseName,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    rpe: rpe ?? this.rpe,
    rir: rir.present ? rir.value : this.rir,
    setType: setType ?? this.setType,
    recommendation: recommendation ?? this.recommendation,
    date: date ?? this.date,
  );
  WorkoutLog copyWithCompanion(WorkoutLogsCompanion data) {
    return WorkoutLog(
      id: data.id.present ? data.id.value : this.id,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      rir: data.rir.present ? data.rir.value : this.rir,
      setType: data.setType.present ? data.setType.value : this.setType,
      recommendation: data.recommendation.present
          ? data.recommendation.value
          : this.recommendation,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLog(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('setType: $setType, ')
          ..write('recommendation: $recommendation, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseName,
    weight,
    reps,
    rpe,
    rir,
    setType,
    recommendation,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutLog &&
          other.id == this.id &&
          other.exerciseName == this.exerciseName &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.rir == this.rir &&
          other.setType == this.setType &&
          other.recommendation == this.recommendation &&
          other.date == this.date);
}

class WorkoutLogsCompanion extends UpdateCompanion<WorkoutLog> {
  final Value<int> id;
  final Value<String> exerciseName;
  final Value<double> weight;
  final Value<int> reps;
  final Value<double> rpe;
  final Value<int?> rir;
  final Value<String> setType;
  final Value<String> recommendation;
  final Value<DateTime> date;
  const WorkoutLogsCompanion({
    this.id = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.rir = const Value.absent(),
    this.setType = const Value.absent(),
    this.recommendation = const Value.absent(),
    this.date = const Value.absent(),
  });
  WorkoutLogsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseName,
    required double weight,
    required int reps,
    required double rpe,
    this.rir = const Value.absent(),
    this.setType = const Value.absent(),
    required String recommendation,
    required DateTime date,
  }) : exerciseName = Value(exerciseName),
       weight = Value(weight),
       reps = Value(reps),
       rpe = Value(rpe),
       recommendation = Value(recommendation),
       date = Value(date);
  static Insertable<WorkoutLog> custom({
    Expression<int>? id,
    Expression<String>? exerciseName,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<int>? rir,
    Expression<String>? setType,
    Expression<String>? recommendation,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (rir != null) 'rir': rir,
      if (setType != null) 'set_type': setType,
      if (recommendation != null) 'recommendation': recommendation,
      if (date != null) 'date': date,
    });
  }

  WorkoutLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? exerciseName,
    Value<double>? weight,
    Value<int>? reps,
    Value<double>? rpe,
    Value<int?>? rir,
    Value<String>? setType,
    Value<String>? recommendation,
    Value<DateTime>? date,
  }) {
    return WorkoutLogsCompanion(
      id: id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      rir: rir ?? this.rir,
      setType: setType ?? this.setType,
      recommendation: recommendation ?? this.recommendation,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (recommendation.present) {
      map['recommendation'] = Variable<String>(recommendation.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutLogsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('setType: $setType, ')
          ..write('recommendation: $recommendation, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _biomechanicalNoteMeta = const VerificationMeta(
    'biomechanicalNote',
  );
  @override
  late final GeneratedColumn<String> biomechanicalNote =
      GeneratedColumn<String>(
        'biomechanical_note',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gifPathMeta = const VerificationMeta(
    'gifPath',
  );
  @override
  late final GeneratedColumn<String> gifPath = GeneratedColumn<String>(
    'gif_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    biomechanicalNote,
    imagePath,
    gifPath,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('biomechanical_note')) {
      context.handle(
        _biomechanicalNoteMeta,
        biomechanicalNote.isAcceptableOrUnknown(
          data['biomechanical_note']!,
          _biomechanicalNoteMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('gif_path')) {
      context.handle(
        _gifPathMeta,
        gifPath.isAcceptableOrUnknown(data['gif_path']!, _gifPathMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      biomechanicalNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}biomechanical_note'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      gifPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gif_path'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String category;
  final String? biomechanicalNote;
  final String? imagePath;
  final String? gifPath;
  final bool isDefault;
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    this.biomechanicalNote,
    this.imagePath,
    this.gifPath,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || biomechanicalNote != null) {
      map['biomechanical_note'] = Variable<String>(biomechanicalNote);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || gifPath != null) {
      map['gif_path'] = Variable<String>(gifPath);
    }
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      biomechanicalNote: biomechanicalNote == null && nullToAbsent
          ? const Value.absent()
          : Value(biomechanicalNote),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      gifPath: gifPath == null && nullToAbsent
          ? const Value.absent()
          : Value(gifPath),
      isDefault: Value(isDefault),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      biomechanicalNote: serializer.fromJson<String?>(
        json['biomechanicalNote'],
      ),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      gifPath: serializer.fromJson<String?>(json['gifPath']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'biomechanicalNote': serializer.toJson<String?>(biomechanicalNote),
      'imagePath': serializer.toJson<String?>(imagePath),
      'gifPath': serializer.toJson<String?>(gifPath),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    Value<String?> biomechanicalNote = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> gifPath = const Value.absent(),
    bool? isDefault,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    biomechanicalNote: biomechanicalNote.present
        ? biomechanicalNote.value
        : this.biomechanicalNote,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    gifPath: gifPath.present ? gifPath.value : this.gifPath,
    isDefault: isDefault ?? this.isDefault,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      biomechanicalNote: data.biomechanicalNote.present
          ? data.biomechanicalNote.value
          : this.biomechanicalNote,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      gifPath: data.gifPath.present ? data.gifPath.value : this.gifPath,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('biomechanicalNote: $biomechanicalNote, ')
          ..write('imagePath: $imagePath, ')
          ..write('gifPath: $gifPath, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    biomechanicalNote,
    imagePath,
    gifPath,
    isDefault,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.biomechanicalNote == this.biomechanicalNote &&
          other.imagePath == this.imagePath &&
          other.gifPath == this.gifPath &&
          other.isDefault == this.isDefault);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> biomechanicalNote;
  final Value<String?> imagePath;
  final Value<String?> gifPath;
  final Value<bool> isDefault;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.biomechanicalNote = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.gifPath = const Value.absent(),
    this.isDefault = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.biomechanicalNote = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.gifPath = const Value.absent(),
    this.isDefault = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? biomechanicalNote,
    Expression<String>? imagePath,
    Expression<String>? gifPath,
    Expression<bool>? isDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (biomechanicalNote != null) 'biomechanical_note': biomechanicalNote,
      if (imagePath != null) 'image_path': imagePath,
      if (gifPath != null) 'gif_path': gifPath,
      if (isDefault != null) 'is_default': isDefault,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? biomechanicalNote,
    Value<String?>? imagePath,
    Value<String?>? gifPath,
    Value<bool>? isDefault,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      biomechanicalNote: biomechanicalNote ?? this.biomechanicalNote,
      imagePath: imagePath ?? this.imagePath,
      gifPath: gifPath ?? this.gifPath,
      isDefault: isDefault ?? this.isDefault,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (biomechanicalNote.present) {
      map['biomechanical_note'] = Variable<String>(biomechanicalNote.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (gifPath.present) {
      map['gif_path'] = Variable<String>(gifPath.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('biomechanicalNote: $biomechanicalNote, ')
          ..write('imagePath: $imagePath, ')
          ..write('gifPath: $gifPath, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }
}

class $WeeklySchedulesTable extends WeeklySchedules
    with TableInfo<$WeeklySchedulesTable, WeeklySchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklySchedulesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _focusMuscleMeta = const VerificationMeta(
    'focusMuscle',
  );
  @override
  late final GeneratedColumn<String> focusMuscle = GeneratedColumn<String>(
    'focus_muscle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dayOfWeek, focusMuscle, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklySchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('focus_muscle')) {
      context.handle(
        _focusMuscleMeta,
        focusMuscle.isAcceptableOrUnknown(
          data['focus_muscle']!,
          _focusMuscleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusMuscleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklySchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklySchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_of_week'],
      )!,
      focusMuscle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_muscle'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WeeklySchedulesTable createAlias(String alias) {
    return $WeeklySchedulesTable(attachedDatabase, alias);
  }
}

class WeeklySchedule extends DataClass implements Insertable<WeeklySchedule> {
  final int id;
  final String dayOfWeek;
  final String focusMuscle;
  final String? notes;
  const WeeklySchedule({
    required this.id,
    required this.dayOfWeek,
    required this.focusMuscle,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['focus_muscle'] = Variable<String>(focusMuscle);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WeeklySchedulesCompanion toCompanion(bool nullToAbsent) {
    return WeeklySchedulesCompanion(
      id: Value(id),
      dayOfWeek: Value(dayOfWeek),
      focusMuscle: Value(focusMuscle),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WeeklySchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklySchedule(
      id: serializer.fromJson<int>(json['id']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      focusMuscle: serializer.fromJson<String>(json['focusMuscle']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'focusMuscle': serializer.toJson<String>(focusMuscle),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WeeklySchedule copyWith({
    int? id,
    String? dayOfWeek,
    String? focusMuscle,
    Value<String?> notes = const Value.absent(),
  }) => WeeklySchedule(
    id: id ?? this.id,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    focusMuscle: focusMuscle ?? this.focusMuscle,
    notes: notes.present ? notes.value : this.notes,
  );
  WeeklySchedule copyWithCompanion(WeeklySchedulesCompanion data) {
    return WeeklySchedule(
      id: data.id.present ? data.id.value : this.id,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      focusMuscle: data.focusMuscle.present
          ? data.focusMuscle.value
          : this.focusMuscle,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklySchedule(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('focusMuscle: $focusMuscle, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayOfWeek, focusMuscle, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklySchedule &&
          other.id == this.id &&
          other.dayOfWeek == this.dayOfWeek &&
          other.focusMuscle == this.focusMuscle &&
          other.notes == this.notes);
}

class WeeklySchedulesCompanion extends UpdateCompanion<WeeklySchedule> {
  final Value<int> id;
  final Value<String> dayOfWeek;
  final Value<String> focusMuscle;
  final Value<String?> notes;
  const WeeklySchedulesCompanion({
    this.id = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.focusMuscle = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WeeklySchedulesCompanion.insert({
    this.id = const Value.absent(),
    required String dayOfWeek,
    required String focusMuscle,
    this.notes = const Value.absent(),
  }) : dayOfWeek = Value(dayOfWeek),
       focusMuscle = Value(focusMuscle);
  static Insertable<WeeklySchedule> custom({
    Expression<int>? id,
    Expression<String>? dayOfWeek,
    Expression<String>? focusMuscle,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (focusMuscle != null) 'focus_muscle': focusMuscle,
      if (notes != null) 'notes': notes,
    });
  }

  WeeklySchedulesCompanion copyWith({
    Value<int>? id,
    Value<String>? dayOfWeek,
    Value<String>? focusMuscle,
    Value<String?>? notes,
  }) {
    return WeeklySchedulesCompanion(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      focusMuscle: focusMuscle ?? this.focusMuscle,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (focusMuscle.present) {
      map['focus_muscle'] = Variable<String>(focusMuscle.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklySchedulesCompanion(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('focusMuscle: $focusMuscle, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String name;
  const UserProfile({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(id: Value(id), name: Value(name));
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  UserProfile copyWith({int? id, String? name}) =>
      UserProfile(id: id ?? this.id, name: name ?? this.name);
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile && other.id == this.id && other.name == this.name);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> name;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  UserProfilesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return UserProfilesCompanion(id: id ?? this.id, name: name ?? this.name);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  const Category({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({int? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CategoriesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return CategoriesCompanion(id: id ?? this.id, name: name ?? this.name);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ScheduledExercisesTable extends ScheduledExercises
    with TableInfo<$ScheduledExercisesTable, ScheduledExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayOfWeek,
    exerciseName,
    targetSets,
    targetReps,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_of_week'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      )!,
    );
  }

  @override
  $ScheduledExercisesTable createAlias(String alias) {
    return $ScheduledExercisesTable(attachedDatabase, alias);
  }
}

class ScheduledExercise extends DataClass
    implements Insertable<ScheduledExercise> {
  final int id;
  final String dayOfWeek;
  final String exerciseName;
  final int targetSets;
  final int targetReps;
  const ScheduledExercise({
    required this.id,
    required this.dayOfWeek,
    required this.exerciseName,
    required this.targetSets,
    required this.targetReps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['target_sets'] = Variable<int>(targetSets);
    map['target_reps'] = Variable<int>(targetReps);
    return map;
  }

  ScheduledExercisesCompanion toCompanion(bool nullToAbsent) {
    return ScheduledExercisesCompanion(
      id: Value(id),
      dayOfWeek: Value(dayOfWeek),
      exerciseName: Value(exerciseName),
      targetSets: Value(targetSets),
      targetReps: Value(targetReps),
    );
  }

  factory ScheduledExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledExercise(
      id: serializer.fromJson<int>(json['id']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetReps: serializer.fromJson<int>(json['targetReps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetReps': serializer.toJson<int>(targetReps),
    };
  }

  ScheduledExercise copyWith({
    int? id,
    String? dayOfWeek,
    String? exerciseName,
    int? targetSets,
    int? targetReps,
  }) => ScheduledExercise(
    id: id ?? this.id,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    exerciseName: exerciseName ?? this.exerciseName,
    targetSets: targetSets ?? this.targetSets,
    targetReps: targetReps ?? this.targetReps,
  );
  ScheduledExercise copyWithCompanion(ScheduledExercisesCompanion data) {
    return ScheduledExercise(
      id: data.id.present ? data.id.value : this.id,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExercise(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayOfWeek, exerciseName, targetSets, targetReps);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledExercise &&
          other.id == this.id &&
          other.dayOfWeek == this.dayOfWeek &&
          other.exerciseName == this.exerciseName &&
          other.targetSets == this.targetSets &&
          other.targetReps == this.targetReps);
}

class ScheduledExercisesCompanion extends UpdateCompanion<ScheduledExercise> {
  final Value<int> id;
  final Value<String> dayOfWeek;
  final Value<String> exerciseName;
  final Value<int> targetSets;
  final Value<int> targetReps;
  const ScheduledExercisesCompanion({
    this.id = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
  });
  ScheduledExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String dayOfWeek,
    required String exerciseName,
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
  }) : dayOfWeek = Value(dayOfWeek),
       exerciseName = Value(exerciseName);
  static Insertable<ScheduledExercise> custom({
    Expression<int>? id,
    Expression<String>? dayOfWeek,
    Expression<String>? exerciseName,
    Expression<int>? targetSets,
    Expression<int>? targetReps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetReps != null) 'target_reps': targetReps,
    });
  }

  ScheduledExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? dayOfWeek,
    Value<String>? exerciseName,
    Value<int>? targetSets,
    Value<int>? targetReps,
  }) {
    return ScheduledExercisesCompanion(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      exerciseName: exerciseName ?? this.exerciseName,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledExercisesCompanion(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps')
          ..write(')'))
        .toString();
  }
}

class $SupplementsTable extends Supplements
    with TableInfo<$SupplementsTable, Supplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<String> timing = GeneratedColumn<String>(
    'timing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectiveMeta = const VerificationMeta(
    'objective',
  );
  @override
  late final GeneratedColumn<String> objective = GeneratedColumn<String>(
    'objective',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dosage,
    timing,
    category,
    objective,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplement> instance, {
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
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    } else if (isInserting) {
      context.missing(_timingMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('objective')) {
      context.handle(
        _objectiveMeta,
        objective.isAcceptableOrUnknown(data['objective']!, _objectiveMeta),
      );
    } else if (isInserting) {
      context.missing(_objectiveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      )!,
      timing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timing'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      objective: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}objective'],
      )!,
    );
  }

  @override
  $SupplementsTable createAlias(String alias) {
    return $SupplementsTable(attachedDatabase, alias);
  }
}

class Supplement extends DataClass implements Insertable<Supplement> {
  final int id;
  final String name;
  final String dosage;
  final String timing;
  final String category;
  final String objective;
  const Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timing,
    required this.category,
    required this.objective,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['dosage'] = Variable<String>(dosage);
    map['timing'] = Variable<String>(timing);
    map['category'] = Variable<String>(category);
    map['objective'] = Variable<String>(objective);
    return map;
  }

  SupplementsCompanion toCompanion(bool nullToAbsent) {
    return SupplementsCompanion(
      id: Value(id),
      name: Value(name),
      dosage: Value(dosage),
      timing: Value(timing),
      category: Value(category),
      objective: Value(objective),
    );
  }

  factory Supplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplement(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String>(json['dosage']),
      timing: serializer.fromJson<String>(json['timing']),
      category: serializer.fromJson<String>(json['category']),
      objective: serializer.fromJson<String>(json['objective']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String>(dosage),
      'timing': serializer.toJson<String>(timing),
      'category': serializer.toJson<String>(category),
      'objective': serializer.toJson<String>(objective),
    };
  }

  Supplement copyWith({
    int? id,
    String? name,
    String? dosage,
    String? timing,
    String? category,
    String? objective,
  }) => Supplement(
    id: id ?? this.id,
    name: name ?? this.name,
    dosage: dosage ?? this.dosage,
    timing: timing ?? this.timing,
    category: category ?? this.category,
    objective: objective ?? this.objective,
  );
  Supplement copyWithCompanion(SupplementsCompanion data) {
    return Supplement(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      timing: data.timing.present ? data.timing.value : this.timing,
      category: data.category.present ? data.category.value : this.category,
      objective: data.objective.present ? data.objective.value : this.objective,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('timing: $timing, ')
          ..write('category: $category, ')
          ..write('objective: $objective')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, dosage, timing, category, objective);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplement &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.timing == this.timing &&
          other.category == this.category &&
          other.objective == this.objective);
}

class SupplementsCompanion extends UpdateCompanion<Supplement> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> dosage;
  final Value<String> timing;
  final Value<String> category;
  final Value<String> objective;
  const SupplementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.timing = const Value.absent(),
    this.category = const Value.absent(),
    this.objective = const Value.absent(),
  });
  SupplementsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String dosage,
    required String timing,
    required String category,
    required String objective,
  }) : name = Value(name),
       dosage = Value(dosage),
       timing = Value(timing),
       category = Value(category),
       objective = Value(objective);
  static Insertable<Supplement> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? timing,
    Expression<String>? category,
    Expression<String>? objective,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (timing != null) 'timing': timing,
      if (category != null) 'category': category,
      if (objective != null) 'objective': objective,
    });
  }

  SupplementsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? dosage,
    Value<String>? timing,
    Value<String>? category,
    Value<String>? objective,
  }) {
    return SupplementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      timing: timing ?? this.timing,
      category: category ?? this.category,
      objective: objective ?? this.objective,
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
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(timing.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (objective.present) {
      map['objective'] = Variable<String>(objective.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('timing: $timing, ')
          ..write('category: $category, ')
          ..write('objective: $objective')
          ..write(')'))
        .toString();
  }
}

class $ScheduledSupplementsTable extends ScheduledSupplements
    with TableInfo<$ScheduledSupplementsTable, ScheduledSupplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledSupplementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplementNameMeta = const VerificationMeta(
    'supplementName',
  );
  @override
  late final GeneratedColumn<String> supplementName = GeneratedColumn<String>(
    'supplement_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<String> timing = GeneratedColumn<String>(
    'timing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayOfWeek,
    supplementName,
    dosage,
    timing,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledSupplement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('supplement_name')) {
      context.handle(
        _supplementNameMeta,
        supplementName.isAcceptableOrUnknown(
          data['supplement_name']!,
          _supplementNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementNameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    } else if (isInserting) {
      context.missing(_timingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledSupplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledSupplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_of_week'],
      )!,
      supplementName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplement_name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      )!,
      timing: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timing'],
      )!,
    );
  }

  @override
  $ScheduledSupplementsTable createAlias(String alias) {
    return $ScheduledSupplementsTable(attachedDatabase, alias);
  }
}

class ScheduledSupplement extends DataClass
    implements Insertable<ScheduledSupplement> {
  final int id;
  final String dayOfWeek;
  final String supplementName;
  final String dosage;
  final String timing;
  const ScheduledSupplement({
    required this.id,
    required this.dayOfWeek,
    required this.supplementName,
    required this.dosage,
    required this.timing,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['supplement_name'] = Variable<String>(supplementName);
    map['dosage'] = Variable<String>(dosage);
    map['timing'] = Variable<String>(timing);
    return map;
  }

  ScheduledSupplementsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledSupplementsCompanion(
      id: Value(id),
      dayOfWeek: Value(dayOfWeek),
      supplementName: Value(supplementName),
      dosage: Value(dosage),
      timing: Value(timing),
    );
  }

  factory ScheduledSupplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledSupplement(
      id: serializer.fromJson<int>(json['id']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      supplementName: serializer.fromJson<String>(json['supplementName']),
      dosage: serializer.fromJson<String>(json['dosage']),
      timing: serializer.fromJson<String>(json['timing']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'supplementName': serializer.toJson<String>(supplementName),
      'dosage': serializer.toJson<String>(dosage),
      'timing': serializer.toJson<String>(timing),
    };
  }

  ScheduledSupplement copyWith({
    int? id,
    String? dayOfWeek,
    String? supplementName,
    String? dosage,
    String? timing,
  }) => ScheduledSupplement(
    id: id ?? this.id,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    supplementName: supplementName ?? this.supplementName,
    dosage: dosage ?? this.dosage,
    timing: timing ?? this.timing,
  );
  ScheduledSupplement copyWithCompanion(ScheduledSupplementsCompanion data) {
    return ScheduledSupplement(
      id: data.id.present ? data.id.value : this.id,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      supplementName: data.supplementName.present
          ? data.supplementName.value
          : this.supplementName,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      timing: data.timing.present ? data.timing.value : this.timing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledSupplement(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('supplementName: $supplementName, ')
          ..write('dosage: $dosage, ')
          ..write('timing: $timing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayOfWeek, supplementName, dosage, timing);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledSupplement &&
          other.id == this.id &&
          other.dayOfWeek == this.dayOfWeek &&
          other.supplementName == this.supplementName &&
          other.dosage == this.dosage &&
          other.timing == this.timing);
}

class ScheduledSupplementsCompanion
    extends UpdateCompanion<ScheduledSupplement> {
  final Value<int> id;
  final Value<String> dayOfWeek;
  final Value<String> supplementName;
  final Value<String> dosage;
  final Value<String> timing;
  const ScheduledSupplementsCompanion({
    this.id = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.supplementName = const Value.absent(),
    this.dosage = const Value.absent(),
    this.timing = const Value.absent(),
  });
  ScheduledSupplementsCompanion.insert({
    this.id = const Value.absent(),
    required String dayOfWeek,
    required String supplementName,
    required String dosage,
    required String timing,
  }) : dayOfWeek = Value(dayOfWeek),
       supplementName = Value(supplementName),
       dosage = Value(dosage),
       timing = Value(timing);
  static Insertable<ScheduledSupplement> custom({
    Expression<int>? id,
    Expression<String>? dayOfWeek,
    Expression<String>? supplementName,
    Expression<String>? dosage,
    Expression<String>? timing,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (supplementName != null) 'supplement_name': supplementName,
      if (dosage != null) 'dosage': dosage,
      if (timing != null) 'timing': timing,
    });
  }

  ScheduledSupplementsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayOfWeek,
    Value<String>? supplementName,
    Value<String>? dosage,
    Value<String>? timing,
  }) {
    return ScheduledSupplementsCompanion(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      supplementName: supplementName ?? this.supplementName,
      dosage: dosage ?? this.dosage,
      timing: timing ?? this.timing,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (supplementName.present) {
      map['supplement_name'] = Variable<String>(supplementName.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(timing.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledSupplementsCompanion(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('supplementName: $supplementName, ')
          ..write('dosage: $dosage, ')
          ..write('timing: $timing')
          ..write(')'))
        .toString();
  }
}

class $BodyMeasurementsTable extends BodyMeasurements
    with TableInfo<$BodyMeasurementsTable, BodyMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMeasurementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waistMeta = const VerificationMeta('waist');
  @override
  late final GeneratedColumn<double> waist = GeneratedColumn<double>(
    'waist',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chestMeta = const VerificationMeta('chest');
  @override
  late final GeneratedColumn<double> chest = GeneratedColumn<double>(
    'chest',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armRelaxedMeta = const VerificationMeta(
    'armRelaxed',
  );
  @override
  late final GeneratedColumn<double> armRelaxed = GeneratedColumn<double>(
    'arm_relaxed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armFlexedMeta = const VerificationMeta(
    'armFlexed',
  );
  @override
  late final GeneratedColumn<double> armFlexed = GeneratedColumn<double>(
    'arm_flexed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thighProximalMeta = const VerificationMeta(
    'thighProximal',
  );
  @override
  late final GeneratedColumn<double> thighProximal = GeneratedColumn<double>(
    'thigh_proximal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thighMidMeta = const VerificationMeta(
    'thighMid',
  );
  @override
  late final GeneratedColumn<double> thighMid = GeneratedColumn<double>(
    'thigh_mid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hipMeta = const VerificationMeta('hip');
  @override
  late final GeneratedColumn<double> hip = GeneratedColumn<double>(
    'hip',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restingHeartRateMeta = const VerificationMeta(
    'restingHeartRate',
  );
  @override
  late final GeneratedColumn<int> restingHeartRate = GeneratedColumn<int>(
    'resting_heart_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    weight,
    waist,
    chest,
    armRelaxed,
    armFlexed,
    thighProximal,
    thighMid,
    hip,
    restingHeartRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('waist')) {
      context.handle(
        _waistMeta,
        waist.isAcceptableOrUnknown(data['waist']!, _waistMeta),
      );
    } else if (isInserting) {
      context.missing(_waistMeta);
    }
    if (data.containsKey('chest')) {
      context.handle(
        _chestMeta,
        chest.isAcceptableOrUnknown(data['chest']!, _chestMeta),
      );
    } else if (isInserting) {
      context.missing(_chestMeta);
    }
    if (data.containsKey('arm_relaxed')) {
      context.handle(
        _armRelaxedMeta,
        armRelaxed.isAcceptableOrUnknown(data['arm_relaxed']!, _armRelaxedMeta),
      );
    } else if (isInserting) {
      context.missing(_armRelaxedMeta);
    }
    if (data.containsKey('arm_flexed')) {
      context.handle(
        _armFlexedMeta,
        armFlexed.isAcceptableOrUnknown(data['arm_flexed']!, _armFlexedMeta),
      );
    } else if (isInserting) {
      context.missing(_armFlexedMeta);
    }
    if (data.containsKey('thigh_proximal')) {
      context.handle(
        _thighProximalMeta,
        thighProximal.isAcceptableOrUnknown(
          data['thigh_proximal']!,
          _thighProximalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thighProximalMeta);
    }
    if (data.containsKey('thigh_mid')) {
      context.handle(
        _thighMidMeta,
        thighMid.isAcceptableOrUnknown(data['thigh_mid']!, _thighMidMeta),
      );
    } else if (isInserting) {
      context.missing(_thighMidMeta);
    }
    if (data.containsKey('hip')) {
      context.handle(
        _hipMeta,
        hip.isAcceptableOrUnknown(data['hip']!, _hipMeta),
      );
    } else if (isInserting) {
      context.missing(_hipMeta);
    }
    if (data.containsKey('resting_heart_rate')) {
      context.handle(
        _restingHeartRateMeta,
        restingHeartRate.isAcceptableOrUnknown(
          data['resting_heart_rate']!,
          _restingHeartRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restingHeartRateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      waist: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist'],
      )!,
      chest: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chest'],
      )!,
      armRelaxed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arm_relaxed'],
      )!,
      armFlexed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arm_flexed'],
      )!,
      thighProximal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}thigh_proximal'],
      )!,
      thighMid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}thigh_mid'],
      )!,
      hip: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hip'],
      )!,
      restingHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_heart_rate'],
      )!,
    );
  }

  @override
  $BodyMeasurementsTable createAlias(String alias) {
    return $BodyMeasurementsTable(attachedDatabase, alias);
  }
}

class BodyMeasurement extends DataClass implements Insertable<BodyMeasurement> {
  final int id;
  final DateTime date;
  final double weight;
  final double waist;
  final double chest;
  final double armRelaxed;
  final double armFlexed;
  final double thighProximal;
  final double thighMid;
  final double hip;
  final int restingHeartRate;
  const BodyMeasurement({
    required this.id,
    required this.date,
    required this.weight,
    required this.waist,
    required this.chest,
    required this.armRelaxed,
    required this.armFlexed,
    required this.thighProximal,
    required this.thighMid,
    required this.hip,
    required this.restingHeartRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['weight'] = Variable<double>(weight);
    map['waist'] = Variable<double>(waist);
    map['chest'] = Variable<double>(chest);
    map['arm_relaxed'] = Variable<double>(armRelaxed);
    map['arm_flexed'] = Variable<double>(armFlexed);
    map['thigh_proximal'] = Variable<double>(thighProximal);
    map['thigh_mid'] = Variable<double>(thighMid);
    map['hip'] = Variable<double>(hip);
    map['resting_heart_rate'] = Variable<int>(restingHeartRate);
    return map;
  }

  BodyMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return BodyMeasurementsCompanion(
      id: Value(id),
      date: Value(date),
      weight: Value(weight),
      waist: Value(waist),
      chest: Value(chest),
      armRelaxed: Value(armRelaxed),
      armFlexed: Value(armFlexed),
      thighProximal: Value(thighProximal),
      thighMid: Value(thighMid),
      hip: Value(hip),
      restingHeartRate: Value(restingHeartRate),
    );
  }

  factory BodyMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMeasurement(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weight: serializer.fromJson<double>(json['weight']),
      waist: serializer.fromJson<double>(json['waist']),
      chest: serializer.fromJson<double>(json['chest']),
      armRelaxed: serializer.fromJson<double>(json['armRelaxed']),
      armFlexed: serializer.fromJson<double>(json['armFlexed']),
      thighProximal: serializer.fromJson<double>(json['thighProximal']),
      thighMid: serializer.fromJson<double>(json['thighMid']),
      hip: serializer.fromJson<double>(json['hip']),
      restingHeartRate: serializer.fromJson<int>(json['restingHeartRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weight': serializer.toJson<double>(weight),
      'waist': serializer.toJson<double>(waist),
      'chest': serializer.toJson<double>(chest),
      'armRelaxed': serializer.toJson<double>(armRelaxed),
      'armFlexed': serializer.toJson<double>(armFlexed),
      'thighProximal': serializer.toJson<double>(thighProximal),
      'thighMid': serializer.toJson<double>(thighMid),
      'hip': serializer.toJson<double>(hip),
      'restingHeartRate': serializer.toJson<int>(restingHeartRate),
    };
  }

  BodyMeasurement copyWith({
    int? id,
    DateTime? date,
    double? weight,
    double? waist,
    double? chest,
    double? armRelaxed,
    double? armFlexed,
    double? thighProximal,
    double? thighMid,
    double? hip,
    int? restingHeartRate,
  }) => BodyMeasurement(
    id: id ?? this.id,
    date: date ?? this.date,
    weight: weight ?? this.weight,
    waist: waist ?? this.waist,
    chest: chest ?? this.chest,
    armRelaxed: armRelaxed ?? this.armRelaxed,
    armFlexed: armFlexed ?? this.armFlexed,
    thighProximal: thighProximal ?? this.thighProximal,
    thighMid: thighMid ?? this.thighMid,
    hip: hip ?? this.hip,
    restingHeartRate: restingHeartRate ?? this.restingHeartRate,
  );
  BodyMeasurement copyWithCompanion(BodyMeasurementsCompanion data) {
    return BodyMeasurement(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weight: data.weight.present ? data.weight.value : this.weight,
      waist: data.waist.present ? data.waist.value : this.waist,
      chest: data.chest.present ? data.chest.value : this.chest,
      armRelaxed: data.armRelaxed.present
          ? data.armRelaxed.value
          : this.armRelaxed,
      armFlexed: data.armFlexed.present ? data.armFlexed.value : this.armFlexed,
      thighProximal: data.thighProximal.present
          ? data.thighProximal.value
          : this.thighProximal,
      thighMid: data.thighMid.present ? data.thighMid.value : this.thighMid,
      hip: data.hip.present ? data.hip.value : this.hip,
      restingHeartRate: data.restingHeartRate.present
          ? data.restingHeartRate.value
          : this.restingHeartRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurement(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('waist: $waist, ')
          ..write('chest: $chest, ')
          ..write('armRelaxed: $armRelaxed, ')
          ..write('armFlexed: $armFlexed, ')
          ..write('thighProximal: $thighProximal, ')
          ..write('thighMid: $thighMid, ')
          ..write('hip: $hip, ')
          ..write('restingHeartRate: $restingHeartRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    weight,
    waist,
    chest,
    armRelaxed,
    armFlexed,
    thighProximal,
    thighMid,
    hip,
    restingHeartRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMeasurement &&
          other.id == this.id &&
          other.date == this.date &&
          other.weight == this.weight &&
          other.waist == this.waist &&
          other.chest == this.chest &&
          other.armRelaxed == this.armRelaxed &&
          other.armFlexed == this.armFlexed &&
          other.thighProximal == this.thighProximal &&
          other.thighMid == this.thighMid &&
          other.hip == this.hip &&
          other.restingHeartRate == this.restingHeartRate);
}

class BodyMeasurementsCompanion extends UpdateCompanion<BodyMeasurement> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> weight;
  final Value<double> waist;
  final Value<double> chest;
  final Value<double> armRelaxed;
  final Value<double> armFlexed;
  final Value<double> thighProximal;
  final Value<double> thighMid;
  final Value<double> hip;
  final Value<int> restingHeartRate;
  const BodyMeasurementsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weight = const Value.absent(),
    this.waist = const Value.absent(),
    this.chest = const Value.absent(),
    this.armRelaxed = const Value.absent(),
    this.armFlexed = const Value.absent(),
    this.thighProximal = const Value.absent(),
    this.thighMid = const Value.absent(),
    this.hip = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
  });
  BodyMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double weight,
    required double waist,
    required double chest,
    required double armRelaxed,
    required double armFlexed,
    required double thighProximal,
    required double thighMid,
    required double hip,
    required int restingHeartRate,
  }) : date = Value(date),
       weight = Value(weight),
       waist = Value(waist),
       chest = Value(chest),
       armRelaxed = Value(armRelaxed),
       armFlexed = Value(armFlexed),
       thighProximal = Value(thighProximal),
       thighMid = Value(thighMid),
       hip = Value(hip),
       restingHeartRate = Value(restingHeartRate);
  static Insertable<BodyMeasurement> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weight,
    Expression<double>? waist,
    Expression<double>? chest,
    Expression<double>? armRelaxed,
    Expression<double>? armFlexed,
    Expression<double>? thighProximal,
    Expression<double>? thighMid,
    Expression<double>? hip,
    Expression<int>? restingHeartRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weight != null) 'weight': weight,
      if (waist != null) 'waist': waist,
      if (chest != null) 'chest': chest,
      if (armRelaxed != null) 'arm_relaxed': armRelaxed,
      if (armFlexed != null) 'arm_flexed': armFlexed,
      if (thighProximal != null) 'thigh_proximal': thighProximal,
      if (thighMid != null) 'thigh_mid': thighMid,
      if (hip != null) 'hip': hip,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
    });
  }

  BodyMeasurementsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? weight,
    Value<double>? waist,
    Value<double>? chest,
    Value<double>? armRelaxed,
    Value<double>? armFlexed,
    Value<double>? thighProximal,
    Value<double>? thighMid,
    Value<double>? hip,
    Value<int>? restingHeartRate,
  }) {
    return BodyMeasurementsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      waist: waist ?? this.waist,
      chest: chest ?? this.chest,
      armRelaxed: armRelaxed ?? this.armRelaxed,
      armFlexed: armFlexed ?? this.armFlexed,
      thighProximal: thighProximal ?? this.thighProximal,
      thighMid: thighMid ?? this.thighMid,
      hip: hip ?? this.hip,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (waist.present) {
      map['waist'] = Variable<double>(waist.value);
    }
    if (chest.present) {
      map['chest'] = Variable<double>(chest.value);
    }
    if (armRelaxed.present) {
      map['arm_relaxed'] = Variable<double>(armRelaxed.value);
    }
    if (armFlexed.present) {
      map['arm_flexed'] = Variable<double>(armFlexed.value);
    }
    if (thighProximal.present) {
      map['thigh_proximal'] = Variable<double>(thighProximal.value);
    }
    if (thighMid.present) {
      map['thigh_mid'] = Variable<double>(thighMid.value);
    }
    if (hip.present) {
      map['hip'] = Variable<double>(hip.value);
    }
    if (restingHeartRate.present) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('waist: $waist, ')
          ..write('chest: $chest, ')
          ..write('armRelaxed: $armRelaxed, ')
          ..write('armFlexed: $armFlexed, ')
          ..write('thighProximal: $thighProximal, ')
          ..write('thighMid: $thighMid, ')
          ..write('hip: $hip, ')
          ..write('restingHeartRate: $restingHeartRate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutLogsTable workoutLogs = $WorkoutLogsTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WeeklySchedulesTable weeklySchedules = $WeeklySchedulesTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ScheduledExercisesTable scheduledExercises =
      $ScheduledExercisesTable(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $ScheduledSupplementsTable scheduledSupplements =
      $ScheduledSupplementsTable(this);
  late final $BodyMeasurementsTable bodyMeasurements = $BodyMeasurementsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutLogs,
    exercises,
    weeklySchedules,
    userProfiles,
    categories,
    scheduledExercises,
    supplements,
    scheduledSupplements,
    bodyMeasurements,
  ];
}

typedef $$WorkoutLogsTableCreateCompanionBuilder =
    WorkoutLogsCompanion Function({
      Value<int> id,
      required String exerciseName,
      required double weight,
      required int reps,
      required double rpe,
      Value<int?> rir,
      Value<String> setType,
      required String recommendation,
      required DateTime date,
    });
typedef $$WorkoutLogsTableUpdateCompanionBuilder =
    WorkoutLogsCompanion Function({
      Value<int> id,
      Value<String> exerciseName,
      Value<double> weight,
      Value<int> reps,
      Value<double> rpe,
      Value<int?> rir,
      Value<String> setType,
      Value<String> recommendation,
      Value<DateTime> date,
    });

class $$WorkoutLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableFilterComposer({
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

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendation => $composableBuilder(
    column: $table.recommendation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableOrderingComposer({
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

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendation => $composableBuilder(
    column: $table.recommendation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutLogsTable> {
  $$WorkoutLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<String> get recommendation => $composableBuilder(
    column: $table.recommendation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$WorkoutLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutLogsTable,
          WorkoutLog,
          $$WorkoutLogsTableFilterComposer,
          $$WorkoutLogsTableOrderingComposer,
          $$WorkoutLogsTableAnnotationComposer,
          $$WorkoutLogsTableCreateCompanionBuilder,
          $$WorkoutLogsTableUpdateCompanionBuilder,
          (
            WorkoutLog,
            BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLog>,
          ),
          WorkoutLog,
          PrefetchHooks Function()
        > {
  $$WorkoutLogsTableTableManager(_$AppDatabase db, $WorkoutLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double> rpe = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<String> recommendation = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => WorkoutLogsCompanion(
                id: id,
                exerciseName: exerciseName,
                weight: weight,
                reps: reps,
                rpe: rpe,
                rir: rir,
                setType: setType,
                recommendation: recommendation,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String exerciseName,
                required double weight,
                required int reps,
                required double rpe,
                Value<int?> rir = const Value.absent(),
                Value<String> setType = const Value.absent(),
                required String recommendation,
                required DateTime date,
              }) => WorkoutLogsCompanion.insert(
                id: id,
                exerciseName: exerciseName,
                weight: weight,
                reps: reps,
                rpe: rpe,
                rir: rir,
                setType: setType,
                recommendation: recommendation,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutLogsTable, WorkoutLog>(table),
                  BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutLogsTable,
      WorkoutLog,
      $$WorkoutLogsTableFilterComposer,
      $$WorkoutLogsTableOrderingComposer,
      $$WorkoutLogsTableAnnotationComposer,
      $$WorkoutLogsTableCreateCompanionBuilder,
      $$WorkoutLogsTableUpdateCompanionBuilder,
      (
        WorkoutLog,
        BaseReferences<_$AppDatabase, $WorkoutLogsTable, WorkoutLog>,
      ),
      WorkoutLog,
      PrefetchHooks Function()
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required String category,
  Value<String?> biomechanicalNote,
  Value<String?> imagePath,
  Value<String?> gifPath,
  Value<bool> isDefault,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<String?> biomechanicalNote,
  Value<String?> imagePath,
  Value<String?> gifPath,
  Value<bool> isDefault,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biomechanicalNote => $composableBuilder(
    column: $table.biomechanicalNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gifPath => $composableBuilder(
    column: $table.gifPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biomechanicalNote => $composableBuilder(
    column: $table.biomechanicalNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gifPath => $composableBuilder(
    column: $table.gifPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get biomechanicalNote => $composableBuilder(
    column: $table.biomechanicalNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get gifPath =>
      $composableBuilder(column: $table.gifPath, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
          Exercise,
          PrefetchHooks Function()
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> biomechanicalNote = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> gifPath = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                category: category,
                biomechanicalNote: biomechanicalNote,
                imagePath: imagePath,
                gifPath: gifPath,
                isDefault: isDefault,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                Value<String?> biomechanicalNote = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> gifPath = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                category: category,
                biomechanicalNote: biomechanicalNote,
                imagePath: imagePath,
                gifPath: gifPath,
                isDefault: isDefault,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
      Exercise,
      PrefetchHooks Function()
    >;
typedef $$WeeklySchedulesTableCreateCompanionBuilder =
    WeeklySchedulesCompanion Function({
      Value<int> id,
      required String dayOfWeek,
      required String focusMuscle,
      Value<String?> notes,
    });
typedef $$WeeklySchedulesTableUpdateCompanionBuilder =
    WeeklySchedulesCompanion Function({
      Value<int> id,
      Value<String> dayOfWeek,
      Value<String> focusMuscle,
      Value<String?> notes,
    });

class $$WeeklySchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklySchedulesTable> {
  $$WeeklySchedulesTableFilterComposer({
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

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusMuscle => $composableBuilder(
    column: $table.focusMuscle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklySchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklySchedulesTable> {
  $$WeeklySchedulesTableOrderingComposer({
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

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusMuscle => $composableBuilder(
    column: $table.focusMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklySchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklySchedulesTable> {
  $$WeeklySchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get focusMuscle => $composableBuilder(
    column: $table.focusMuscle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WeeklySchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklySchedulesTable,
          WeeklySchedule,
          $$WeeklySchedulesTableFilterComposer,
          $$WeeklySchedulesTableOrderingComposer,
          $$WeeklySchedulesTableAnnotationComposer,
          $$WeeklySchedulesTableCreateCompanionBuilder,
          $$WeeklySchedulesTableUpdateCompanionBuilder,
          (
            WeeklySchedule,
            BaseReferences<
              _$AppDatabase,
              $WeeklySchedulesTable,
              WeeklySchedule
            >,
          ),
          WeeklySchedule,
          PrefetchHooks Function()
        > {
  $$WeeklySchedulesTableTableManager(
    _$AppDatabase db,
    $WeeklySchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklySchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklySchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklySchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayOfWeek = const Value.absent(),
                Value<String> focusMuscle = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WeeklySchedulesCompanion(
                id: id,
                dayOfWeek: dayOfWeek,
                focusMuscle: focusMuscle,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayOfWeek,
                required String focusMuscle,
                Value<String?> notes = const Value.absent(),
              }) => WeeklySchedulesCompanion.insert(
                id: id,
                dayOfWeek: dayOfWeek,
                focusMuscle: focusMuscle,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklySchedulesTable, WeeklySchedule>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeeklySchedulesTable,
                    WeeklySchedule
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklySchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklySchedulesTable,
      WeeklySchedule,
      $$WeeklySchedulesTableFilterComposer,
      $$WeeklySchedulesTableOrderingComposer,
      $$WeeklySchedulesTableAnnotationComposer,
      $$WeeklySchedulesTableCreateCompanionBuilder,
      $$WeeklySchedulesTableUpdateCompanionBuilder,
      (
        WeeklySchedule,
        BaseReferences<_$AppDatabase, $WeeklySchedulesTable, WeeklySchedule>,
      ),
      WeeklySchedule,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({Value<int> id, required String name});
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({Value<int> id, Value<String> name});

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
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
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => UserProfilesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => UserProfilesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfilesTable, UserProfile>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfilesTable,
                    UserProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => CategoriesCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => CategoriesCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$ScheduledExercisesTableCreateCompanionBuilder =
    ScheduledExercisesCompanion Function({
      Value<int> id,
      required String dayOfWeek,
      required String exerciseName,
      Value<int> targetSets,
      Value<int> targetReps,
    });
typedef $$ScheduledExercisesTableUpdateCompanionBuilder =
    ScheduledExercisesCompanion Function({
      Value<int> id,
      Value<String> dayOfWeek,
      Value<String> exerciseName,
      Value<int> targetSets,
      Value<int> targetReps,
    });

class $$ScheduledExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledExercisesTable> {
  $$ScheduledExercisesTableFilterComposer({
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

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduledExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledExercisesTable> {
  $$ScheduledExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduledExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledExercisesTable> {
  $$ScheduledExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );
}

class $$ScheduledExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledExercisesTable,
          ScheduledExercise,
          $$ScheduledExercisesTableFilterComposer,
          $$ScheduledExercisesTableOrderingComposer,
          $$ScheduledExercisesTableAnnotationComposer,
          $$ScheduledExercisesTableCreateCompanionBuilder,
          $$ScheduledExercisesTableUpdateCompanionBuilder,
          (
            ScheduledExercise,
            BaseReferences<
              _$AppDatabase,
              $ScheduledExercisesTable,
              ScheduledExercise
            >,
          ),
          ScheduledExercise,
          PrefetchHooks Function()
        > {
  $$ScheduledExercisesTableTableManager(
    _$AppDatabase db,
    $ScheduledExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayOfWeek = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int> targetReps = const Value.absent(),
              }) => ScheduledExercisesCompanion(
                id: id,
                dayOfWeek: dayOfWeek,
                exerciseName: exerciseName,
                targetSets: targetSets,
                targetReps: targetReps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayOfWeek,
                required String exerciseName,
                Value<int> targetSets = const Value.absent(),
                Value<int> targetReps = const Value.absent(),
              }) => ScheduledExercisesCompanion.insert(
                id: id,
                dayOfWeek: dayOfWeek,
                exerciseName: exerciseName,
                targetSets: targetSets,
                targetReps: targetReps,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduledExercisesTable, ScheduledExercise>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ScheduledExercisesTable,
                    ScheduledExercise
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduledExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledExercisesTable,
      ScheduledExercise,
      $$ScheduledExercisesTableFilterComposer,
      $$ScheduledExercisesTableOrderingComposer,
      $$ScheduledExercisesTableAnnotationComposer,
      $$ScheduledExercisesTableCreateCompanionBuilder,
      $$ScheduledExercisesTableUpdateCompanionBuilder,
      (
        ScheduledExercise,
        BaseReferences<
          _$AppDatabase,
          $ScheduledExercisesTable,
          ScheduledExercise
        >,
      ),
      ScheduledExercise,
      PrefetchHooks Function()
    >;
typedef $$SupplementsTableCreateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      required String name,
      required String dosage,
      required String timing,
      required String category,
      required String objective,
    });
typedef $$SupplementsTableUpdateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> dosage,
      Value<String> timing,
      Value<String> category,
      Value<String> objective,
    });

class $$SupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableFilterComposer({
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

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableOrderingComposer({
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

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objective => $composableBuilder(
    column: $table.objective,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableAnnotationComposer({
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

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get objective =>
      $composableBuilder(column: $table.objective, builder: (column) => column);
}

class $$SupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementsTable,
          Supplement,
          $$SupplementsTableFilterComposer,
          $$SupplementsTableOrderingComposer,
          $$SupplementsTableAnnotationComposer,
          $$SupplementsTableCreateCompanionBuilder,
          $$SupplementsTableUpdateCompanionBuilder,
          (
            Supplement,
            BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>,
          ),
          Supplement,
          PrefetchHooks Function()
        > {
  $$SupplementsTableTableManager(_$AppDatabase db, $SupplementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> dosage = const Value.absent(),
                Value<String> timing = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> objective = const Value.absent(),
              }) => SupplementsCompanion(
                id: id,
                name: name,
                dosage: dosage,
                timing: timing,
                category: category,
                objective: objective,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String dosage,
                required String timing,
                required String category,
                required String objective,
              }) => SupplementsCompanion.insert(
                id: id,
                name: name,
                dosage: dosage,
                timing: timing,
                category: category,
                objective: objective,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupplementsTable, Supplement>(table),
                  BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementsTable,
      Supplement,
      $$SupplementsTableFilterComposer,
      $$SupplementsTableOrderingComposer,
      $$SupplementsTableAnnotationComposer,
      $$SupplementsTableCreateCompanionBuilder,
      $$SupplementsTableUpdateCompanionBuilder,
      (
        Supplement,
        BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>,
      ),
      Supplement,
      PrefetchHooks Function()
    >;
typedef $$ScheduledSupplementsTableCreateCompanionBuilder =
    ScheduledSupplementsCompanion Function({
      Value<int> id,
      required String dayOfWeek,
      required String supplementName,
      required String dosage,
      required String timing,
    });
typedef $$ScheduledSupplementsTableUpdateCompanionBuilder =
    ScheduledSupplementsCompanion Function({
      Value<int> id,
      Value<String> dayOfWeek,
      Value<String> supplementName,
      Value<String> dosage,
      Value<String> timing,
    });

class $$ScheduledSupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledSupplementsTable> {
  $$ScheduledSupplementsTableFilterComposer({
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

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementName => $composableBuilder(
    column: $table.supplementName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScheduledSupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledSupplementsTable> {
  $$ScheduledSupplementsTableOrderingComposer({
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

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementName => $composableBuilder(
    column: $table.supplementName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScheduledSupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledSupplementsTable> {
  $$ScheduledSupplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get supplementName => $composableBuilder(
    column: $table.supplementName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);
}

class $$ScheduledSupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledSupplementsTable,
          ScheduledSupplement,
          $$ScheduledSupplementsTableFilterComposer,
          $$ScheduledSupplementsTableOrderingComposer,
          $$ScheduledSupplementsTableAnnotationComposer,
          $$ScheduledSupplementsTableCreateCompanionBuilder,
          $$ScheduledSupplementsTableUpdateCompanionBuilder,
          (
            ScheduledSupplement,
            BaseReferences<
              _$AppDatabase,
              $ScheduledSupplementsTable,
              ScheduledSupplement
            >,
          ),
          ScheduledSupplement,
          PrefetchHooks Function()
        > {
  $$ScheduledSupplementsTableTableManager(
    _$AppDatabase db,
    $ScheduledSupplementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledSupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledSupplementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ScheduledSupplementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayOfWeek = const Value.absent(),
                Value<String> supplementName = const Value.absent(),
                Value<String> dosage = const Value.absent(),
                Value<String> timing = const Value.absent(),
              }) => ScheduledSupplementsCompanion(
                id: id,
                dayOfWeek: dayOfWeek,
                supplementName: supplementName,
                dosage: dosage,
                timing: timing,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayOfWeek,
                required String supplementName,
                required String dosage,
                required String timing,
              }) => ScheduledSupplementsCompanion.insert(
                id: id,
                dayOfWeek: dayOfWeek,
                supplementName: supplementName,
                dosage: dosage,
                timing: timing,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduledSupplementsTable, ScheduledSupplement>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ScheduledSupplementsTable,
                    ScheduledSupplement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScheduledSupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledSupplementsTable,
      ScheduledSupplement,
      $$ScheduledSupplementsTableFilterComposer,
      $$ScheduledSupplementsTableOrderingComposer,
      $$ScheduledSupplementsTableAnnotationComposer,
      $$ScheduledSupplementsTableCreateCompanionBuilder,
      $$ScheduledSupplementsTableUpdateCompanionBuilder,
      (
        ScheduledSupplement,
        BaseReferences<
          _$AppDatabase,
          $ScheduledSupplementsTable,
          ScheduledSupplement
        >,
      ),
      ScheduledSupplement,
      PrefetchHooks Function()
    >;
typedef $$BodyMeasurementsTableCreateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> id,
      required DateTime date,
      required double weight,
      required double waist,
      required double chest,
      required double armRelaxed,
      required double armFlexed,
      required double thighProximal,
      required double thighMid,
      required double hip,
      required int restingHeartRate,
    });
typedef $$BodyMeasurementsTableUpdateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> weight,
      Value<double> waist,
      Value<double> chest,
      Value<double> armRelaxed,
      Value<double> armFlexed,
      Value<double> thighProximal,
      Value<double> thighMid,
      Value<double> hip,
      Value<int> restingHeartRate,
    });

class $$BodyMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waist => $composableBuilder(
    column: $table.waist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chest => $composableBuilder(
    column: $table.chest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get armRelaxed => $composableBuilder(
    column: $table.armRelaxed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get armFlexed => $composableBuilder(
    column: $table.armFlexed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thighProximal => $composableBuilder(
    column: $table.thighProximal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get thighMid => $composableBuilder(
    column: $table.thighMid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hip => $composableBuilder(
    column: $table.hip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waist => $composableBuilder(
    column: $table.waist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chest => $composableBuilder(
    column: $table.chest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get armRelaxed => $composableBuilder(
    column: $table.armRelaxed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get armFlexed => $composableBuilder(
    column: $table.armFlexed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thighProximal => $composableBuilder(
    column: $table.thighProximal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get thighMid => $composableBuilder(
    column: $table.thighMid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hip => $composableBuilder(
    column: $table.hip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get waist =>
      $composableBuilder(column: $table.waist, builder: (column) => column);

  GeneratedColumn<double> get chest =>
      $composableBuilder(column: $table.chest, builder: (column) => column);

  GeneratedColumn<double> get armRelaxed => $composableBuilder(
    column: $table.armRelaxed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get armFlexed =>
      $composableBuilder(column: $table.armFlexed, builder: (column) => column);

  GeneratedColumn<double> get thighProximal => $composableBuilder(
    column: $table.thighProximal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get thighMid =>
      $composableBuilder(column: $table.thighMid, builder: (column) => column);

  GeneratedColumn<double> get hip =>
      $composableBuilder(column: $table.hip, builder: (column) => column);

  GeneratedColumn<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => column,
  );
}

class $$BodyMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurement,
          $$BodyMeasurementsTableFilterComposer,
          $$BodyMeasurementsTableOrderingComposer,
          $$BodyMeasurementsTableAnnotationComposer,
          $$BodyMeasurementsTableCreateCompanionBuilder,
          $$BodyMeasurementsTableUpdateCompanionBuilder,
          (
            BodyMeasurement,
            BaseReferences<
              _$AppDatabase,
              $BodyMeasurementsTable,
              BodyMeasurement
            >,
          ),
          BodyMeasurement,
          PrefetchHooks Function()
        > {
  $$BodyMeasurementsTableTableManager(
    _$AppDatabase db,
    $BodyMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<double> waist = const Value.absent(),
                Value<double> chest = const Value.absent(),
                Value<double> armRelaxed = const Value.absent(),
                Value<double> armFlexed = const Value.absent(),
                Value<double> thighProximal = const Value.absent(),
                Value<double> thighMid = const Value.absent(),
                Value<double> hip = const Value.absent(),
                Value<int> restingHeartRate = const Value.absent(),
              }) => BodyMeasurementsCompanion(
                id: id,
                date: date,
                weight: weight,
                waist: waist,
                chest: chest,
                armRelaxed: armRelaxed,
                armFlexed: armFlexed,
                thighProximal: thighProximal,
                thighMid: thighMid,
                hip: hip,
                restingHeartRate: restingHeartRate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double weight,
                required double waist,
                required double chest,
                required double armRelaxed,
                required double armFlexed,
                required double thighProximal,
                required double thighMid,
                required double hip,
                required int restingHeartRate,
              }) => BodyMeasurementsCompanion.insert(
                id: id,
                date: date,
                weight: weight,
                waist: waist,
                chest: chest,
                armRelaxed: armRelaxed,
                armFlexed: armFlexed,
                thighProximal: thighProximal,
                thighMid: thighMid,
                hip: hip,
                restingHeartRate: restingHeartRate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyMeasurementsTable, BodyMeasurement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyMeasurementsTable,
                    BodyMeasurement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMeasurementsTable,
      BodyMeasurement,
      $$BodyMeasurementsTableFilterComposer,
      $$BodyMeasurementsTableOrderingComposer,
      $$BodyMeasurementsTableAnnotationComposer,
      $$BodyMeasurementsTableCreateCompanionBuilder,
      $$BodyMeasurementsTableUpdateCompanionBuilder,
      (
        BodyMeasurement,
        BaseReferences<_$AppDatabase, $BodyMeasurementsTable, BodyMeasurement>,
      ),
      BodyMeasurement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutLogsTableTableManager get workoutLogs =>
      $$WorkoutLogsTableTableManager(_db, _db.workoutLogs);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WeeklySchedulesTableTableManager get weeklySchedules =>
      $$WeeklySchedulesTableTableManager(_db, _db.weeklySchedules);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ScheduledExercisesTableTableManager get scheduledExercises =>
      $$ScheduledExercisesTableTableManager(_db, _db.scheduledExercises);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
  $$ScheduledSupplementsTableTableManager get scheduledSupplements =>
      $$ScheduledSupplementsTableTableManager(_db, _db.scheduledSupplements);
  $$BodyMeasurementsTableTableManager get bodyMeasurements =>
      $$BodyMeasurementsTableTableManager(_db, _db.bodyMeasurements);
}
