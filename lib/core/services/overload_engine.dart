class OverloadEngine {
  /// Analisa o desempenho da série anterior e dita a progressão.
  /// [targetMinReps] e [targetMaxReps]: faixa de repetições estipulada (ex: 8 a 12).
  /// [completedReps]: quantas repetições o utilizador realmente fez.
  /// [currentWeight]: peso atual utilizado (kg).
  /// [rpe]: taxa de esforço percebido (ex: 8.0 a 10.0).
  static Map<String, dynamic> calculateProgression({
    required int targetMinReps,
    required int targetMaxReps,
    required int completedReps,
    required double currentWeight,
    required double rpe,
  }) {
    double suggestedWeight = currentWeight;
    String recommendation = '';

    // Se atingiu o teto da faixa de repetições com boa execução (RPE controlado)
    if (completedReps >= targetMaxReps && rpe <= 9.5) {
      // Regra de progressão: Aumentar carga (ex: +2.5kg a 5% dependendo da carga)
      suggestedWeight = currentWeight + (currentWeight >= 40 ? 2.5 : 1.0);
      recommendation = 'Meta batida! Aumentar a carga na próxima sessão.';
    } 
    // Se ficou abaixo da faixa mínima
    else if (completedReps < targetMinReps) {
      suggestedWeight = currentWeight;
      recommendation = 'Abaixo da faixa mínima. Manter carga e focar nas repetições.';
    } 
    // Se está dentro da faixa, mas chegou à falha total (RPE 10)
    else if (rpe >= 10.0 && completedReps < targetMaxReps) {
      suggestedWeight = currentWeight;
      recommendation = 'Esforço máximo atingido. Consolidar o peso atual antes de subir.';
    } 
    // Comportamento padrão dentro da faixa
    else {
      suggestedWeight = currentWeight;
      recommendation = 'Dentro da faixa de hipertrofia. Tenha uma repetição a mais na próxima.';
    }

    return {
      'suggestedWeight': suggestedWeight,
      'recommendation': recommendation,
    };
  }
}