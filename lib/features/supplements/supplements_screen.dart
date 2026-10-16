import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class SupplementsScreen extends StatefulWidget {
  final AppDatabase database;

  const SupplementsScreen({super.key, required this.database});

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen> {
  List<Supplement> _supplements = [];
  List<ScheduledSupplement> _scheduledSupplements = [];
  bool _isLoading = true;

  // Lista unificada de categorias padrão do gestor para garantir consistência visual
  final List<String> _supplementCategories = [
    'Ganho de Massa e Hipertrofia',
    'Emagrecimento e Queima de Gordura',
    'Performance, Força e Explosão',
    'Recuperação Muscular',
    'Vitaminas, Minerais e Saúde Geral',
    'Saúde Cardiovascular',
    'Sono, Relaxamento e Recuperação Nervosa',
  ];

  final List<String> _daysOfWeek = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final supps = await widget.database.select(widget.database.supplements).get();
    final scheduled = await widget.database.select(widget.database.scheduledSupplements).get();
    
    // Garante que categorias dinâmicas criadas no gestor também sejam contabilizadas se existirem nos suplementos
    for (var s in supps) {
      if (s.category.isNotEmpty && !_supplementCategories.contains(s.category)) {
        _supplementCategories.add(s.category);
      }
    }

    setState(() {
      _supplements = supps;
      _scheduledSupplements = scheduled;
      _isLoading = false;
    });
  }

  void _showAddScheduleDialog(String day) {
    final availableCategories = _supplementCategories;
    String? selectedCategory = availableCategories.isNotEmpty ? availableCategories.first : null;
    
    List<Supplement> filteredSupplements = selectedCategory != null
        ? _supplements.where((s) => s.category == selectedCategory).toList()
        : [];
    
    String? selectedSupplementName = filteredSupplements.isNotEmpty ? filteredSupplements.first.name : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.obsidianSurface,
              title: Text('Adicionar à Agenda de $day', style: const TextStyle(color: AppTheme.goldPrimary)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _supplements.isEmpty
                      ? const Text('Nenhum suplemento cadastrado. Use o Gestor de Suplementos primeiro.', style: TextStyle(color: AppTheme.textMuted))
                      : Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedCategory,
                              dropdownColor: AppTheme.obsidianSurface,
                              style: const TextStyle(color: AppTheme.textWhite),
                              decoration: const InputDecoration(
                                labelText: 'Categoria',
                                labelStyle: TextStyle(color: AppTheme.textMuted),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                              ),
                              items: availableCategories.map((cat) {
                                return DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setStateDialog(() {
                                    selectedCategory = val;
                                    filteredSupplements = _supplements.where((s) => s.category == selectedCategory).toList();
                                    selectedSupplementName = filteredSupplements.isNotEmpty ? filteredSupplements.first.name : null;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedSupplementName,
                              dropdownColor: AppTheme.obsidianSurface,
                              style: const TextStyle(color: AppTheme.textWhite),
                              decoration: const InputDecoration(
                                labelText: 'Suplemento',
                                labelStyle: TextStyle(color: AppTheme.textMuted),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                              ),
                              items: filteredSupplements.map((s) {
                                return DropdownMenuItem(value: s.name, child: Text('${s.name} (${s.dosage})', overflow: TextOverflow.ellipsis));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setStateDialog(() {
                                    selectedSupplementName = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
                ),
                if (_supplements.isNotEmpty && filteredSupplements.isNotEmpty)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
                    onPressed: () async {
                      if (selectedSupplementName != null) {
                        final chosen = _supplements.firstWhere((s) => s.name == selectedSupplementName);
                        await widget.database.into(widget.database.scheduledSupplements).insert(
                              ScheduledSupplementsCompanion.insert(
                                dayOfWeek: day,
                                supplementName: chosen.name,
                                dosage: chosen.dosage,
                                timing: chosen.timing,
                              ),
                            );

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _loadData();
                      }
                    },
                    child: const Text('Adicionar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteScheduled(int id) async {
    await (widget.database.delete(widget.database.scheduledSupplements)..where((tbl) => tbl.id.equals(id))).go();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza o total de categorias cadastradas no gestor para manter a consistência
    final int uniqueCategoriesCount = _supplementCategories.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planejamento de Suplementação'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Painéis Superiores de Informação
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CATEGORIAS REGISTRADAS',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$uniqueCategoriesCount',
                              style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
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
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SUPLEMENTOS CADASTRADOS',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_supplements.length}',
                              style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Agenda Diária de Consumo
                const Text(
                  'AGENDA DIÁRIA DE CONSUMO',
                  style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._daysOfWeek.map((day) {
                  final itemsForDay = _scheduledSupplements.where((s) => s.dayOfWeek == day).toList();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
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
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppTheme.goldPrimary),
                              tooltip: 'Adicionar ao dia $day',
                              onPressed: () => _showAddScheduleDialog(day),
                            ),
                          ],
                        ),
                        const Divider(color: Color(0xFF2C2C2C), height: 16),
                        itemsForDay.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Nenhum item programado para este dia.',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                ),
                              )
                            : Column(
                                children: itemsForDay.map((sch) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '• ${sch.supplementName} (${sch.dosage})',
                                                style: const TextStyle(
                                                  color: AppTheme.textWhite,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Horário: ${sch.timing}',
                                                style: const TextStyle(
                                                  color: AppTheme.textMuted,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.redAccent, size: 18),
                                          onPressed: () => _deleteScheduled(sch.id),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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