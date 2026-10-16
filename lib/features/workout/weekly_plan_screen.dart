import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class WeeklyPlanScreen extends StatefulWidget {
  final AppDatabase database;

  const WeeklyPlanScreen({super.key, required this.database});

  @override
  State<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends State<WeeklyPlanScreen> {
  bool _isLoading = true;
  int _muscleGroupCount = 0;
  int _exerciseCount = 0;
  List<String> _availableMuscles = [];

  // Estado interno dinâmico para os focos de cada dia da semana
  final Map<String, List<String>> _weeklyFocuses = {
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

    // Carrega categorias e exercícios diretamente da base de dados Drift
    final categories = await widget.database.select(widget.database.categories).get();
    final exercises = await widget.database.select(widget.database.exercises).get();

    setState(() {
      _muscleGroupCount = categories.length;
      _exerciseCount = exercises.length;
      _availableMuscles = categories.map((c) => c.name).toList();
      _isLoading = false;
    });
  }

  // Função para abrir o Bottom Sheet de seleção de foco dinâmico
  void _openFocusSelector(BuildContext context, String dayName) {
    if (_availableMuscles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem grupos musculares cadastrados. Adicione primeiro na Gestão de Exercícios.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Set<String> tempSelectedFocuses = Set.from(_weeklyFocuses[dayName] ?? []);

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        'Editar Foco: $dayName',
                        style: const TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${tempSelectedFocuses.length}/3',
                        style: TextStyle(
                          color: tempSelectedFocuses.length == 3 ? AppTheme.goldPrimary : AppTheme.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Selecione até 3 grupos musculares para este dia:',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableMuscles.map((muscle) {
                      final isSelected = tempSelectedFocuses.contains(muscle);
                      return FilterChip(
                        label: Text(muscle),
                        selected: isSelected,
                        selectedColor: AppTheme.goldPrimary.withOpacity(0.3),
                        checkmarkColor: AppTheme.goldPrimary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.goldPrimary : AppTheme.textWhite,
                        ),
                        backgroundColor: const Color(0xFF2C2C2C),
                        onSelected: (bool selected) {
                          modalSetState(() {
                            if (isSelected) {
                              tempSelectedFocuses.remove(muscle);
                            } else {
                              if (tempSelectedFocuses.length < 3) {
                                tempSelectedFocuses.add(muscle);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pode selecionar no máximo 3 focos por dia'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
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
                      onPressed: () {
                        setState(() {
                          _weeklyFocuses[dayName] = tempSelectedFocuses.toList();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Guardar Foco',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
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
                  final focuses = _weeklyFocuses[day]!;
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
                          mainAxisAlignment: MainAxisAlignment.between,
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
                              onPressed: () {},
                              child: const Text('TREINAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            Expanded(
                              child: Text(
                                focuses.isEmpty
                                    ? 'Foco: Nenhum definido'
                                    : 'Foco: ${focuses.join(' e ')}',
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
                        Text(
                          focuses.isEmpty ? 'Nenhum Treino Planeado' : 'Lista de exercícios associados...',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
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