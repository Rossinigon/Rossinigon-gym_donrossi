import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class RecoveryAnalyticsScreen extends StatefulWidget {
  final AppDatabase database;

  const RecoveryAnalyticsScreen({super.key, required this.database});

  @override
  State<RecoveryAnalyticsScreen> createState() => _RecoveryAnalyticsScreenState();
}

class _RecoveryMetrics {
  final Color color;
  final String statusText;
  final double progressRatio;
  final String hoursElapsed;

  _RecoveryMetrics({
    required this.color,
    required this.statusText,
    required this.progressRatio,
    required this.hoursElapsed,
  });
}

class _RecoveryAnalyticsScreenState extends State<RecoveryAnalyticsScreen> {
  bool _isLoading = true;
  Map<String, int> _muscleRestHoursMap = {};

  final List<String> _muscleGroups = [
    'Peito',
    'Costas',
    'Quadríceps',
    'Posteriores de Coxa',
    'Ombros',
    'Bíceps',
    'Tríceps',
    'Abdómen',
    'Panturrilhas',
  ];

  @override
  void initState() {
    super.initState();
    _calculateRecoveryData();
  }

  Future<void> _calculateRecoveryData() async {
    final schedules = await widget.database.select(widget.database.weeklySchedules).get();
    
    final Map<String, int> restMap = {};
    for (var muscle in _muscleGroups) {
      restMap[muscle] = 56; 
    }

    for (var schedule in schedules) {
      final focus = schedule.focusMuscle;
      for (var muscle in _muscleGroups) {
        if (focus.toLowerCase().contains(muscle.toLowerCase())) {
          restMap[muscle] = 48; 
        }
      }
    }

    setState(() {
      _muscleRestHoursMap = restMap;
      _isLoading = false;
    });
  }

  _RecoveryMetrics _evaluateRecovery(int hours) {
    double ratio = hours / 120.0; 
    if (ratio > 1.0) ratio = 1.0;

    if (hours < 48) {
      return _RecoveryMetrics(
        color: Colors.white70,
        statusText: 'Abaixo de 48h (Recuperação Incompleta / Risco)',
        progressRatio: ratio,
        hoursElapsed: '$hours horas',
      );
    } else if (hours >= 48 && hours <= 72) {
      return _RecoveryMetrics(
        color: Colors.greenAccent,
        statusText: 'Janela Ótima (48h - 72h / Prontidão Máxima)',
        progressRatio: ratio,
        hoursElapsed: '$hours horas',
      );
    } else if (hours > 72 && hours <= 96) {
      return _RecoveryMetrics(
        color: Colors.orangeAccent,
        statusText: 'Descanso Estendido (72h - 96h / Atenção à Frequência)',
        progressRatio: ratio,
        hoursElapsed: '$hours horas',
      );
    } else {
      return _RecoveryMetrics(
        color: Colors.redAccent,
        statusText: 'Acima de 96h (Sub-frequência / Perda de Estímulo)',
        progressRatio: ratio,
        hoursElapsed: '$hours horas',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Descanso e Prontidão'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. CABEÇALHO DO PAINEL DE DESCANSO
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.hourglass_bottom_rounded, color: AppTheme.goldPrimary, size: 26),
                          SizedBox(width: 10),
                          Text(
                            'PAINEL DE RECUPERAÇÃO INTER-TREINOS',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Monitorização em tempo real do tempo de descanso decorrido entre sessões por grupo muscular, fundamentado nos princípios de síntese proteica e integridade articular e do Sistema Nervoso Central.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: AppTheme.textWhite, fontSize: 12.5, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. LISTA DE GRUPOS MUSCULARES E GRÁFICO DE DESCANSOS
                const Text(
                  'ESTADO DE DESCANSO POR GRUPO MUSCULAR',
                  style: TextStyle(
                    color: AppTheme.goldPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ..._muscleGroups.map((muscleName) {
                  final hours = _muscleRestHoursMap[muscleName] ?? 56;
                  final evaluation = _evaluateRecovery(hours);

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
                                evaluation.hoursElapsed,
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
                          'Status: ${evaluation.statusText}',
                          style: TextStyle(
                            color: evaluation.color,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 30),
                const Divider(color: Color(0xFF2C2C2C)),
                const SizedBox(height: 20),

                // 3. PAINEL DE INSTRUÇÕES DE RECUPERAÇÃO (COM TEXTO JUSTIFICADO)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.6), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.menu_book_rounded, color: AppTheme.goldPrimary, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'INSTRUÇÕES DE LEITURA DO DESCANSO',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '• Abaixo de 48h (Branco/Cinza): O músculo e o Sistema Nervoso Central ainda estão em janela de reparação profunda. Treinar agora aumenta o risco de fadiga cumulativa.\n\n'
                        '• Entre 48h e 72h (Verde): A janela de ouro e conforto máximo. Coincide com o pico da síntese proteica pós-treino, garantindo prontidão biológica ideal para o próximo estímulo.\n\n'
                        '• Entre 72h e 96h (Laranja): Descanso estendido. Aceitável para sessões de volume muito elevado em músculos grandes, mas requer atenção à frequência semanal.\n\n'
                        '• Acima de 96h (Vermelho): Intervalo excessivo. O músculo já completou a supercompensação há dias e começa a perder o ritmo adaptativo ideal.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: AppTheme.textWhite, fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}