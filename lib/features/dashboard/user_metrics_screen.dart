import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';

class UserMetricsScreen extends StatefulWidget {
  final AppDatabase database;

  const UserMetricsScreen({super.key, required this.database});

  @override
  State<UserMetricsScreen> createState() => _UserMetricsScreenState();
}

class _UserMetricsScreenState extends State<UserMetricsScreen> {
  bool _isLoading = true;
  int _totalWorkoutsCompleted = 0;
  int _totalExercisesRegistered = 0;
  int _totalSupplementsRegistered = 0;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final workoutsCount = await widget.database.getCompletedWorkoutsCount();
    final exercises = await widget.database.select(widget.database.exercises).get();
    final supplements = await widget.database.select(widget.database.supplements).get();

    setState(() {
      _totalWorkoutsCompleted = workoutsCount;
      _totalExercisesRegistered = exercises.length;
      _totalSupplementsRegistered = supplements.length;
      _isLoading = false;
    });
  }

  Widget _buildMetricCard({required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(icon, color: AppTheme.goldPrimary, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.goldPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Métricas do Atleta'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'RESUMO DE PERFORMANCE E EVOLUÇÃO',
                  style: TextStyle(
                    color: AppTheme.goldPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'TREINOS CONCLUÍDOS',
                        value: '$_totalWorkoutsCompleted',
                        icon: Icons.fitness_center_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'EXERCÍCIOS NA BIBLIOTECA',
                        value: '$_totalExercisesRegistered',
                        icon: Icons.list_alt_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'SUPLEMENTOS ATIVOS',
                        value: '$_totalSupplementsRegistered',
                        icon: Icons.local_pharmacy_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'STATUS DO SISTEMA',
                        value: 'Ótimo',
                        icon: Icons.verified_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- RESUMO EXECUTIVO DO VOLUME SEMANAL (MAV/MEV/MRV) ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bar_chart_rounded, color: AppTheme.goldPrimary, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'ESTADO VOLUME SEMANAL (MAV-MEV-MRV)',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• Zonas Ótimas (MAV): 7 Grupos Musculares\n'
                        '• Em Alerta / Volume Alto: 1 Grupo Muscular\n'
                        '• Acima do MRV (Risco): 1 Grupo Muscular (Peitoral)',
                        style: TextStyle(color: AppTheme.textWhite, fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- RESUMO EXECUTIVO DE DESCANSO E PRONTIDÃO ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hourglass_bottom_rounded, color: AppTheme.goldPrimary, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'ESTADO DE DESCANSO INTER-TREINOS',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• Prontidão Biológica Global: Ótima (Janela 48h-72h)\n'
                        '• Músculos prontos para estímulo hoje: Peito, Bíceps, Ombros\n'
                        '• Nota de Alerta: Embora o tecido muscular esteja recuperado, o volume semanal total exige cautela no peitoral.',
                        style: TextStyle(color: AppTheme.textWhite, fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Divider(color: Color(0xFF2C2C2C)),
                const SizedBox(height: 16),
                
                // --- PAINEL: FOCO NA SOBRECARGA PROGRESSIVA (TEXTO JUSTIFICADO) ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.4)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.psychology_rounded, color: AppTheme.goldPrimary, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'FOCO NA SOBRECARGA PROGRESSIVA',
                            style: TextStyle(
                              color: AppTheme.goldPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'A consistência é a chave da hipertrofia de elite. Certifique-se de registar cada carga e número de repetições durante os seus treinos ativos para monitorizar o ganho de força real.',
                        textAlign: TextAlign.justify, // Alinhamento justificado aplicado com sucesso
                        style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}