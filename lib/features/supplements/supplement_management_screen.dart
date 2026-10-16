import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class SupplementManagementScreen extends StatefulWidget {
  final AppDatabase database;

  const SupplementManagementScreen({super.key, required this.database});

  @override
  State<SupplementManagementScreen> createState() => _SupplementManagementScreenState();
}

class _SupplementManagementScreenState extends State<SupplementManagementScreen> {
  List<Supplement> _supplements = [];
  List<String> _supplementCategories = [
    'Ganho de Massa e Hipertrofia',
    'Emagrecimento e Queima de Gordura',
    'Performance, Força e Explosão',
    'Recuperação Muscular',
    'Vitaminas, Minerais e Saúde Geral',
    'Saúde Cardiovascular',
    'Sono, Relaxamento e Recuperação Nervosa',
  ];
  bool _isLoading = true;

  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _suppNameController = TextEditingController();
  final TextEditingController _suppDosageController = TextEditingController();
  final TextEditingController _suppTimingController = TextEditingController();
  
  String? _selectedCategoryForSupplement;
  int? _editingSupplementId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _newCategoryController.dispose();
    _suppNameController.dispose();
    _suppDosageController.dispose();
    _suppTimingController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final supps = await widget.database.select(widget.database.supplements).get();

    for (var s in supps) {
      if (s.category.isNotEmpty && !_supplementCategories.contains(s.category)) {
        _supplementCategories.add(s.category);
      }
    }

    if (_selectedCategoryForSupplement == null || !_supplementCategories.contains(_selectedCategoryForSupplement)) {
      _selectedCategoryForSupplement = _supplementCategories.isNotEmpty ? _supplementCategories.first : null;
    }

