import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LegalNoticeScreen extends StatelessWidget {
  const LegalNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVISO LEGAL E TERMOS'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📜 TERMOS DE UTILIZAÇÃO, DIREITOS AUTORAIS E AVISO LEGAL DE RESPONSABILIDADE',
              style: TextStyle(
                color: AppTheme.goldPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplicação: Gym DonRossi\nÚltima atualização: Outubro de 2026',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'O Gym DonRossi é uma aplicação de gestão de fitness, nutrição e suplementação de alta performance, arquitetada para fornecer autonomia e personalização ao utilizador. Ao utilizar esta plataforma e o seu ecossistema local, o utilizador aceita e vincula-se integralmente aos presentes Termos de Utilização e Avisos Legais.',
              textAlign: TextAlign.justify,
              style: TextStyle(color: AppTheme.textWhite, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('1. PROPRIEDADE INTELECTUAL, DIREITOS AUTORAIS E ARQUITETURA LOCAL'),
            const SizedBox(height: 8),
            _buildParagraph(
              '• Propriedade do Conteúdo: Todos os textos, estruturas de bases de dados, algoritmos de cálculo, design da interface, logótipos e esquemas de categorização estratégica de suplementos (Ganho de Massa, Emagrecimento, Performance, Recuperação, Saúde Geral, Cardiovascular e Sono) são propriedade exclusiva do Gym DonRossi ou dos seus licenciantes, estando protegidos pelo Código do Direito de Autor e dos Direitos Conexos em Portugal e pelas diretrizes de propriedade intelectual da União Europeia.\n\n'
              '• Armazenamento Local e Privacidade (SQLite/Drift): A aplicação utiliza uma arquitetura de base de dados local e privada. O utilizador retém a posse física dos dados inseridos no seu dispositivo. Contudo, a estrutura da base de dados, o código de execução e a organização inteligente das categorias permanecem sob a proteção de direitos de autor do software, sendo proibida qualquer tentativa de engenharia reversa, extração fraudulenta ou replicação do ecossistema.\n\n'
              '• Licença de Utilização: É concedida ao utilizador uma licença estritamente pessoal, revogável, não transmissível e limitada, para a gestão dos seus próprios registos informativos, sendo expressamente proibida a comercialização ou distribuição pública de quaisquer dados estruturados pela aplicação.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('2. ISENÇÃO DE RESPONSABILIDADE SOBRE SUPLEMENTAÇÃO E DOSAGENS'),
            const SizedBox(height: 8),
            _buildParagraph(
              '• Carácter Meramente Informativo e de Gestão: O módulo de Gestor de Suplementos por Categoria atua exclusivamente como uma ferramenta de organização, registo e monitorização pessoal. O software fornece dados informativos e ilustrativos sobre dosagens e horários.\n\n'
              '• Conformidade Normativa em Portugal: O Gym DonRossi não comercializa, não prescreve e não recomenda substâncias. O utilizador é o único responsável por garantir que qualquer suplemento registado na aplicação cumpre as normas da Autoridade de Segurança Alimentar e Económica (ASAE) e da Direção-Geral da Alimentação e Veterinária (DGAV), organismos que regulam a introdução de suplementos alimentares no mercado português.\n\n'
              '• Exclusão de Risco: O utilizador assume total responsabilidade pelas reações adversas, interações medicamentosas, contraindicações ou efeitos secundários resultantes da ingestão de dosagens configuradas na aplicação. O software exime-se de qualquer responsabilidade civil ou criminal por decisões de consumo tomadas de forma autónoma.',
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('3. NOTA OBRIGATÓRIA: DA IMPRESCINDÍVEL CONSULTA PROFISSIONAL EM PORTUGAL'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚠️ AVISO LEGAL E SALVAGUARDA DE SAÚDE PÚBLICA',
                    style: TextStyle(color: AppTheme.goldPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'As ferramentas de gestão de treino, planos de suplementação e rotinas diárias integradas no Gym DonRossi não substituem, em caso algum, o diagnóstico, o aconselhamento e a prescrição personalizada de profissionais de saúde devidamente habilitados e inscritos nas respetivas ordens profissionais em Portugal.\n\n'
                    '• Nutrição, Dietas e Suplementação: A elaboração de planos alimentares, a alteração de regimes dietéticos e a prescrição estratégica de suplementos específicos com fins terapêuticos ou de performance devem ser efetuadas e validadas exclusivamente por um Nutricionista ou Dietista com cédula profissional ativa emitida pela Ordem dos Nutricionistas.\n\n'
                    '• Planeamento de Treino e Exercício Físico: A prescrição, estruturação, periodização e orientação de rotinas de treino e exercício físico de alta performance devem ser validadas por um Técnico de Exercício Físico (TEF) ou Diretor Técnico (DT) devidamente encartado pelo Instituto Português do Desporto e Juventude (IPDJ), nos termos da legislação desportiva em vigor (Lei n.º 39/2012).\n\n'
                    'Nunca ignore ou adie o aconselhamento médico ou nutricional especializado devido a informações armazenadas ou sugeridas por esta aplicação. O Gym DonRossi promove a alta performance consciente e segura através do controlo do próprio utilizador, apoiado sempre pela supervisão de especialistas.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 12.5, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('4. LIMITAÇÃO DE RESPONSABILIDADE JURÍDICA E AMBIENTE OFFLINE'),
            const SizedBox(height: 8),
            _buildParagraph(
              'Dado que o Gym DonRossi opera sobre uma arquitetura local e segura (SQLite/Drift), o controlo absoluto dos dados e a execução offline dependem diretamente da integridade do dispositivo do utilizador. Desta forma, na extensão máxima permitida pela lei portuguesa:\n\n'
              '• A aplicação não se responsabiliza por perdas de dados decorrentes de falhas no sistema operativo do dispositivo, formatações ou ausência de cópias de segurança (backups) por parte do utilizador.\n\n'
              '• Nenhum programador, parceiro ou administrador do Gym DonRossi poderá ser responsabilizado por quaisquer danos à integridade física, lesões desportivas decorrentes da gestão de treino ou problemas de saúde crónicos resultantes do planeamento operacional efetuado na plataforma sem supervisão médica.',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'COMPREENDIDO',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.goldPrimary,
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        color: AppTheme.textWhite,
        fontSize: 12.5,
        height: 1.5,
      ),
    );
  }
}