import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  final AppDatabase database;

  const BodyMeasurementsScreen({super.key, required this.database});

  @override
  State<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _weightController = TextEditingController();
  final _waistController = TextEditingController();
  final _chestController = TextEditingController();
  final _armRelaxedController = TextEditingController();
  final _armFlexedController = TextEditingController();
  final _thighProximalController = TextEditingController();
  final _thighMidController = TextEditingController();
  final _hipController = TextEditingController();
  final _fcrController = TextEditingController();

  bool _isSaving = false;
  int? _editingId; // Se for null, estamos a criar um novo registo. Se tiver ID, estamos a editar.
  List<BodyMeasurement> _measurementsList = [];

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    final list = await (widget.database.select(widget.database.bodyMeasurements)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]))
        .get();
    setState(() {
      _measurementsList = list;
    });
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _weightController.clear();
    _waistController.clear();
    _chestController.clear();
    _armRelaxedController.clear();
    _armFlexedController.clear();
    _thighProximalController.clear();
    _thighMidController.clear();
    _hipController.clear();
    _fcrController.clear();
    setState(() {
      _editingId = null;
    });
  }

  void _loadIntoForm(BodyMeasurement item) {
    setState(() {
      _editingId = item.id;
      _weightController.text = item.weight.toString();
      _waistController.text = item.waist.toString();
      _chestController.text = item.chest.toString();
      _armRelaxedController.text = item.armRelaxed.toString();
      _armFlexedController.text = item.armFlexed.toString();
      _thighProximalController.text = item.thighProximal.toString();
      _thighMidController.text = item.thighMid.toString();
      _hipController.text = item.hip.toString();
      _fcrController.text = item.restingHeartRate.toString();
    });
  }

  Future<void> _saveOrUpdateMeasurements() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        final companion = BodyMeasurementsCompanion(
          date: drift.Value(DateTime.now()),
          weight: drift.Value(double.parse(_weightController.text)),
          waist: drift.Value(double.parse(_waistController.text)),
          chest: drift.Value(double.parse(_chestController.text)),
          armRelaxed: drift.Value(double.parse(_armRelaxedController.text)),
          armFlexed: drift.Value(double.parse(_armFlexedController.text)),
          thighProximal: drift.Value(double.parse(_thighProximalController.text)),
          thighMid: drift.Value(double.parse(_thighMidController.text)),
          hip: drift.Value(double.parse(_hipController.text)),
          restingHeartRate: drift.Value(int.parse(_fcrController.text)),
        );

        if (_editingId == null) {
          // Inserir novo
          await widget.database.into(widget.database.bodyMeasurements).insert(companion);
        } else {
          // Atualizar existente
          await (widget.database.update(widget.database.bodyMeasurements)
                ..where((t) => t.id.equals(_editingId!)))
              .write(companion);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_editingId == null ? 'Registo guardado com sucesso!' : 'Registo atualizado com sucesso!')),
        );

        _clearForm();
        await _loadMeasurements();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteMeasurement(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        title: const Text('Confirmar Exclusão', style: TextStyle(color: AppTheme.goldPrimary)),
        content: const Text('Tem certeza de que deseja eliminar este registo antropométrico?', style: TextStyle(color: AppTheme.textWhite)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );

    if (confirm == true) {
      await (widget.database.delete(widget.database.bodyMeasurements)..where((t) => t.id.equals(id))).go();
      await _loadMeasurements();
      if (_editingId == id) {
        _clearForm();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registo eliminado com sucesso.')),
      );
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} às ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antropometria Corporal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Painel Principal de Inserção / Edição
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.obsidianSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _editingId == null ? 'NOVO REGISTO DE MEDIDAS' : 'EDITAR REGISTO SELECIONADO',
                          style: const TextStyle(color: AppTheme.goldPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (_editingId != null)
                          TextButton.icon(
                            onPressed: _clearForm,
                            icon: const Icon(Icons.close, size: 16, color: Colors.redAccent),
                            label: const Text('Cancelar Edição', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Peso Corporal Total (kg)', _weightController),
                    _buildTextField('Circunferência Abdominal / Cintura (cm)', _waistController),
                    _buildTextField('Circunferência do Tórax / Peitoral (cm)', _chestController),
                    _buildTextField('Braço Relaxado (cm)', _armRelaxedController),
                    _buildTextField('Braço Contraído / Pico (cm)', _armFlexedController),
                    _buildTextField('Coxa Proximal (cm)', _thighProximalController),
                    _buildTextField('Coxa Média (cm)', _thighMidController),
                    _buildTextField('Circunferência de Quadril / Anca (cm)', _hipController),
                    _buildTextField('Frequência Cardíaca de Repouso - FCR (bpm)', _fcrController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.goldPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isSaving ? null : _saveOrUpdateMeasurements,
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              _editingId == null ? 'GUARDAR NOVO REGISTO' : 'ATUALIZAR REGISTO',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Color(0xFF2C2C2C)),
            const SizedBox(height: 10),
            const Text(
              'HISTÓRICO DE REGISTOS GUARDADOS',
              style: TextStyle(color: AppTheme.goldPrimary, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lista de Histórico em Cartões
            _measurementsList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Nenhum registo antropométrico guardado ainda.', style: TextStyle(color: AppTheme.textMuted)),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _measurementsList.length,
                    itemBuilder: (context, index) {
                      final item = _measurementsList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _editingId == item.id ? AppTheme.goldPrimary : AppTheme.goldPrimary.withOpacity(0.2),
                            width: _editingId == item.id ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Data Legível ao Alto do Painel Guardado + Botões de Ação
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, color: AppTheme.goldPrimary, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatDate(item.date),
                                      style: const TextStyle(
                                        color: AppTheme.goldPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Botão de Lápis (Editar)
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded, color: AppTheme.goldPrimary, size: 20),
                                      tooltip: 'Editar Registo',
                                      onPressed: () => _loadIntoForm(item),
                                    ),
                                    // Botão de Lixeira (Excluir)
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                      tooltip: 'Eliminar Registo',
                                      onPressed: () => _deleteMeasurement(item.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(color: Color(0xFF2C2C2C), height: 16),
                            // Dados Principais Exibidos no Cartão
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _buildInfoChip('Peso: ${item.weight} kg'),
                                _buildInfoChip('Cintura: ${item.waist} cm'),
                                _buildInfoChip('Peito: ${item.chest} cm'),
                                _buildInfoChip('Braço (C): ${item.armFlexed} cm'),
                                _buildInfoChip('Coxa (M): ${item.thighMid} cm'),
                                _buildInfoChip('Anca: ${item.hip} cm'),
                                _buildInfoChip('FCR: ${item.restingHeartRate} bpm'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: AppTheme.textWhite),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.goldPrimary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.goldPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || double.tryParse(value) == null) {
            return 'Insira um valor numérico válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Text(
      text,
      style: const TextStyle(color: AppTheme.textWhite, fontSize: 12),
    );
  }
}