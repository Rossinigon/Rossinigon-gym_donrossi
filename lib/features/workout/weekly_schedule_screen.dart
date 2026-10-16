import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import 'active_workout_screen.dart';

class WeeklyScheduleScreen extends StatefulWidget {
  final AppDatabase database;

  const WeeklyScheduleScreen({super.key, required this.database});

  @override
  State<WeeklyScheduleScreen> createState() => _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends State<WeeklyScheduleScreen> {
  bool _isLoading = true;
  int _muscleGroupCount = 0;
  int _exerciseCount = 0;
  List<String> _availableMuscles = [];
  List<Exercise> _allExercises = [];

  final Map<String, String> _weeklyFocuses = {
    'Segunda-feira': '',
    'Terça-feira': '',
    'Quarta-feira': '',
    'Quinta-feira': '',
    'Sexta-feira': '',
    'Sábado': '',
    'Domingo': '',
  };

  final Map<String, List<String>> _weeklyExercises = {
    'Segunda-feira': [],
    'Terça-feira': [],
    'Quarta-feira': [],
    'Quinta-feira': [],
    'Sexta-feira': [],
    'Sábado': [],
    'Domingo': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final categories = await widget.database.select(widget.database.categories).get();
    final exercises = await widget.database.select(widget.database.exercises).get();
    
    final savedSchedules = await widget.database.select(widget.database.weeklySchedules).get();
    final savedPlanned = await widget.database.select(widget.database.scheduledExercises).get();

    final Map<String, String> tempFocuses = {
      'Segunda-feira': '', 'Terça-feira': '', 'Quarta-feira': '',
      'Quinta-feira': '', 'Sexta-feira': '', 'Sábado': '', 'Domingo': '',
    };
    for (var s in savedSchedules) {
      if (tempFocuses.containsKey(s.dayOfWeek)) {
        tempFocuses[s.dayOfWeek] = s.focusMuscle;
      }
    }

    final Map<String, List<String>> tempPlanned = {
      'Segunda-feira': [], 'Terça-feira': [], 'Quarta-feira': [],
      'Quinta-feira': [], 'Sexta-feira': [], 'Sábado': [], 'Domingo': [],
    };
    for (var p in savedPlanned) {
      if (tempPlanned.containsKey(p.dayOfWeek)) {
        if (!tempPlanned[p.dayOfWeek]!.contains(p.exerciseName)) {
          tempPlanned[p.dayOfWeek]!.add(p.exerciseName);
        }
      }
    }

    setState(() {
      _muscleGroupCount = categories.length;
      _exerciseCount = exercises.length;
      _availableMuscles = categories.map((c) => c.name).toList();
      _allExercises = exercises;
      _weeklyFocuses.addAll(tempFocuses);
      _weeklyExercises.addAll(tempPlanned);
      _isLoading = false;
    });
  }

  Future<void> _saveFocusToDb(String dayOfWeek, String focusMuscle) async {
    await widget.database.into(widget.database.weeklySchedules).insert(
          WeeklySchedulesCompanion.insert(
            dayOfWeek: dayOfWeek,
            focusMuscle: focusMuscle,
            notes: const drift.Value('Foco na tensão mecânica e progressão de carga rigorosa.'),
          ),
          onConflict: drift.DoUpdate(
            (old) => WeeklySchedulesCompanion(
              focusMuscle: drift.Value(focusMuscle),
              notes: const drift.Value('Foco na tensão mecânica e progressão de carga rigorosa.'),
            ),
            target: [widget.database.weeklySchedules.dayOfWeek],
          ),
        );
  }

  Future<void> _clearAllFocuses() async {
    await widget.database.delete(widget.database.weeklySchedules).go();
    setState(() {
      for (var key in _weeklyFocuses.keys) {
        _weeklyFocuses[key] = '';
      }
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todos os focos semanais foram limpos.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  Future<bool> _addPlannedExerciseToDb(String dayOfWeek, String exerciseName) async {
    if (_weeklyExercises[dayOfWeek]!.contains(exerciseName)) {
      return false;
    }

    await widget.database.into(widget.database.scheduledExercises).insert(
          ScheduledExercisesCompanion.insert(
            dayOfWeek: dayOfWeek,
            exerciseName: exerciseName,
            targetSets: const drift.Value(3),
            targetReps: const drift.Value(10),
          ),
        );
    return true;
  }

  Future<void> _removePlannedExerciseFromDb(String dayOfWeek, String exerciseName) async {
    await (widget.database.delete(widget.database.scheduledExercises)
          ..where((t) => t.dayOfWeek.equals(dayOfWeek) & t.exerciseName.equals(exerciseName)))
        .go();
  }

  void _openFocusSelector(BuildContext context, String dayOfWeek) {
    if (_availableMuscles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem grupos musculares cadastrados.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final currentFocusStr = _weeklyFocuses[dayOfWeek] ?? '';
    List<String> selectedMuscles = currentFocusStr.isNotEmpty && currentFocusStr != 'Nenhum definido'
        ? currentFocusStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList()
        : [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: AppTheme.obsidianSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Definir Foco: $dayOfWeek',
                      style: const TextStyle(
                        color: AppTheme.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Selecione até 4 grupos musculares principais para este dia:',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _availableMuscles.map((muscle) {
                        final isSelected = selectedMuscles.any((m) => m.trim().toLowerCase() == muscle.trim().toLowerCase());
                        return FilterChip(
                          label: Text(muscle),
                          selected: isSelected,
                          selectedColor: AppTheme.goldPrimary.withOpacity(0.3),
                          checkmarkColor: AppTheme.goldPrimary,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.goldPrimary : AppTheme.textWhite,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: const Color(0xFF2C2C2C),
                          onSelected: (bool selected) {
                            modalSetState(() {
                              if (selected) {
                                if (selectedMuscles.length < 4) {
                                  if (!selectedMuscles.contains(muscle)) {
                                    selectedMuscles.add(muscle);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pode selecionar no máximo 4 categorias de foco.'),
                                      backgroundColor: Colors.orangeAccent,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } else {
                                selectedMuscles.removeWhere((m) => m.trim().toLowerCase() == muscle.trim().toLowerCase());
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final finalFocus = selectedMuscles.join(', ');
                          await _saveFocusToDb(dayOfWeek, finalFocus);
                          setState(() {
                            _weeklyFocuses[dayOfWeek] = finalFocus;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar Foco', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openAddExerciseDialog(BuildContext context, String dayOfWeek) {
    if (_allExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem exercícios cadastrados na base de dados.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String? selectedCategory;
    String? selectedExerciseName;
    String? selectedImagePath;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            final filteredExercises = selectedCategory == null
                ? _allExercises
                : _allExercises.where((e) => e.category == selectedCategory).toList();

            return AlertDialog(
              backgroundColor: AppTheme.obsidianSurface,
              title: Text('Adicionar Exercício: $dayOfWeek', style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 18)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Grupo Muscular:', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.obsidianSurface,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      hint: const Text('Selecione o grupo', style: TextStyle(color: AppTheme.textMuted)),
                      value: selectedCategory,
                      items: _availableMuscles.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        dialogSetState(() {
                          selectedCategory = value;
                          selectedExerciseName = null;
                          selectedImagePath = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Exercício:', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      dropdownColor: AppTheme.obsidianSurface,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      hint: const Text('Selecione o exercício', style: TextStyle(color: AppTheme.textMuted)),
                      value: selectedExerciseName,
                      items: filteredExercises.map<DropdownMenuItem<String>>((exercise) {
                        return DropdownMenuItem<String>(
                          value: exercise.name,
                          child: Text(exercise.name, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        dialogSetState(() {
                          selectedExerciseName = value;
                          if (value != null) {
                            try {
                              final match = _allExercises.firstWhere((e) => e.name == value);
                              selectedImagePath = match.imagePath;
                            } catch (_) {
                              selectedImagePath = null;
                            }
                          } else {
                            selectedImagePath = null;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                      ),
                      child: selectedImagePath != null && selectedImagePath!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/$selectedImagePath',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.fitness_center, color: AppTheme.goldPrimary, size: 40),
                                ),
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_outlined, color: AppTheme.goldPrimary, size: 32),
                                  SizedBox(height: 6),
                                  Text('Selecione um exercício para ver a miniatura', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary, foregroundColor: Colors.black),
                  onPressed: selectedExerciseName == null
                      ? null
                      : () async {
                          final success = await _addPlannedExerciseToDb(dayOfWeek, selectedExerciseName!);
                          if (!context.mounted) return;
                          
                          if (success) {
                            setState(() {
                              _weeklyExercises[dayOfWeek]!.add(selectedExerciseName!);
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Este exercício já está planeado para este dia.'),
                                backgroundColor: Colors.orangeAccent,
                              ),
                            );
                          }
                        },
                  child: const Text('Adicionar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planeamento Semanal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.goldPrimary),
            tooltip: 'Limpar Todos os Focos',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.obsidianSurface,
                  title: const Text('Limpar Focos', style: TextStyle(color: AppTheme.goldPrimary)),
                  content: const Text('Deseja limpar o foco de todos os dias da semana?', style: TextStyle(color: AppTheme.textWhite)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        _clearAllFocuses();
                      },
                      child: const Text('Limpar Tudo'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Grupos Musculares', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('$_muscleGroupCount', style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Exercícios Cadastrados', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('$_exerciseCount', style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Distribuição e Treino Planeado',
                  style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._weeklyFocuses.keys.map((day) {
                  final focus = _weeklyFocuses[day] ?? '';
                  final exercises = _weeklyExercises[day] ?? [];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              day,
                              style: const TextStyle(
                                color: AppTheme.goldPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.goldPrimary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActiveWorkoutScreen(
                                      database: widget.database,
                                      dayOfWeek: day,
                                      focusMuscle: focus.isEmpty ? 'Nenhum definido' : focus,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('TREINAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                focus.isEmpty ? 'Foco: Nenhum definido' : 'Foco: $focus',
                                style: const TextStyle(color: AppTheme.textWhite, fontSize: 14),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppTheme.goldPrimary, size: 20),
                              tooltip: 'Alterar Foco',
                              onPressed: () => _openFocusSelector(context, day),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white10, height: 16),
                        const Text(
                          'Exercícios Planeados:',
                          style: TextStyle(color: AppTheme.textWhite, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        exercises.isEmpty
                            ? const Text('Nenhum Treino Planeado', style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: exercises.map((ex) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text('• $ex', style: const TextStyle(color: AppTheme.textWhite, fontSize: 13)),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Colors.redAccent, size: 16),
                                            tooltip: 'Remover Exercício',
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              await _removePlannedExerciseFromDb(day, ex);
                                              setState(() {
                                                _weeklyExercises[day]!.remove(ex);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                              ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(foregroundColor: AppTheme.goldPrimary),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Adicionar Exercício', style: TextStyle(fontSize: 12)),
                            onPressed: () => _openAddExerciseDialog(context, day),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}