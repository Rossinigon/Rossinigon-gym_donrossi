import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class ConsentDialog extends StatefulWidget {
  const ConsentDialog({super.key});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _hasAgreed = false;

  Future<void> _acceptConsent(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_accepted_consent', true);
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Impede fechar sem aceitar
      child: AlertDialog(
        backgroundColor: AppTheme.obsidianSurface,
        title: const Text(
          '📜 TERMO DE CONSENTIMENTO E AVISO LEGAL',
          style: TextStyle(
            color: AppTheme.goldPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 650,
          height: 450,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'CONCORDÂNCIA DE TERMOS E RISCOS – GYM DONROSSI\n\n'
                  'Ao utilizar a aplicação, o utilizador declara explicitamente que:\n\n'
                  '• Compreende que o Gym DonRossi é uma ferramenta tecnológica de autogestão e não um serviço de aconselhamento médico, nutricional ou desportivo profissional.\n'
                  '• Assume a inteira responsabilidade civil e criminal por quaisquer dosagens de suplementos, substâncias ou rotinas de treino que introduza, agende ou consuma utilizando esta plataforma.\n'
                  '• Está ciente de que a aplicação opera de forma 100% offline e local (SQLite/Drift); a perda do dispositivo ou a eliminação da aplicação resultará na perda permanente dos dados, sem possibilidade de recuperação pelos programadores.\n'
                  '• Tem idade igual ou superior a 18 anos (ou idade legal equivalente em Portugal para a prática de ginásios e consumo de suplementação avançada).\n\n'
                  '1. ISENÇÃO DE INCENTIVO AO DOPING:\n'
                  'O Gym DonRossi fornece categorias organizacionais abertas para gestão pessoal. O software não apoia, não incentiva e condena explicitamente o uso de substâncias dopantes, esteroides anabolizantes ilegais ou ergogénicos não aprovados pela ASAE, INFARMED ou WADA. Atletas federados em Portugal são inteiramente responsáveis por cumprir as normas da sua federação e a Lei n.º 112/2019.\n\n'
                  '2. PROTEÇÃO DE DADOS E PROPRIEDADE INTELECTUAL:\n'
                  'A estrutura de base de dados e a arquitetura local estão protegidas pelo Direito Sui Generis de Bases de Dados (Decreto-Lei n.º 122/2000). Qualquer tentativa de engenharia reversa é proibida.\n\n'
                  '3. FALHAS TÉCNICAS DE NOTIFICAÇÕES:\n'
                  'A aplicação depende do sistema operativo para alarmes. Os programadores não assumem responsabilidade por falhas de notificação devidas a poupança de bateria ou restrições do dispositivo.',
                  style: TextStyle(
                    color: AppTheme.textWhite,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _hasAgreed,
                      activeColor: AppTheme.goldPrimary,
                      checkColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _hasAgreed = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Li e aceito integralmente os Termos, Condições e Salvaguardas Legais.',
                        style: TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _hasAgreed ? AppTheme.goldPrimary : Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: _hasAgreed ? () => _acceptConsent(context) : null,
              child: const Text(
                'ACEITAR E CONTINUAR',
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