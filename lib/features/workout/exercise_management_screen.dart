import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

class ExerciseManagementScreen extends StatefulWidget {
  final AppDatabase database;

  const ExerciseManagementScreen({super.key, required this.database});

  @override
  State<ExerciseManagementScreen> createState() => _ExerciseManagementScreenState();
}

class _ExerciseManagementScreenState extends State<ExerciseManagementScreen> {
  List<Exercise> _exercises = [];
  List<Category> _categories = [];
  int _exerciseCount = 0;
  int _muscleGroupCount = 0;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();
  String? _selectedCategory;

  String? _selectedImagePath;
  String? _selectedGifPath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await widget.database.select(widget.database.categories).get();
    final currentExercises = await widget.database.select(widget.database.exercises).get();

    setState(() {
      _exercises = currentExercises;
      _categories = categories;
      _exerciseCount = currentExercises.length;
      _muscleGroupCount = categories.length;
      if (_categories.isNotEmpty && (_selectedCategory == null || !_categories.any((c) => c.name == _selectedCategory))) {
        _selectedCategory = _categories.first.name;
      }
      _isLoading = false;
    });
  }

  void _confirmClearDatabase() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.obsidianSurface,
          title: const Text('Atenção - Apagar Tudo', style: TextStyle(color: Colors.redAccent)),
          content: const Text(
            'Tem a certeza absoluta de que pretende apagar todos os exercícios e grupos musculares?\n\nA sua base de dados ficará completamente vazia.',
            style: TextStyle(color: AppTheme.textWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
                _clearAllDatabase();
              },
              child: const Text('Sim, Apagar Tudo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllDatabase() async {
    try {
      await widget.database.delete(widget.database.exercises).go();
      await widget.database.delete(widget.database.categories).go();
      await _loadData();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Base de dados limpa com sucesso!'),
          backgroundColor: AppTheme.goldPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao limpar base de dados: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _exportExercisesToJson() async {
    try {
      final categories = await widget.database.select(widget.database.categories).get();
      final exercises = await widget.database.select(widget.database.exercises).get();

      final exportData = {
        "categories": categories.map((c) => c.name).toList(),
        "exercises": exercises.map((ex) => {
          "name": ex.name,
          "category": ex.category,
          "biomechanicalNote": ex.biomechanicalNote,
          "imagePath": ex.imagePath,
          "gifPath": ex.gifPath,
          "isDefault": ex.isDefault,
        }).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      final bytes = utf8.encode(jsonString);

      final outputFile = await FilePicker.saveFile(
        dialogTitle: 'Escolha onde guardar o Backup JSON',
        fileName: 'gym_donrossi_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        bytes: bytes,
      );

      if (!mounted) return;
      if (outputFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup JSON exportado com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar JSON: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // Importar de um ficheiro externo (armazenamento do telemóvel/PC)
  Future<void> _importExercisesFromJsonFile() async {
    try {
      List<PlatformFile>? pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'johnson'],
        dialogTitle: 'Selecione o ficheiro de base de dados',
      );

      if (pickedFiles == null || pickedFiles.isEmpty || pickedFiles.first.path == null) {
        return;
      }

      final file = File(pickedFiles.first.path!);
      final content = await file.readAsString();
      await _processAndInsertJson(content);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de dados importada com sucesso!'), backgroundColor: AppTheme.goldPrimary),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar ficheiro: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // Importar diretamente do arquivo 'exercises.json' incorporado nos assets (assets/data/)
  Future<void> _importJohnsonDefaultDatabase() async {
    try {
      final String content = await rootBundle.loadString('assets/data/exercises.json');
      await _processAndInsertJson(content, forceDefault: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Base Johnson carregada com sucesso!'),
          backgroundColor: AppTheme.goldPrimary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar exercises.json dos assets: $e'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Função auxiliar robusta para processar o JSON e popular as tabelas Drift
  Future<void> _processAndInsertJson(String jsonContent, {bool forceDefault = false}) async {
    final dynamic decoded = json.decode(jsonContent);

    await widget.database.transaction(() async {
      List? exList;
      List? catList;

      if (decoded is Map) {
        catList = decoded['categories'] ?? 
                  decoded['muscle_groups'] ?? 
                  decoded['groups'] ?? 
                  decoded['category_list'];

        exList = decoded['exercises'] ?? 
                 decoded['workout_data']?['exercises'] ?? 
                 decoded['items'] ?? 
                 decoded['list'];
      } else if (decoded is List) {
        exList = decoded;
      }

      if (catList != null) {
        for (var catName in catList) {
          if (catName != null) {
            final nameStr = catName is Map ? (catName['name']?.toString() ?? '') : catName.toString();
            if (nameStr.isNotEmpty) {
              await widget.database.into(widget.database.categories).insert(
                CategoriesCompanion.insert(name: nameStr),
                mode: drift.InsertMode.insertOrReplace,
              );
            }
          }
        }
      }

      if (exList != null) {
        for (var ex in exList) {
          if (ex is Map) {
            final name = ex['name']?.toString() ?? ex['title']?.toString() ?? 'Sem Nome';
            final category = ex['category']?.toString() ?? ex['muscle_group']?.toString() ?? 'Peito';

            await widget.database.into(widget.database.categories).insert(
              CategoriesCompanion.insert(name: category),
              mode: drift.InsertMode.insertOrReplace,
            );

            final bool isDef = forceDefault || (ex['isDefault'] == true) || (ex['is_default'] == true);
            await widget.database.into(widget.database.exercises).insert(
              ExercisesCompanion.insert(
                name: name,
                category: category,
                biomechanicalNote: drift.Value(ex['biomechanicalNote']?.toString() ?? ex['note']?.toString()),
                imagePath: drift.Value(ex['imagePath']?.toString() ?? ex['image']?.toString()),
                gifPath: drift.Value(ex['gifPath']?.toString() ?? ex['gif_url']?.toString()),
                isDefault: drift.Value(isDef),
              ),
              mode: drift.InsertMode.insertOrReplace,
            );
          }
        }
      }
    });

    await _loadData();
  }

  void _showExerciseDetailDialog(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        title: Text(exercise.name, style: const TextStyle(color: AppTheme.goldPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (exercise.gifPath != null && exercise.gifPath!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/${exercise.gifPath}',
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'Animação GIF indisponível nos assets.',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
                )
              else
                const Text('Sem animação disponível para este exercício.', style: TextStyle(color: AppTheme.textMuted)),
              const SizedBox(height: 16),
              Text(
                exercise.biomechanicalNote ?? 'Sem notas biomecânicas registadas.',
                style: const TextStyle(color: AppTheme.textWhite, fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: AppTheme.goldPrimary)),
          ),
        ],
      ),
    );
  }

  void _showImageSelectorDialog(StateSetter parentSetState) async {
    final allExs = await widget.database.select(widget.database.exercises).get();
    final Map<String, String> uniqueImages = {};
    for (var ex in allExs) {
      if (ex.imagePath != null && ex.imagePath!.isNotEmpty) {
        uniqueImages[ex.imagePath!] = ex.gifPath ?? '';
      }
    }

    final imageList = uniqueImages.entries.toList();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        title: const Text('Selecionar Miniatura do Catálogo', style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          height: 400,
          child: imageList.isEmpty
              ? const Center(child: Text('Nenhuma imagem disponível. Importe o catálogo primeiro.', style: TextStyle(color: AppTheme.textMuted)))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    final imgPath = imageList[index].key;
                    final gifPath = imageList[index].value;
                    return GestureDetector(
                      onTap: () {
                        parentSetState(() {
                          _selectedImagePath = imgPath;
                          _selectedGifPath = gifPath;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black26,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/$imgPath',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, color: AppTheme.goldPrimary),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
          ),
        ],
      ),
    );
  }

  void _showAddExerciseDialog() {
    _nameController.clear();
    _noteController.clear();
    _selectedImagePath = null;
    _selectedGifPath = null;
    if (_categories.isNotEmpty) {
      _selectedCategory = _categories.first.name;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: AppTheme.obsidianSurface,
              title: const Text('Novo Exercício', style: TextStyle(color: AppTheme.goldPrimary)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        labelText: 'Nome do Exercício',
                        labelStyle: TextStyle(color: AppTheme.textMuted),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: AppTheme.obsidianSurface,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        labelText: 'Categoria / Grupo Muscular',
                        labelStyle: TextStyle(color: AppTheme.textMuted),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                      ),
                      items: _categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          _selectedCategory = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        labelText: 'Nota Biomecânica (opcional)',
                        labelStyle: TextStyle(color: AppTheme.textMuted),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.goldPrimary),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black26,
                          ),
                          child: _selectedImagePath != null && _selectedImagePath!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset('assets/$_selectedImagePath', fit: BoxFit.cover),
                                )
                              : const Icon(Icons.image_outlined, color: AppTheme.goldPrimary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.goldPrimary,
                              side: const BorderSide(color: AppTheme.goldPrimary),
                            ),
                            onPressed: () => _showImageSelectorDialog(setStateDialog),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Escolher Miniatura'),
                          ),
                        ),
                      ],
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final note = _noteController.text.trim();

                    if (name.isNotEmpty && _selectedCategory != null) {
                      await widget.database.into(widget.database.exercises).insert(
                            ExercisesCompanion.insert(
                              name: name,
                              category: _selectedCategory!,
                              biomechanicalNote: drift.Value(note.isEmpty ? null : note),
                              imagePath: drift.Value(_selectedImagePath),
                              gifPath: drift.Value(_selectedGifPath),
                              isDefault: const drift.Value(false),
                            ),
                          );

                      if (!mounted) return;
                      Navigator.pop(context);
                      _loadData();
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    _newCategoryController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.obsidianSurface,
          title: const Text('Novo Grupo Muscular', style: TextStyle(color: AppTheme.goldPrimary)),
          content: TextField(
            controller: _newCategoryController,
            style: const TextStyle(color: AppTheme.textWhite),
            decoration: const InputDecoration(
              labelText: 'Nome da Categoria',
              labelStyle: TextStyle(color: AppTheme.textMuted),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
              onPressed: () async {
                final catName = _newCategoryController.text.trim();
                if (catName.isNotEmpty) {
                  try {
                    await widget.database.into(widget.database.categories).insert(
                          CategoriesCompanion.insert(name: catName),
                        );
                  } catch (_) {}
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: const Text('Guardar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExercise(int id) async {
    await (widget.database.delete(widget.database.exercises)
          ..where((t) => t.id.equals(id)))
        .go();
    _loadData();
  }

  Future<void> _deleteCategory(Category category) async {
    final exercisesInCategory = _exercises.where((e) => e.category == category.name).toList();
    if (exercisesInCategory.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A categoria "${category.name}" não está vazia (${exercisesInCategory.length} exercícios).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await (widget.database.delete(widget.database.categories)
          ..where((t) => t.id.equals(category.id)))
        .go();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final preferredOrder = [
      'Peito', 
      'Abdômen e Core', 
      'Ombros (Deltoides)', 
      'Costas (Dorsais)', 
      'Pernas', 
      'Tríceps', 
      'Bíceps', 
      'Trapézios',
      'Antebraços',
      'Panturrilhas'
    ];

    List<Category> sortedCategories = List.from(_categories);
    sortedCategories.sort((a, b) {
      int indexA = preferredOrder.indexOf(a.name);
      int indexB = preferredOrder.indexOf(b.name);
      if (indexA == -1) indexA = 999;
      if (indexB == -1) indexB = 999;
      return indexA.compareTo(indexB);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Exercícios e Grupos Musculares'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_backup_restore_rounded, color: AppTheme.goldPrimary),
            tooltip: 'Insuflar Base Johnson (Assets)',
            onPressed: _importJohnsonDefaultDatabase,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
              tooltip: 'Apagar Tudo e Limpar Base de Dados',
              onPressed: _confirmClearDatabase,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: AppTheme.goldPrimary, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nota: Os exercícios do catálogo padrão Johnson estão protegidos contra eliminação. Novos exercícios criados manualmente podem ser associados a imagens e eliminados livremente.',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.obsidianSurface,
                            foregroundColor: AppTheme.goldPrimary,
                            side: const BorderSide(color: AppTheme.goldPrimary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.upload_file, color: AppTheme.goldPrimary),
                          label: const Text('Exportar JSON', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _exportExercisesToJson,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.goldPrimary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.download, color: Colors.black),
                          label: const Text('Importar Ficheiro', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: _importExercisesFromJsonFile,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                      const SizedBox(width: 12),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Lista de Grupos Musculares', style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: AppTheme.goldPrimary),
                        onPressed: _showAddCategoryDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('NOVA CATEGORIA'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  sortedCategories.isEmpty
                      ? const Center(child: Text('Nenhuma categoria cadastrada.', style: TextStyle(color: AppTheme.textMuted)))
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: sortedCategories.map((cat) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.obsidianSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(cat.name, style: const TextStyle(color: AppTheme.textWhite, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _deleteCategory(cat),
                                    child: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Exercícios por Grupo Muscular', style: TextStyle(color: AppTheme.textWhite, fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
                        onPressed: _showAddExerciseDialog,
                        icon: const Icon(Icons.add, color: Colors.black),
                        label: const Text('NOVO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _exercises.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text('Nenhum exercício cadastrado.', style: TextStyle(color: AppTheme.textMuted)),
                          ),
                        )
                      : Column(
                          children: sortedCategories.map((category) {
                            final allExercisesInCategory = _exercises.where((e) => e.category == category.name).toList();
                            if (allExercisesInCategory.isEmpty) return const SizedBox.shrink();

                            final visibleExercises = allExercisesInCategory.take(7).toList();
                            final hiddenCount = allExercisesInCategory.length - visibleExercises.length;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.obsidianSurface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category.name.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppTheme.goldPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        Text(
                                          '(${visibleExercises.length}/${allExercisesInCategory.length})',
                                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...visibleExercises.map((exercise) {
                                    return GestureDetector(
                                      onTap: () => _showExerciseDetailDialog(exercise),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppTheme.obsidianSurface,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white10),
                                        ),
                                        child: Row(
                                          children: [
                                            if (exercise.imagePath != null && exercise.imagePath!.isNotEmpty)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/${exercise.imagePath}',
                                                  width: 45,
                                                  height: 45,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                                    Icons.fitness_center,
                                                    color: AppTheme.goldPrimary,
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            else
                                              const Icon(
                                                Icons.fitness_center,
                                                color: AppTheme.goldPrimary,
                                                size: 26,
                                              ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    exercise.name,
                                                    style: const TextStyle(
                                                      color: AppTheme.textWhite,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Categoria: ${exercise.category}',
                                                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (!exercise.isDefault)
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                                onPressed: () => _deleteExercise(exercise.id),
                                              )
                                            else
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.lock_outline, color: AppTheme.textMuted, size: 16),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  if (hiddenCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                                      child: Text(
                                        '+ $hiddenCount exercício(s) oculto(s) para otimizar o ecrã.',
                                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}