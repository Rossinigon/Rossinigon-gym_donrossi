import 'dart:io';
import 'dart:ui'; // Necessário para SystemNavigator se não estiver a usar MaterialApp direto
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importante para SystemNavigator
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../auth/activation_screen.dart';

class SettingsScreen extends StatefulWidget {
 final AppDatabase database;
 const SettingsScreen({super.key, required this.database});

 @override
 State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
 final TextEditingController _nameController = TextEditingController();
 bool _isLoading = true;

 @override
 void initState() {
 super.initState();
 _loadCurrentName();
 }

 Future<void> _loadCurrentName() async {
 final name = await widget.database.getUserName();
 setState(() {
 _nameController.text = name;
 _isLoading = false;
 });
 }

 Future<void> _saveName() async {
 final newName = _nameController.text.trim();
 if (newName.isEmpty) return;

 await widget.database.updateUserName(newName);

 final prefs = await SharedPreferences.getInstance();
 await prefs.setString('user_name', newName);

 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: AppTheme.goldPrimary),
 );
 Navigator.pop(context, true);
 }

 void _showAboutSystemDialog(BuildContext context) {
 showDialog(
 context: context,
 builder: (context) => AlertDialog(
 backgroundColor: AppTheme.obsidianSurface,
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(16),
 side: BorderSide(color: AppTheme.goldPrimary.withOpacity(0.5)),
 ),
 title: const Row(
 children: [
 Icon(Icons.workspace_premium_rounded, color: AppTheme.goldPrimary, size: 24),
 SizedBox(width: 10),
 Text(
 'GYM DONROSSI | ELITE',
 style: TextStyle(
 color: AppTheme.goldPrimary,
 fontSize: 16,
 fontWeight: FontWeight.bold,
 letterSpacing: 1.2,
 ),
 ),
 ],
 ),
 content: const SizedBox(
 width: 420,
 child: SingleChildScrollView(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 mainAxisSize: MainAxisSize.min,
 children: [
 Text(
 'A Visão de um Mestre do Fisiculturismo',
 style: TextStyle(color: AppTheme.goldPrimary, fontSize: 13.5, fontWeight: FontWeight.bold),
 ),
 SizedBox(height: 6),
 Text(
 'Desenvolvido por Rossini Gonçalves — brasileiro a residir em Portugal, com uma extraordinária trajetória de 41 anos dedicados aos ginásios e à hipertrofia máxima.\n\n'
 'Apaixonado pela musculação desde os 14 anos, construiu uma carreira sólida baseada na disciplina, na ciência do treino e na busca incessante pela evolução física. Hoje, aos 55 anos, continua a treinar pesado todas as semanas, unindo a sabedoria de pai e avô à garra de um marombeiro nato.\n\n'
 'Especialista em força e hipertrofia, Rossini criou este ecossistema para partilhar décadas de experiência prática, provando que a musculação é uma jornada transformadora para qualquer idade.',
 style: TextStyle(color: AppTheme.textWhite, fontSize: 12.5, height: 1.4),
 ),
 SizedBox(height: 16),
 Text(
 'O Ecossistema Gym DonRossi',
 style: TextStyle(color: AppTheme.goldPrimary, fontSize: 13.5, fontWeight: FontWeight.bold),
 ),
 SizedBox(height: 6),
 Text(
 'Esqueça o "achismo". O Gym DonRossi é o seu assistente biomecânico de elite, projetado para maximizar os seus ganhos com total precisão e segurança:\n\n'
 '• Controlo Científico de Volume (MEV, MAV, MRV): Monitorização em tempo real das séries semanais para garantir a zona ótima de crescimento sem overtraining.\n\n'
 '• Gestão Inteligente: Organização avançada de exercícios por grupos musculares, notas biomecânicas personalizadas e planeamento semanal estruturado.\n\n'
 '• Privacidade e Soberania de Dados: Arquitetura local segura e privada no seu dispositivo, garantindo total portabilidade e controlo total (RGPD).',
 style: TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.4),
 ),
 ],
 ),
 ),
 ),
 actions: [
 ElevatedButton(
 style: ElevatedButton.styleFrom(
 backgroundColor: AppTheme.goldPrimary,
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
 ),
 onPressed: () => Navigator.pop(context),
 child: const Text(
 'FECHAR',
 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
 ),
 ),
 ],
 ),
 );
 }

 Future<void> _logout() async {
 final prefs = await SharedPreferences.getInstance();
 await prefs.setBool('is_system_activated', false);

 if (!mounted) return;
 
 Navigator.pushAndRemoveUntil(
 context,
 MaterialPageRoute(
 builder: (context) => ActivationScreen(database: widget.database),
 ),
 (route) => false,
 );
 }

 Future<void> _exportDatabase() async {
 try {
 final dbFolder = await getApplicationDocumentsDirectory();
 final file = File('${dbFolder.path}/gym_donrossi.sqlite');

 if (!await file.exists()) {
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Ficheiro de base de dados não encontrado.'), backgroundColor: Colors.redAccent),
 );
 return;
 }

 final bytes = await file.readAsBytes();
 
 final outputFile = await FilePicker.saveFile(
 dialogTitle: 'Escolha a pasta para guardar a Base de Dados',
 fileName: 'gym_donrossi_backup_${DateTime.now().millisecondsSinceEpoch}.sqlite',
 bytes: bytes,
 );

 if (!mounted) return;

 if (outputFile != null) {
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(
 content: Text('Base de dados guardada com sucesso!'),
 backgroundColor: Colors.green,
 ),
 );
 } else {
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Exportação cancelada.'), backgroundColor: Colors.orangeAccent),
 );
 }
 } catch (e) {
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('Erro ao exportar base de dados: $e'), backgroundColor: Colors.redAccent),
 );
 }
 }

 void _confirmDeleteAllData() {
 showDialog(
 context: context,
 builder: (context) => AlertDialog(
 backgroundColor: AppTheme.obsidianSurface,
 title: const Text('⚠️ Destruir Todos os Dados', style: TextStyle(color: Colors.redAccent)),
 content: const Text(
 'Tem a certeza absoluta? Esta ação elimina permanentemente todos os registos de treinos, suplementos e dados do dispositivo (Direito ao Esquecimento - RGPD).\n\nA aplicação será reiniciada.',
 style: TextStyle(color: AppTheme.textWhite, fontSize: 13, height: 1.4),
 ),
 actions: [
 TextButton(
 onPressed: () => Navigator.pop(context),
 child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
 ),
 ElevatedButton(
 style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
 onPressed: () async {
 Navigator.pop(context);
 await _executeCompleteWipe();
 },
 child: const Text('Sim, Apagar Tudo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
 ),
 ],
 ),
 );
 }

 Future<void> _executeCompleteWipe() async {
 try {
 await widget.database.delete(widget.database.workoutLogs).go();
 await widget.database.delete(widget.database.exercises).go();
 await widget.database.delete(widget.database.weeklySchedules).go();
 await widget.database.delete(widget.database.scheduledExercises).go();
 await widget.database.delete(widget.database.supplements).go();
 await widget.database.delete(widget.database.scheduledSupplements).go();
 await widget.database.delete(widget.database.userProfiles).go();
 await widget.database.delete(widget.database.categories).go();

 final prefs = await SharedPreferences.getInstance();
 await prefs.clear();

 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Todos os dados locais foram destruídos com sucesso.'), backgroundColor: Colors.redAccent),
 );

 Navigator.pop(context, true);
 } catch (e) {
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('Erro ao apagar dados: $e'), backgroundColor: Colors.redAccent),
 );
 }
 }

 // --- MÉTODO DE IMPORTAÇÃO CORRIGIDO E ROBUSTO ---
 Future<void> _importDatabase() async {
 try {
 final result = await FilePicker.pickFiles(
 dialogTitle: 'Selecione o backup da base de dados',
 type: FileType.custom,
 allowedExtensions: ['sqlite', 'db'],
 );

 if (result == null || result.isEmpty) return;

 final pickedFile = result.single;
 final filePath = pickedFile.path;
 
 if (filePath == null) {
 throw Exception('Caminho do ficheiro não disponível.');
 }

 // Leitura garantida pelo path, ignorando possíveis bugs do .bytes no Windows
 final fileBytes = await File(filePath).readAsBytes();

 if (fileBytes.isEmpty) {
 throw Exception('Ficheiro vazio.');
 }

 // Validação do cabeçalho SQLite
 const sqliteHeader = [0x53, 0x51, 0x4c, 0x69, 0x74, 0x65, 0x20, 0x66];
 if (fileBytes.length < 16) {
 throw Exception('O ficheiro selecionado não é uma base de dados válida.');
 }
 for (var i = 0; i < sqliteHeader.length; i++) {
 if (fileBytes[i] != sqliteHeader[i]) {
 throw Exception('O ficheiro selecionado não parece ser um backup SQLite válido.');
 }
 }

 if (!mounted) return;

 final confirmed = await showDialog<bool>(
 context: context,
 builder: (dialogContext) => AlertDialog(
 backgroundColor: AppTheme.obsidianSurface,
 title: const Text(
 'Importar base de dados?',
 style: TextStyle(color: AppTheme.goldPrimary),
 ),
 content: const Text(
 'A importação irá substituir a base de dados atual pelos dados do backup selecionado. '
 'Os dados atuais serão perdidos. A app vai reiniciar.',
 style: TextStyle(color: AppTheme.textWhite, height: 1.4),
 ),
 actions: [
 TextButton(
 onPressed: () => Navigator.pop(dialogContext, false),
 child: const Text('Cancelar', style: TextStyle(color: AppTheme.textMuted)),
 ),
 ElevatedButton(
 style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
 onPressed: () => Navigator.pop(dialogContext, true),
 child: const Text(
 'IMPORTAR',
 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
 ),
 ),
 ],
 ),
 );

 if (confirmed != true || !mounted) return;

 final appDirectory = await getApplicationDocumentsDirectory();
 final databaseFile = File('${appDirectory.path}/gym_donrossi.sqlite');
 final temporaryFile = File('${appDirectory.path}/gym_donrossi_import_tmp.sqlite');

 // Grava primeiro num ficheiro temporário
 await temporaryFile.writeAsBytes(fileBytes, flush: true);
 if (!await temporaryFile.exists() || await temporaryFile.length() != fileBytes.length) {
 if (await temporaryFile.exists()) await temporaryFile.delete();
 throw Exception('Não foi possível preparar o ficheiro de importação.');
 }

 // Fecha a base de dados atual ANTES de substituir o ficheiro físico
 await widget.database.close();

 // Substituição segura
 if (await databaseFile.exists()) {
 await databaseFile.delete();
 }
 await temporaryFile.rename(databaseFile.path);

 if (!mounted) return;

 // Mostra diálogo de sucesso e REINICIA a aplicação
 await showDialog<void>(
 context: context,
 barrierDismissible: false,
 builder: (dialogContext) => AlertDialog(
 backgroundColor: AppTheme.obsidianSurface,
 title: const Text(
 'Sucesso!',
 style: TextStyle(color: AppTheme.goldPrimary),
 ),
 content: const Text(
 'Base de dados importada. A aplicação vai fechar agora para carregar os novos dados.',
 style: TextStyle(color: AppTheme.textWhite, height: 1.4),
 ),
 actions: [
 ElevatedButton(
 style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
 onPressed: () async {
 // Fecha o diálogo e depois mata o processo
 Navigator.of(dialogContext).pop();
 // Força o reinício completo para evitar loops de estado
 await SystemNavigator.pop();
 },
 child: const Text(
 'REINICIAR',
 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
 ),
 ),
 ],
 ),
 );
 } catch (e) {
 if (!mounted) return;
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Erro ao importar base de dados: $e'),
 backgroundColor: Colors.redAccent,
 duration: const Duration(seconds: 5),
 ),
 );
 }
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 title: const Text('Definições e Transparência'),
 centerTitle: true,
 actions: [
 IconButton(
 icon: const Icon(Icons.info_outline_rounded, color: AppTheme.goldPrimary),
 tooltip: 'Sobre',
 onPressed: () => _showAboutSystemDialog(context),
 ),
 ],
 ),
 body: _isLoading
 ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
 : ListView(
 padding: const EdgeInsets.all(24.0),
 children: [
 const Text(
 'Identificação do Atleta',
 style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
 ),
 const SizedBox(height: 16),
 TextField(
 controller: _nameController,
 style: const TextStyle(color: AppTheme.textWhite),
 decoration: const InputDecoration(
 labelText: 'Nome',
 labelStyle: TextStyle(color: AppTheme.textMuted),
 enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
 focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
 ),
 ),
 const SizedBox(height: 16),
 ElevatedButton(
 style: ElevatedButton.styleFrom(
 backgroundColor: AppTheme.goldPrimary,
 padding: const EdgeInsets.symmetric(vertical: 16),
 ),
 onPressed: _saveName,
 child: const Text(
 'GUARDAR ALTERAÇÕES',
 style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
 ),
 ),
 const SizedBox(height: 16),
 OutlinedButton.icon(
 style: OutlinedButton.styleFrom(
 side: BorderSide(color: Colors.redAccent.withOpacity(0.6)),
 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
 alignment: Alignment.centerLeft,
 ),
 icon: const Icon(Icons.logout, color: Colors.redAccent),
 label: const Text(
 'SAIR DA CONTA',
 style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
 ),
 onPressed: _logout,
 ),
 const SizedBox(height: 32),
 const Divider(color: Color(0xFF2C2C2C)),
 const SizedBox(height: 16),
 const Text(
 '⚖️ Centro de transparência e gestão de dados',
 style: TextStyle(color: AppTheme.goldPrimary, fontSize: 16, fontWeight: FontWeight.bold),
 ),
 const SizedBox(height: 8),
 const Text(
 'Em conformidade com o RGPD, gere abaixo os seus dados locais.',
 style: TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.4),
 ),
 const SizedBox(height: 20),
 
 // Botão de Exportação
 OutlinedButton.icon(
 style: OutlinedButton.styleFrom(
 side: const BorderSide(color: AppTheme.goldPrimary),
 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
 alignment: Alignment.centerLeft,
 ),
 icon: const Icon(Icons.download_rounded, color: AppTheme.goldPrimary),
 label: const Text(
 'Exportar Base de Dados (Portabilidade)',
 style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 13),
 ),
 onPressed: _exportDatabase,
 ),
 const SizedBox(height: 12),
 
 // Botão de Importação
 OutlinedButton.icon(
 style: OutlinedButton.styleFrom(
 side: const BorderSide(color: AppTheme.goldPrimary),
 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
 alignment: Alignment.centerLeft,
 ),
 icon: const Icon(Icons.upload_file_rounded, color: AppTheme.goldPrimary),
 label: const Text(
 'Importar Base de Dados',
 style: TextStyle(color: AppTheme.goldPrimary, fontWeight: FontWeight.bold, fontSize: 13),
 ),
 onPressed: _importDatabase,
 ),
 
 const SizedBox(height: 12),
 OutlinedButton.icon(
 style: OutlinedButton.styleFrom(
 side: const BorderSide(color: Colors.redAccent),
 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
 alignment: Alignment.centerLeft,
 ),
 icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
 label: const Text(
 'Destruir Todos os Dados Locais (Direito ao Esquecimento)',
 style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
 ),
 onPressed: _confirmDeleteAllData,
 ),
 const SizedBox(height: 24),
 Container(
 padding: const EdgeInsets.all(16),
 decoration: BoxDecoration(
 color: AppTheme.obsidianSurface,
 borderRadius: BorderRadius.circular(12),
 border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.3)),
 ),
 child: const Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 'Resolução Alternativa de Litígios (RAL)',
 style: TextStyle(color: AppTheme.goldPrimary, fontSize: 13, fontWeight: FontWeight.bold),
 ),
 SizedBox(height: 8),
 Text(
 'Em caso de litígio de consumo em Portugal, o utilizador pode recorrer ao Centro de Arbitragem de Conflitos de Consumo de Lisboa (CACCL) ou utilizar a Plataforma Europeia de Resolução de Litígios em Linha (RLL).',
 style: TextStyle(color: AppTheme.textWhite, fontSize: 11.5, height: 1.4),
 ),
 ],
 ),
 ),
 ],
 ),
 );
 }
}