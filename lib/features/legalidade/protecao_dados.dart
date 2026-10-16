import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProtecaoDadosScreen extends StatelessWidget {
  const ProtecaoDadosScreen({super.key});

  // O Banner Painel que criámos para o topo
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppTheme.obsidianSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security_rounded, color: AppTheme.goldPrimary, size: 28),
              const SizedBox(width: 12),
              Text(
                'CONFORMIDADE COM RGPD',
                style: TextStyle(
                  color: AppTheme.goldPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF2C2C2C), height: 1),
          const SizedBox(height: 12),
          const Text(
            'Proteção de Dados, Privacidade Soberana e Enquadramento Legal em Portugal (Regulamento UE 2016/679)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12.5,
              height: 1.4,
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
        title: const Text('Política de Proteção de Dados (RGPD)'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. O Banner Painel inserido no topo
          _buildHeaderBanner(),
          const SizedBox(height: 24),

          // 2. Conteúdo da Política de Proteção de Dados
          const Text(
            'Enquadramento e Princípios Gerais',
            style: TextStyle(
              color: AppTheme.goldPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'O Gym DonRossi cumpre estritamente o Regulamento Geral sobre a Proteção de Dados (RGPD - Regulamento UE 2016/679) e a legislação nacional aplicável em Portugal.\n\n'
            'Arquitetura de Dados 100% Local: Ao contrário das aplicações tradicionais baseadas na nuvem, o Gym DonRossi armazena todos os seus dados de treino, métricas e suplementação exclusivamente de forma local no seu dispositivo, utilizando uma base de dados SQLite protegida e gerida pelo motor Drift.',
            style: TextStyle(color: AppTheme.textWhite, fontSize: 13, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),

          const Text(
            'Direitos do Titular dos Dados',
            style: TextStyle(
              color: AppTheme.goldPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enquanto utilizador e titular absoluto dos seus dados, dispods de total soberania através das ferramentas integradas nas Definições da aplicação:\n\n'
            '• Direito à Portabilidade: Pode exportar a sua base de dados completa a qualquer momento em formato digital.\n'
            '• Direito ao Esquecimento (Apagamento): Pode destruir de forma irreversível e imediata todos os registos guardados no seu equipamento através da função de limpeza profunda.',
            style: TextStyle(color: AppTheme.textWhite, fontSize: 13, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}