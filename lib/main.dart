import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/database/app_database.dart';
import 'features/workout/weekly_schedule_screen.dart';
import 'features/workout/weekly_volume_screen.dart';
import 'features/workout/recovery_analytics_screen.dart';
import 'features/workout/exercise_management_screen.dart';
import 'features/workout/active_workout_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/supplements/supplements_screen.dart';
import 'features/supplements/supplement_management_screen.dart';
import 'features/dashboard/user_metrics_screen.dart';
import 'features/dashboard/body_measurements_screen.dart';
import 'features/legalidade/protecao_dados.dart';
import 'features/legalidade/legal_notice_screen.dart';
import 'features/auth/activation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZAÇÃO DO SUPABASE COM O SEU PROJETO E CHAVE REAL
  await Supabase.initialize(
    url: 'https://ikpinhxxznvnkqarfygj.supabase.co',
    anonKey: 'sb_publishable_JRLc75Tj1oflQsthVhsiyg_SjUXr3W2',
  );

  final database = AppDatabase();

  // Verifica se o sistema já foi ativado por código localmente
  final prefs = await SharedPreferences.getInstance();
  final bool isActivated = prefs.getBool('is_system_activated') ?? false;

  runApp(GymDonrossiApp(database: database, isActivated: isActivated));
}

class GymDonrossiApp extends StatelessWidget {
  final AppDatabase database;
  final bool isActivated;

