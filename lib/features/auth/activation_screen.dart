import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../main.dart';

class ActivationScreen extends StatefulWidget {
  final AppDatabase database;

  const ActivationScreen({super.key, required this.database});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _savedUserName;

  @override
  void initState() {
    super.initState();
    _checkSavedUser();
  }

  Future<void> _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null && name.isNotEmpty) {
      setState(() {
        _savedUserName = name;
        _nameController.text = name;
      });
    }
  }

  Future<void> _validateAndActivate() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Se já temos um utilizador guardado, fazemos apenas a reentrada direta
      if (_savedUserName != null) {
        await prefs.setBool('is_system_activated', true);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(database: widget.database)),
        );
        return;
      }

      if (name.isEmpty || email.isEmpty || code.isEmpty) {
        setState(() => _errorMessage = 'Por favor, preencha todos os campos obrigatórios.');
        setState(() => _isLoading = false);
        return;
      }

      // Validação normal com o Supabase para ativação inicial
      final response = await Supabase.instance.client
          .from('licencas')
          .select()
          .eq('chave', code)
          .maybeSingle();

      if (response != null) {
        await Supabase.instance.client
            .from('licencas')
            .update({
              'nome': name,
              'email': email,
              'status_ativo': true,
            })
            .eq('chave', code);

        await prefs.setBool('is_system_activated', true);
        await prefs.setString('system_license_code', code);
        await prefs.setString('user_name', name);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(database: widget.database),
          ),
        );
      } else {
        setState(() => _errorMessage = 'Código de ativação inválido.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro de ligação ao servidor: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianSurface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'GYM DONROSSI',
                    style: TextStyle(
                      color: AppTheme.goldPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SISTEMA DE ALTA PERFORMANCE',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 28),
                
                if (_savedUserName != null) ...[
                  const Text(
                    'Acesso ao Sistema',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Clique em Entrar para iniciar',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Seu Nome Completo',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    readOnly: true,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: _inputDecoration(''),
                  ),
                ] else ...[
                  const Text(
                    'Insira os seus dados e o Código de Licença para ativar o sistema:',
                    style: TextStyle(color: AppTheme.textWhite, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: _inputDecoration('Nome Completo / Atleta'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: _inputDecoration('E-mail de Contato'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _codeController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: _inputDecoration('Código de Ativação (ex: VIP-XXXX-XXXX)'),
                  ),
                ],

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _validateAndActivate,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Text(
                          _savedUserName != null ? 'Entrar' : 'ATIVAR SISTEMA',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.goldPrimary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.goldPrimary),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}