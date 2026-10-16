import 'dart:io';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class WorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseName => text()();
  RealColumn get weight => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real()();
  IntColumn get rir => integer().nullable()();
  TextColumn get setType => text().withDefault(const Constant('Normal'))();
  TextColumn get recommendation => text()();
  DateTimeColumn get date => dateTime()();
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get category => text()();
  TextColumn get biomechanicalNote => text().nullable()();
  TextColumn get imagePath => text().nullable()(); // Campo para a miniatura estática
  TextColumn get gifPath => text().nullable()();   // Campo para o GIF animado/vídeo
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))(); // Identifica exercícios padrão de fábrica
}

class WeeklySchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayOfWeek => text().unique()();
  TextColumn get focusMuscle => text()();
  TextColumn get notes => text().nullable()();
}

class ScheduledExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayOfWeek => text()();
  TextColumn get exerciseName => text()();
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  IntColumn get targetReps => integer().withDefault(const Constant(10))();
}

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Supplements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get dosage => text()();
  TextColumn get timing => text()();
  TextColumn get category => text()();
  TextColumn get objective => text()();
}

class ScheduledSupplements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayOfWeek => text()();
  TextColumn get supplementName => text()();
  TextColumn get dosage => text()();
  TextColumn get timing => text()();
}

class BodyMeasurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weight => real()();
  RealColumn get waist => real()();
  RealColumn get chest => real()();
  RealColumn get armRelaxed => real()();
  RealColumn get armFlexed => real()();
  RealColumn get thighProximal => real()();
  RealColumn get thighMid => real()();
  RealColumn get hip => real()();
  IntColumn get restingHeartRate => integer()();
}