  const GymDonrossiApp({super.key, required this.database, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM Donrossi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: isActivated ? HomeScreen(database: database) : ActivationScreen(database: database),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final AppDatabase database;

  const HomeScreen({super.key, required this.database});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Rossini';

  @override
  void initState() {
    super.initState();
    _initializeConsentState();
  }

  Future<void> _initializeConsentState() async {
    await _loadUserName();
    await _checkFirstRunConsent();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        _userName = savedName;
      });
    } else {
      final name = await widget.database.getUserName();
      setState(() {
        _userName = name;
      });
    }
  }

  Future<void> _checkFirstRunConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAccepted = prefs.getBool('has_accepted_consent') ?? false;

    if (!hasAccepted && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ConsentDialog(),
        );
      });
    }
  }

  String _getCurrentDayOfWeek() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 'Segunda-feira';
      case DateTime.tuesday:
        return 'Terça-feira';
      case DateTime.wednesday:
        return 'Quarta-feira';
      case DateTime.thursday:
        return 'Quinta-feira';
      case DateTime.friday:
        return 'Sexta-feira';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return 'Segunda-feira';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GYM Donrossi | Hipertrofia de Elite'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.goldPrimary),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(database: widget.database),
                ),
              );
              if (updated == true) {
                _loadUserName();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_donrossi.gif', // Retornado para o GIF animado original
                height: 130,
                width: 130,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bem-vindo, $_userName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ciência, Precisão Biomecânica e Sobrecarga Progressiva',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            // 1. Iniciar Treino
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final currentDay = _getCurrentDayOfWeek();
                final schedule = await (widget.database.select(widget.database.weeklySchedules)
                    ..where((t) => t.dayOfWeek.equals(currentDay)))
                    .getSingleOrNull();

                final focusMuscle = schedule?.focusMuscle ?? 'Hipertrofia Geral';

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveWorkoutScreen(
                      database: widget.database,
                      dayOfWeek: currentDay,
                      focusMuscle: focusMuscle,
                    ),
                  ),
                );
              },
              child: const Text(
                'INICIAR TREINO',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Planeamento Semanal de Treino
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeeklyScheduleScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'PLANEJAMENTO SEMANAL DE TREINO',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Gerir / Criar Exercícios
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseManagementScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'GESTOR DE EXERCÍCIOS',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Planeamento de Suplementação
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupplementsScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'PLANEJAMENTO DE SUPLEMENTAÇÃO',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Gestor de Suplementos
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupplementManagementScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'GESTOR DE SUPLEMENTOS',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // 6. Dashboard de Métricas do Atleta
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMetricsScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'DASHBOARD DE MÉTRICAS DO ATLETA',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // 7. Registo de Antropometria e Perímetros
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BodyMeasurementsScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'REGISTO DE ANTROPOMETRIA E PERÍMETROS',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // 8. Ver Volume Semanal (MAV-MEV-MRV)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeeklyVolumeScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'VER VOLUME SEMANAL (MAV-MEV-MRV)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // 9. Gestão de Descanso e Prontidão
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecoveryAnalyticsScreen(database: widget.database),
                  ),
                );
              },
              child: const Text(
                'GESTÃO DE DESCANSO E PRONTIDÃO',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // 10. Direitos Autorais e Aviso Legal
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegalNoticeScreen(),
                  ),
                );
              },
              child: const Text(
                'DIREITOS AUTORAIS E AVISO LEGAL DE RESPONSABILIDADE',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
            const SizedBox(height: 16),

            // 11. Política de Proteção de Dados (RGPD)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProtecaoDadosScreen(),
                  ),
                );
              },
              child: const Text(
                'POLÍTICA DE PROTEÇÃO DE DADOS (RGPD)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- POP-UP DE CONSENTIMENTO JURÍDICO ---
class ConsentDialog extends StatefulWidget {
  const ConsentDialog({super.key});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _acceptedTerms = false;
  bool _acceptedHealth = false;

  bool get _canProceed => _acceptedTerms && _acceptedHealth;

  Future<void> _acceptConsent(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_accepted_consent', true);
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        title: const Text(
          '⚖️ TERMOS, RGPD E RESOLUÇÃO DE LITÍGIOS',
          style: TextStyle(
            color: AppTheme.goldPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 650,
          height: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ENQUADRAMENTO LEGAL E FORO (LEI N.º 144/2015):\n\n'
                  'Em caso de litígio, aplica-se a Lei Portuguesa, com jurisdição exclusiva nos tribunais da comarca da sede fiscal. O utilizador pode recorrer a entidades de Resolução Alternativa de Litígios de Consumo (RAL), como o CACCL (Centro de Arbitragem de Conflitos de Consumo de Lisboa) ou à Plataforma Europeia de Resolução de Litígios em Linha (RLL).\n\n'
                  '1. PROTEÇÃO DE DADOS E ARQUITETURA LOCAL:\n'
                  'Os dados são armazenados exclusivamente no dispositivo via SQLite/Drift. Pode exercer o Direito à Portabilidade ou o Direito ao Esquecimento a qualquer momento nas Definições.\n\n'
                  '2. ISENÇÃO DE RESPONSABILIDADE MÉDICA E ANTIDOPING:\n'
                  'O software não substitui profissionais de saúde e condena o uso de substâncias proibidas pela WADA/ASAE.',
                  style: TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProtecaoDadosScreen()),
                        );
                      },
                      icon: const Icon(Icons.privacy_tip_outlined, size: 16, color: AppTheme.goldPrimary),
                      label: const Text('Ler RGPD Completo', style: TextStyle(color: AppTheme.goldPrimary, fontSize: 11)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LegalNoticeScreen()),
                        );
                      },
                      icon: const Icon(Icons.description_outlined, size: 16, color: AppTheme.goldPrimary),
                      label: const Text('Ler Termos Legais', style: TextStyle(color: AppTheme.goldPrimary, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _acceptedTerms,
                  activeColor: AppTheme.goldPrimary,
                  checkColor: Colors.black,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Li e aceito os Termos de Utilização e a Política de Privacidade Local (RGPD).',
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 11),
                  ),
                  onChanged: (val) => setState(() => _acceptedTerms = val ?? false),
                ),
                CheckboxListTile(
                  value: _acceptedHealth,
                  activeColor: AppTheme.goldPrimary,
                  checkColor: Colors.black,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Compreendo que o Gym DonRossi não substitui médicos ou nutricionistas e que sou o único responsável pelas minhas dosagens.',
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 11),
                  ),
                  onChanged: (val) => setState(() => _acceptedHealth = val ?? false),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _canProceed ? AppTheme.goldPrimary : Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: _canProceed ? () => _acceptConsent(context) : null,
              child: const Text(
                'COMEÇAR A TREINAR',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}