import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class WeeklyVolumeScreen extends StatefulWidget {
  final AppDatabase database;

  const WeeklyVolumeScreen({super.key, required this.database});

  @override
  State<WeeklyVolumeScreen> createState() => _WeeklyVolumeScreenState();
}

class _VolumeMetrics {
  final Color color;
  final String statusText;
  final double progressRatio;

  _VolumeMetrics({
    required this.color,
    required this.statusText,
    required this.progressRatio,
  });
}

class _WeeklyVolumeScreenState extends State<WeeklyVolumeScreen> {
  bool _isLoading = true;
  Map<String, int> _muscleVolumeMap = {};
  Map<String, Map<String, int>> _scientificThresholds = {};

  final Map<String, Map<String, int>> _referenceThresholds = {
    'Peito': {'mev': 8, 'mavMin': 10, 'mavMax': 16, 'mrv': 20},
    'Costas': {'mev': 10, 'mavMin': 12, 'mavMax': 18, 'mrv': 22},
    'Costas (Dorsais)': {'mev': 10, 'mavMin': 12, 'mavMax': 18, 'mrv': 22},
    'Quadríceps': {'mev': 8, 'mavMin': 10, 'mavMax': 16, 'mrv': 20},
    'Pernas': {'mev': 8, 'mavMin': 12, 'mavMax': 18, 'mrv': 22},
    'Posteriores de Coxa': {'mev': 6, 'mavMin': 8, 'mavMax': 12, 'mrv': 16},
    'Ombros': {'mev': 8, 'mavMin': 12, 'mavMax': 16, 'mrv': 22},
    'Ombros (Deltoides)': {'mev': 8, 'mavMin': 12, 'mavMax': 16, 'mrv': 22},
    'Bíceps': {'mev': 6, 'mavMin': 8, 'mavMax': 14, 'mrv': 18},
    'Tríceps': {'mev': 6, 'mavMin': 8, 'mavMax': 14, 'mrv': 18},
    'Abdómen': {'mev': 6, 'mavMin': 10, 'mavMax': 15, 'mrv': 20},
    'Abdômen e Core': {'mev': 6, 'mavMin': 10, 'mavMax': 15, 'mrv': 20},
    'Panturrilhas': {'mev': 8, 'mavMin': 12, 'mavMax': 16, 'mrv': 20},
    'Trapézios': {'mev': 6, 'mavMin': 8, 'mavMax': 12, 'mrv': 16},
  };

  @override
  void initState() {
    super.initState();
    _calculateWeeklyVolume();
  }

  Future<void> _calculateWeeklyVolume() async {
    try {
      final categories = await widget.database.select(widget.database.categories).get();
      final schedules = await widget.database.select(widget.database.weeklySchedules).get();
      
      final Map<String, Map<String, int>> activeThresholds = {};
      final Map<String, int> volumeMap = {};

      for (var cat in categories) {
        final name = cat.name;
        
        if (name.toLowerCase().contains('descanso') || name.toLowerCase().contains('rest')) {
          continue;
        }

        final threshold = _referenceThresholds.entries.firstWhere(
          (entry) => name.toLowerCase().contains(entry.key.toLowerCase()),
          orElse: () => const MapEntry('Default', {'mev': 6, 'mavMin': 8, 'mavMax': 14, 'mrv': 18}),
        ).value;

        activeThresholds[name] = threshold;
        volumeMap[name] = 0;
      }

      for (var schedule in schedules) {
        final focus = schedule.focusMuscle;
        
        if (focus.toLowerCase().contains('descanso') || focus.toLowerCase().contains('rest')) {
          continue;
        }

        for (var key in volumeMap.keys) {
          if (focus.toLowerCase().contains(key.toLowerCase())) {
            volumeMap[key] = (volumeMap[key] ?? 0) + 12; 
          }
        }
      }

      if (schedules.isEmpty && volumeMap.isNotEmpty) {
        volumeMap.updateAll((key, value) => 12);
      }

      setState(() {
        _scientificThresholds = activeThresholds;
        _muscleVolumeMap = volumeMap;
      });
    } catch (e) {
      debugPrint('Erro ao calcular volume semanal: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _VolumeMetrics _evaluateVolume(int currentSeries, Map<String, int> thresholds) {
    final mev = thresholds['mev'] ?? 8;
    final mavMax = thresholds['mavMax'] ?? 16;
    final mrv = thresholds['mrv'] ?? 20;

    double ratio = currentSeries / (mrv * 1.15);
    if (ratio > 1.0) ratio = 1.0;

    if (currentSeries < mev) {
      return _VolumeMetrics(
        color: Colors.white70,
        statusText: 'Abaixo do MEV (Insuficiente)',
        progressRatio: ratio,
      );
    } else if (currentSeries <= mavMax) {
      return _VolumeMetrics(
        color: Colors.greenAccent,
        statusText: 'Zona Ótima (MAV - Crescimento Máximo)',
        progressRatio: ratio,
      );
    } else if (currentSeries <= mrv) {
      return _VolumeMetrics(
        color: Colors.orangeAccent,
        statusText: 'Volume Alto (Atenção à Recuperação)',
        progressRatio: ratio,
      );
    } else {
      return _VolumeMetrics(
        color: Colors.redAccent,
        statusText: 'Acima do MRV (Risco de Overtraining!)',
        progressRatio: 1.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONTROLE (MAV-MEV-MRV)'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5), width: 1.5),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings_suggest_rounded, color: AppTheme.goldPrimary, size: 26),
                          SizedBox(width: 10),
                          Text(
                            'ECOSSISTEMA DE HIPERTROFIA DE ELITE',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Monitorização em tempo real das séries semanais face aos limites fisiológicos otimizados para hipertrofia máxima. No ecossistema do Gym DonRossi, a resposta direta é: o ideal e mais confortável para alcançar a hipertrofia máxima sustentável é manter-se firmemente na faixa verde (MAV - Volume Máximo Adaptativo).',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: AppTheme.textWhite, fontSize: 12.5, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ANÁLISE POR GRUPO MUSCULAR',
                  style: TextStyle(
                    color: AppTheme.goldPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (_scientificThresholds.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Nenhum grupo muscular registado na base de dados.',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
                  )
                else
                  ..._scientificThresholds.entries.map((entry) {
                    final muscleName = entry.key;
                    final thresholds = entry.value;
                    final currentSeries = _muscleVolumeMap[muscleName] ?? 0;
                    final evaluation = _evaluateVolume(currentSeries, thresholds);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.obsidianSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: evaluation.color.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                muscleName,
                                style: const TextStyle(
                                  color: AppTheme.textWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: evaluation.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: evaluation.color),
                                ),
                                child: Text(
                                  '$currentSeries Séries',
                                  style: TextStyle(
                                    color: evaluation.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: evaluation.progressRatio,
                              backgroundColor: const Color(0xFF2C2C2C),
                              valueColor: AlwaysStoppedAnimation<Color>(evaluation.color),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            evaluation.statusText,
                            style: TextStyle(
                              color: evaluation.color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MEV: ${thresholds['mev']} | MAV: ${thresholds['mavMin']}-${thresholds['mavMax']} | MRV: ${thresholds['mrv']}',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 30),
                const Divider(color: Color(0xFF2C2C2C)),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}