    setState(() {
      _supplements = supps;
      _isLoading = false;
    });
  }

  Future<void> _addCategory() async {
    final catName = _newCategoryController.text.trim();
    if (catName.isNotEmpty && !_supplementCategories.contains(catName)) {
      setState(() {
        _supplementCategories.add(catName);
        _selectedCategoryForSupplement ??= catName;
        _newCategoryController.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoria adicionada com sucesso!')),
      );
    }
  }

  Future<void> _deleteCategory(String categoryName) async {
    final suppsUsingCat = _supplements.where((s) => s.category == categoryName).toList();
    if (suppsUsingCat.isNotEmpty) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.obsidianSurface,
          title: const Text('Ação não permitida', style: TextStyle(color: AppTheme.goldPrimary)),
          content: Text(
            'Existem ${suppsUsingCat.length} suplemento(s) nesta categoria. Remova-os ou altere-os antes de excluir.',
            style: const TextStyle(color: AppTheme.textWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: AppTheme.goldPrimary)),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _supplementCategories.remove(categoryName);
      if (_selectedCategoryForSupplement == categoryName) {
        _selectedCategoryForSupplement = _supplementCategories.isNotEmpty ? _supplementCategories.first : null;
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoria excluída com sucesso!')),
    );
  }

  void _startEditingSupplement(Supplement s) {
    setState(() {
      _editingSupplementId = s.id;
      _suppNameController.text = s.name;
      _suppDosageController.text = s.dosage;
      _suppTimingController.text = s.timing;
      if (_supplementCategories.contains(s.category)) {
        _selectedCategoryForSupplement = s.category;
      }
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingSupplementId = null;
      _suppNameController.clear();
      _suppDosageController.clear();
      _suppTimingController.clear();
    });
  }

  Future<void> _saveSupplement() async {
    final name = _suppNameController.text.trim();
    final dosage = _suppDosageController.text.trim();
    final timing = _suppTimingController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o nome do suplemento.')),
      );
      return;
    }

    if (_selectedCategoryForSupplement == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma categoria.')),
      );
      return;
    }

    try {
      if (_editingSupplementId == null) {
        await widget.database.into(widget.database.supplements).insert(
              SupplementsCompanion.insert(
                name: name,
                dosage: dosage.isNotEmpty ? dosage : 'N/A',
                timing: timing.isNotEmpty ? timing : 'N/A',
                category: _selectedCategoryForSupplement!,
                objective: '',
              ),
            );
      } else {
        await (widget.database.update(widget.database.supplements)
              ..where((t) => t.id.equals(_editingSupplementId!)))
            .write(
          SupplementsCompanion(
            name: drift.Value(name),
            dosage: drift.Value(dosage.isNotEmpty ? dosage : 'N/A'),
            timing: drift.Value(timing.isNotEmpty ? timing : 'N/A'),
            category: drift.Value(_selectedCategoryForSupplement!),
          ),
        );
      }

      _cancelEditing();
      await _loadData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingSupplementId == null
              ? 'Suplemento cadastrado com sucesso!'
              : 'Suplemento atualizado com sucesso!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar suplemento: $e')),
      );
    }
  }

  Future<void> _deleteSupplement(int id) async {
    if (_editingSupplementId == id) {
      _cancelEditing();
    }
    await (widget.database.delete(widget.database.supplements)..where((t) => t.id.equals(id))).go();
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = _editingSupplementId != null;
    final int uniqueCategoriesCount = _supplementCategories.length;
    final int totalSupplementsCount = _supplements.length;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gestor de Suplementos'), centerTitle: true),
        body: const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Suplementos'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ⚠️ BANNER DE AVISO LEGAL COM TEXTO JUSTIFICADO
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppTheme.goldPrimary, size: 26),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'As dosagens aqui geridas são meramente informativas. Consulte obrigatoriamente um Nutricionista ou Médico em Portugal antes de iniciar qualquer consumo.',
                    textAlign: TextAlign.justify, // Texto justificado solicitado
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          // PAINÉIS SUPERIORES DE ESTATÍSTICAS
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
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
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
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalSupplementsCount',
                        style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // PAINEL DE CATEGORIAS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.obsidianSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.goldPrimary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GESTÃO DE CATEGORIAS',
                  style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Color(0xFF2C2C2C), height: 24),
                const Text('Adicionar Nova Categoria:', style: TextStyle(color: AppTheme.textWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newCategoryController,
                        style: const TextStyle(color: AppTheme.textWhite),
                        decoration: const InputDecoration(
                          hintText: 'Nome da categoria...',
                          hintStyle: TextStyle(color: AppTheme.textMuted),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
                      onPressed: _addCategory,
                      child: const Text('Criar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Categorias Existentes:', style: TextStyle(color: AppTheme.textWhite, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._supplementCategories.map((cat) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(cat, style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.w500))),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () => _deleteCategory(cat),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // PAINEL DE CADASTRO / EDIÇÃO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.obsidianSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isEditing ? Colors.orangeAccent : AppTheme.goldPrimary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'EDITAR SUPLEMENTO' : 'CADASTRO DE SUPLEMENTO',
                      style: TextStyle(color: isEditing ? Colors.orangeAccent : AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (isEditing)
                      TextButton.icon(
                        onPressed: _cancelEditing,
                        icon: const Icon(Icons.close, size: 16, color: Colors.orangeAccent),
                        label: const Text('Cancelar', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                      ),
                  ],
                ),
                const Divider(color: Color(0xFF2C2C2C), height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryForSupplement,
                  dropdownColor: AppTheme.obsidianSurface,
                  style: const TextStyle(color: AppTheme.textWhite),
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: TextStyle(color: AppTheme.textMuted),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                  ),
                  items: _supplementCategories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryForSupplement = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _suppNameController,
                  style: const TextStyle(color: AppTheme.textWhite),
                  decoration: const InputDecoration(
                    labelText: 'Nome do Suplemento',
                    labelStyle: TextStyle(color: AppTheme.textMuted),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _suppDosageController,
                        style: const TextStyle(color: AppTheme.textWhite),
                        decoration: const InputDecoration(
                          labelText: 'Dosagem (ex: 5g)',
                          labelStyle: TextStyle(color: AppTheme.textMuted),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _suppTimingController,
                        style: const TextStyle(color: AppTheme.textWhite),
                        decoration: const InputDecoration(
                          labelText: 'Horário (ex: Pós-treino)',
                          labelStyle: TextStyle(color: AppTheme.textMuted),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isEditing ? Colors.orangeAccent : AppTheme.goldPrimary),
                    onPressed: _saveSupplement,
                    child: Text(
                      isEditing ? 'Atualizar Suplemento' : 'Salvar Suplemento',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // LISTAGEM DE SUPLEMENTOS POR CATEGORIA
          const Text(
            'SUPLEMENTOS CADASTRADOS',
            style: TextStyle(color: AppTheme.goldPrimary, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._supplementCategories.map((category) {
            final suppsInCategory = _supplements.where((s) => s.category == category).toList();

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.obsidianSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          category,
                          style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
                        ),
                        child: Text('${suppsInCategory.length}', style: const TextStyle(color: AppTheme.textWhite, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF2C2C2C), height: 16),
                  if (suppsInCategory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Nenhum suplemento nesta categoria.', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontStyle: FontStyle.italic)),
                    )
                  else
                    ...suppsInCategory.map((s) {
                      final bool isSelectedForEdit = _editingSupplementId == s.id;
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelectedForEdit ? Colors.orange.withOpacity(0.1) : Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelectedForEdit ? Colors.orangeAccent : AppTheme.goldPrimary.withOpacity(0.2),
                            width: isSelectedForEdit ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${s.name} (${s.dosage})',
                                    style: TextStyle(
                                      color: isSelectedForEdit ? Colors.orangeAccent : AppTheme.textWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Horário: ${s.timing}',
                                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppTheme.goldPrimary, size: 18),
                                  onPressed: () => _startEditingSupplement(s),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
                                  onPressed: () => _deleteSupplement(s.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}