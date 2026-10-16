import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class VolumeControlScreen extends StatefulWidget {
  final AppDatabase database;

  const VolumeControlScreen({super.key, required this.database});

  @override
  State<VolumeControlScreen> createState() => _VolumeControlScreenState();
}

class _VolumeControlScreenState extends State<VolumeControlScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _volumeData = [];

  @override
  void initState() {
    super.initState();
    _calculateWeeklyVolume();
  }

  Future<void> _calculateWeeklyVolume() async {
    // 1. Obter categorias/grupos musculares cadastrados
    final categories = await widget.database.select(widget.database.categories).get();
    
    // Mapear contagem de séries por categoria de músculo
    Map<String, int> setsPerCategory = {};
    for (var cat in categories) {
      setsPerCategory[cat.name] = 0;
    }

    // Parâmetros científicos padrão (Dr. Mike Israetel) para os grupos musculares
    // Formato: [MEV, MAV_min, MAV_max, MRV]
    final Map<String, List<int>> scientificBenchmarks = {
      'Peito': [8, 10, 15, 22],
      'Costas (Dorsais)': [10, 12, 18, 25],
      'Pernas e Glúcios': [8, 12, 16, 22],
      'Ombros (Deltoides)': [8, 12, 16, 22],
      'Braços': [6, 10, 14, 20],
      'Abdômen e Core': [6, 10, 16, 25],
      'Tríceps': [6, 10, 14, 20],
      'Bíceps': [6, 10, 14, 20],
      'Trapézios': [6, 10, 14, 22],
    };

    List<Map<String, dynamic>> computedList = [];

    for (var cat in categories) {
      int currentSets = (setsPerCategory[cat.name] ?? 0).toInt();
      List<int> benchmarks = scientificBenchmarks[cat.name] ?? [6, 10, 15, 20];

      computedList.add({
        'muscleGroup': cat.name,
        'currentSets': currentSets,
        'mev': benchmarks[0],
        'mravMin': benchmarks[1],
        'mravMax': benchmarks[2],
        'mrv': benchmarks[3],
      });
    }

    setState(() {
      _volumeData = computedList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlo de Volume (MAV / MRV)'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : _volumeData.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum grupo muscular encontrado para calcular volume.',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _volumeData.length,
                  itemBuilder: (context, index) {
                    final data = _volumeData[index];
                    final String muscle = data['muscleGroup'];
                    final int current = (data['currentSets'] as num).toInt();
                    final int mev = (data['mev'] as num).toInt();
                    final int mravMin = (data['mravMin'] as num).toInt();
                    final int mravMax = (data['mravMax'] as num).toInt();
                    final int mrv = (data['mrv'] as num).toInt();

                    Color statusColor;
                    String statusText;

                    if (current < mev) {
                      statusColor = Colors.blueGrey;
                      statusText = 'Abaixo do MEV (Manutenção)';
                    } else if (current >= mravMin && current <= mravMax) {
                      statusColor = AppTheme.goldPrimary; // Zona ideal dourada MAV
                      statusText = 'Zona Ideal (MAV)';
                    } else if (current > mravMax && current <= mrv) {
                      statusColor = Colors.orangeAccent;
                      statusText = 'Volume Elevado (Perto do MRV)';
                    } else if (current > mrv) {
                      statusColor = Colors.redAccent;
                      statusText = 'Excesso / Risco (> MRV)';
                    } else {
                      statusColor = AppTheme.goldPrimary;
                      statusText = 'Ativo';
                    }

                    double progress = (current / mrv).clamp(0.0, 1.0);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.obsidianSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                muscle,
                                style: const TextStyle(
                                  color: AppTheme.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Séries Semanais: $current',
                                style: const TextStyle(color: AppTheme.textWhite, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'MEV: $mev | MAV: $mravMin-$mravMax | MRV: $mrv',
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}