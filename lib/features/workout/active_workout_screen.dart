import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class ActiveWorkoutScreen extends StatefulWidget {
  final AppDatabase database;
  final String dayOfWeek;
  final String focusMuscle;

  const ActiveWorkoutScreen({
    super.key,
    required this.database,
    required this.dayOfWeek,
    required this.focusMuscle,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final List<Map<String, dynamic>> _loggedSets = [];
  List<ScheduledSupplement> _scheduledSupplements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final scheduledExs = await (widget.database.select(widget.database.scheduledExercises)
          ..where((t) => t.dayOfWeek.equals(widget.dayOfWeek)))
        .get();

    final allExercises = await widget.database.select(widget.database.exercises).get();

    List<Map<String, dynamic>> preloadedSets = [];
    for (var se in scheduledExs) {
      // Procura o exercício correspondente para obter o imagePath e gifPath
      final match = allExercises.firstWhere(
        (e) => e.name == se.exerciseName,
        orElse: () => Exercise(
          id: 0,
          name: se.exerciseName,
          category: '',
          isDefault: false,
        ),
      );

      preloadedSets.add({
        'exerciseName': se.exerciseName,
        'imagePath': match.imagePath,
        'gifPath': match.gifPath,
        'weight': 0.0,
        'reps': se.targetReps,
        'rpe': 8.0,
        'rir': 2,
        'setType': 'Normal',
        'recommendation': 'Seguir planeamento (${se.targetSets} séries x ${se.targetReps} reps).',
        'isCompleted': false,
      });
    }

    final supps = await (widget.database.select(widget.database.scheduledSupplements)
          ..where((t) => t.dayOfWeek.equals(widget.dayOfWeek)))
        .get();

    setState(() {
      if (preloadedSets.isNotEmpty) {
        _loggedSets.addAll(preloadedSets);
      }
      _scheduledSupplements = supps;
      _isLoading = false;
    });
  }

  // Função para abrir o pop-up com o GIF/vídeo do exercício
  void _showExerciseMediaDialog(BuildContext context, String exerciseName, String? gifPath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.goldPrimary, width: 1),
        ),
        title: Text(
          exerciseName,
          style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (gifPath != null && gifPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/$gifPath',
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'Animação indisponível nos assets.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Sem animação disponível para este exercício.',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR', style: TextStyle(color: AppTheme.goldPrimary)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndClearWorkoutLogs() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.goldPrimary, width: 1),
        ),
        title: const Text(
          'LIMPAR HISTÓRICO DE TREINOS',
          style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tem a certeza de que deseja apagar todos os registos de treinos guardados? Os seus exercícios, grupos musculares, suplementos e definições serão mantidos intactos.',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('APAGAR HISTÓRICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.database.clearWorkoutLogs();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Histórico de treinos limpo com sucesso! Contador reposto a 0.'),
          backgroundColor: AppTheme.goldPrimary,
        ),
      );
    }
  }

  void _openRestTimerModal(BuildContext context, String exerciseName) {
    int remainingSeconds = 180;
    Timer? timer;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (remainingSeconds > 0) {
                if (context.mounted) {
                  setStateModal(() {
                    remainingSeconds--;
                  });
                }
              } else {
                t.cancel();
              }
            });

            String formatTime(int seconds) {
              final minutes = seconds ~/ 60;
              final secs = seconds % 60;
              return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
            }

            return AlertDialog(
              backgroundColor: AppTheme.obsidianSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.goldPrimary, width: 1),
              ),
              title: Column(
                children: [
                  const Text(
                    'DESCANSO ÓTIMO (MAV)',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exerciseName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Baseada nos princípios de tensão mecânica e volume total defendidos pelo Dr. Brad Schoenfeld: 3 min garantem ressíntese de ATP e volume máximo na próxima série.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                    ),
                    child: Text(
                      formatTime(remainingSeconds),
                      style: const TextStyle(
                        color: AppTheme.goldPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setStateModal(() {
                            remainingSeconds += 30;
                          });
                        },
                        icon: const Icon(Icons.add, size: 16, color: AppTheme.goldPrimary),
                        label: const Text('+30s', style: TextStyle(color: AppTheme.goldPrimary)),
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: () {
                          setStateModal(() {
                            remainingSeconds = (remainingSeconds - 30).clamp(0, 600);
                          });
                        },
                        icon: const Icon(Icons.remove, size: 16, color: Colors.orangeAccent),
                        label: const Text('-30s', style: TextStyle(color: Colors.orangeAccent)),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.goldPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      timer?.cancel();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'RETOMAR TREINO',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      timer?.cancel();
    });
  }

  Future<void> _finishWorkout() async {
    if (_loggedSets.isEmpty) {
      Navigator.pop(context);
      return;
    }

    for (var set in _loggedSets) {
      await widget.database.insertWorkoutLog(
        WorkoutLogsCompanion.insert(
          exerciseName: set['exerciseName'],
          weight: set['weight'],
          reps: set['reps'],
          rpe: set['rpe'],
          rir: drift.Value(set['rir']),
          setType: drift.Value(set['setType']),
          recommendation: set['recommendation'],
          date: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino guardado com sucesso na base de dados!'),
        backgroundColor: AppTheme.goldPrimary,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessão: ${widget.dayOfWeek}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppTheme.goldPrimary),
            tooltip: 'Limpar Histórico de Treinos',
            onPressed: _confirmAndClearWorkoutLogs,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.obsidianSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Foco da Sessão',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.focusMuscle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.goldPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.obsidianSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Suplementação do Dia',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: _scheduledSupplements.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Nenhum suplemento agendado.',
                                          style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: _scheduledSupplements.length,
                                        itemBuilder: (context, index) {
                                          final sup = _scheduledSupplements[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 3.0),
                                            child: Text(
                                              '• ${sup.supplementName} (${sup.dosage}) - ${sup.timing}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppTheme.goldPrimary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Exercícios e Séries da Sessão Ativa:',
                    style: TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _loggedSets.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum exercício planeado para hoje.',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _loggedSets.length,
                            itemBuilder: (context, index) {
                              final set = _loggedSets[index];
                              final bool isCompleted = set['isCompleted'] ?? false;
                              final String? imagePath = set['imagePath'];
                              final String? gifPath = set['gifPath'];

                              final borderColor = isCompleted ? Colors.greenAccent.shade700 : AppTheme.goldPrimary.withOpacity(0.3);
                              final cardColor = isCompleted ? const Color(0xFF0F2618) : AppTheme.obsidianSurface;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderColor, width: isCompleted ? 1.5 : 1.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Thumbnail clicável para abrir o pop-up com a animação/vídeo
                                        GestureDetector(
                                          onTap: () => _showExerciseMediaDialog(context, set['exerciseName'], gifPath),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.black26,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                                            ),
                                            child: imagePath != null && imagePath.isNotEmpty
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.asset(
                                                      'assets/$imagePath',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                                        Icons.fitness_center,
                                                        color: AppTheme.goldPrimary,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.fitness_center,
                                                    color: AppTheme.goldPrimary,
                                                    size: 24,
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                set['exerciseName'],
                                                style: TextStyle(
                                                  color: isCompleted ? Colors.greenAccent : AppTheme.goldPrimary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Alvo: ${set['reps']} repetições | ${set['recommendation']}',
                                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.play_circle_fill, color: AppTheme.goldPrimary, size: 28),
                                          tooltip: 'Iniciar Descanso (3 min)',
                                          onPressed: () => _openRestTimerModal(context, set['exerciseName']),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(color: Color(0xFF2C2C2C), height: 1),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        height: 36,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isCompleted ? Colors.green.shade800 : AppTheme.obsidianSurface,
                                            foregroundColor: isCompleted ? Colors.white : AppTheme.goldPrimary,
                                            side: BorderSide(
                                              color: isCompleted ? Colors.greenAccent : AppTheme.goldPrimary,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: isCompleted
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _loggedSets[index]['isCompleted'] = true;
                                                  });
                                                },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isCompleted ? Icons.check_circle : Icons.task_alt,
                                                size: 16,
                                                color: isCompleted ? Colors.greenAccent : AppTheme.goldPrimary,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'TREINO EFETUADO',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isCompleted ? Colors.white : AppTheme.goldPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.goldPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _finishWorkout,
                    child: const Text(
                      'FINALIZAR E GUARDAR TREINO',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}