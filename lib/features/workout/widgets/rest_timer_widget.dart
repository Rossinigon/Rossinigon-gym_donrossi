import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerWidget extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback onTimerFinished;

  const RestTimerWidget({
    Key? key,
    required this.initialSeconds,
    required this.onTimerFinished,
  }) : super(key: key);

  @override
  _RestTimerWidgetState createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
        widget.onTimerFinished();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _addTime(int seconds) {
    setState(() {
      _remainingSeconds += seconds;
      if (_remainingSeconds < 0) _remainingSeconds = 0;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cores alinhadas com o padrão visual Dark Obsidian / Gold
    const Color obsidianDark = Color(0xFF121212);
    const Color goldAccent = Color(0xFFFFD700);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: obsidianDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldAccent.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: goldAccent, size: 24),
          const SizedBox(width: 12),
          Text(
            _formatTime(_remainingSeconds),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 16),
          // Botão -10 segundos
          IconButton(
            icon: const Icon(Icons.exposure_minus_1, color: Colors.white70, size: 20),
            onPressed: () => _addTime(-10),
            tooltip: '-10s',
          ),
          // Botão +10 segundos
          IconButton(
            icon: const Icon(Icons.plus_one, color: goldAccent, size: 20),
            onPressed: () => _addTime(10),
            tooltip: '+10s',
          ),
          const SizedBox(width: 8),
          // Botão para fechar / saltar o descanso manualmente
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 22),
            onPressed: widget.onTimerFinished,
            tooltip: 'Saltar Descanso',
          ),
        ],
      ),
    );
  }
}