@DriftDatabase(tables: [
  WorkoutLogs,
  Exercises,
  WeeklySchedules,
  UserProfiles,
  Categories,
  ScheduledExercises,
  Supplements,
  ScheduledSupplements,
  BodyMeasurements,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 20; // Incrementado para suportar isDefault em Exercises

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedDefaultExercisesFromJson();
          await _seedDefaultSchedule();
          await _seedDefaultProfile();
          await _seedDefaultCategoriesFromJson();
          await _seedDefaultSupplements();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 19) {
            try {
              await m.addColumn(exercises, exercises.imagePath);
            } catch (_) {}
            try {
              await m.addColumn(exercises, exercises.gifPath);
            } catch (_) {}
          }
          if (from < 20) {
            try {
              await m.addColumn(exercises, exercises.isDefault);
            } catch (_) {}
          }
        },
      );

  Future<List<WorkoutLog>> getAllLogs() => select(workoutLogs).get();
  Future<int> insertWorkoutLog(WorkoutLogsCompanion log) => into(workoutLogs).insert(log);

  Future<int> clearWorkoutLogs() async {
    return await delete(workoutLogs).go();
  }

  Future<int> getCompletedWorkoutsCount() async {
    final allLogs = await select(workoutLogs).get();
    if (allLogs.isEmpty) return 0;
    
    final uniqueDays = allLogs
        .map((log) => "${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}")
        .toSet();
    
    return uniqueDays.length;
  }

  Future<String> getUserName() async {
    final profile = await select(userProfiles).getSingleOrNull();
    return profile?.name ?? 'Donrossi';
  }

  Future<void> updateUserName(String newName) async {
    final existing = await select(userProfiles).getSingleOrNull();
    if (existing != null) {
      await (update(userProfiles)..where((t) => t.id.equals(existing.id))).write(
        UserProfilesCompanion(name: Value(newName)),
      );
    } else {
      await into(userProfiles).insert(
        UserProfilesCompanion.insert(name: newName),
      );
    }
  }

  // Função auxiliar para normalizar e limpar os nomes das categorias
  String _normalizeCategory(String rawCategory) {
    final lower = rawCategory.toLowerCase();
    if (lower.contains('costas') || lower.contains('dorsais')) return 'Costas';
    if (lower.contains('ombro') || lower.contains('deltoides')) return 'Ombros';
    if (lower.contains('abdômen') || lower.contains('abdômen e core') || lower.contains('abdómen')) return 'Abdómen';
    if (lower.contains('perna')) return 'Pernas';
    if (lower.contains('peito')) return 'Peito';
    if (lower.contains('tríceps')) return 'Tríceps';
    if (lower.contains('bíceps')) return 'Bíceps';
    if (lower.contains('panturrilha')) return 'Panturrilhas';
    if (lower.contains('antebraço')) return 'Antebraços';
    if (lower.contains('cardio')) return 'Cardio';
    return rawCategory;
  }

  Future<void> _seedDefaultExercisesFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/default_exercises.json');
      final data = json.decode(jsonString);
      final exercisesList = data['workout_data']['exercises'] as List;

      for (var ex in exercisesList) {
        final name = ex['name'] as String;
        final rawCat = ex['category'] as String;
        final category = _normalizeCategory(rawCat);
        final note = ex['note'] as String?;

        await into(exercises).insert(
          ExercisesCompanion.insert(
            name: name,
            category: category,
            biomechanicalNote: Value(note == null || note.isEmpty ? null : note),
            isDefault: const Value(true),
          ),
          onConflict: DoUpdate(
            (old) => ExercisesCompanion(
              category: Value(category),
              biomechanicalNote: Value(note == null || note.isEmpty ? null : note),
              isDefault: const Value(true),
            ),
            target: [exercises.name],
          ),
        );
      }
    } catch (e) {
      // Fallback padrão se necessário
    }
  }

  // Importação massiva com captura correta de imagem, GIF e normalização de categorias
  Future<void> importMassiveExercisesFromJson() async {
    final jsonString = await rootBundle.loadString('assets/data/exercises.json');
    final dynamic decodedData = json.decode(jsonString);

    List<dynamic> exercisesList = [];
    if (decodedData is List) {
      exercisesList = decodedData;
    } else if (decodedData is Map) {
      if (decodedData.values.isNotEmpty && decodedData.values.first is Map) {
        exercisesList = decodedData.values.toList();
      } else {
        exercisesList = decodedData['exercises'] ?? decodedData['data'] ?? decodedData['results'] ?? [];
        if (exercisesList.isEmpty) {
          for (var entry in decodedData.entries) {
            if (entry.value is List) {
              exercisesList = entry.value;
              break;
            }
          }
        }
      }
    }

    if (exercisesList.isEmpty) {
      throw Exception('A lista de exercícios no ficheiro JSON está vazia.');
    }

    await transaction(() async {
      for (var ex in exercisesList) {
        if (ex is Map) {
          final name = ex['name']?.toString() ?? ex['title']?.toString() ?? 'Exercício Sem Nome';
          final rawCategory = ex['category']?.toString() ?? ex['muscle_group']?.toString() ?? ex['body_part']?.toString() ?? 'Outros';
          final category = _normalizeCategory(rawCategory);
          
          final imgPath = ex['image']?.toString();
          final gifPath = ex['gif_url']?.toString();

          final equipment = ex['equipment']?.toString();
          final noteText = equipment != null && equipment.isNotEmpty 
              ? 'Equipamento: $equipment. Foco na tensão mecânica e amplitude máxima.' 
              : 'Foco na tensão mecânica e amplitude máxima.';

          await into(exercises).insert(
            ExercisesCompanion.insert(
              name: name,
              category: category,
              biomechanicalNote: Value(noteText),
              imagePath: Value(imgPath),
              gifPath: Value(gifPath),
              isDefault: const Value(true),
            ),
            onConflict: DoUpdate(
              (old) => ExercisesCompanion(
                category: Value(category),
                biomechanicalNote: Value(noteText),
                imagePath: Value(imgPath),
                gifPath: Value(gifPath),
                isDefault: const Value(true),
              ),
              target: [exercises.name],
            ),
          );

          await into(categories).insert(
            CategoriesCompanion.insert(name: category),
            onConflict: DoUpdate(
              (old) => CategoriesCompanion(name: Value(category)),
              target: [categories.name],
            ),
          );
        }
      }
    });
  }

  Future<void> _seedDefaultCategoriesFromJson() async {
    final cats = [
      'Bíceps',
      'Pernas',
      'Ombros',
      'Costas',
      'Peito',
      'Tríceps',
      'Abdómen',
      'Panturrilhas',
      'Antebraços',
      'Cardio',
      'Dia de Descanso'
    ];
    for (var c in cats) {
      await into(categories).insert(
        CategoriesCompanion.insert(name: c),
        onConflict: DoUpdate(
          (old) => CategoriesCompanion(name: Value(c)),
          target: [categories.name],
        ),
      );
    }
  }

  Future<void> _seedDefaultSchedule() async {
    final days = ['Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado', 'Domingo'];
    for (int i = 0; i < days.length; i++) {
      await into(weeklySchedules).insert(
        WeeklySchedulesCompanion.insert(
          dayOfWeek: days[i],
          focusMuscle: '',
          notes: const Value('Foco na tensão mecânica e progressão de carga rigorosa.'),
        ),
        onConflict: DoUpdate(
          (old) => WeeklySchedulesCompanion(
            notes: const Value('Foco na tensão mecânica e progressão de carga rigorosa.'),
          ),
          target: [weeklySchedules.dayOfWeek],
        ),
      );
    }
  }

  Future<void> _seedDefaultProfile() async {
    await into(userProfiles).insert(
      UserProfilesCompanion.insert(name: 'Donrossi'),
      onConflict: DoUpdate(
        (old) => UserProfilesCompanion(name: const Value('Donrossi')),
        target: [userProfiles.id],
      ),
    );
  }

  Future<void> _seedDefaultSupplements() async {
    // Mantém os suplementos padrão
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gym_donrossi.sqlite'));
    return NativeDatabase(file);
  });
}