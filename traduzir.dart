import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('exercises.json');
  if (!await file.exists()) {
    print('Erro: O ficheiro exercises.json não foi encontrado na raiz.');
    return;
  }

  final bytes = await file.readAsBytes();
  final content = utf8.decode(bytes, allowMalformed: true);
  
  final decodedData = json.decode(content);
  List<dynamic> dados = [];
  if (decodedData is List) {
    dados = decodedData;
  } else if (decodedData is Map && decodedData.containsKey('exercises')) {
    dados = decodedData['exercises'];
  }

  final Map<String, String> traducaoCategorias = {
    "waist": "Abdomen e Core",
    "upper legs": "Pernas",
    "lower legs": "Panturrilhas",
    "back": "Costas",
    "chest": "Peito",
    "shoulders": "Ombros",
    "upper arms": "Bracos",
    "lower arms": "Antebracos",
  };

  final Set<String> categoriasPermitidas = {
    "waist", "upper legs", "lower legs", "back", "chest", "shoulders", "upper arms", "lower arms"
  };

  // Função avançada para traduzir termos em inglês para português e limpar acentos/cedilhas
  String traduzirEFormatarNome(String nomeIngles) {
    var nome = nomeIngles.toLowerCase();

    // Dicionário de tradução de termos comuns de musculação
    final Map<String, String> substituicoes = {
      "archer push up": "flexao arqueiro",
      "push up": "flexao de braco",
      "bench press": "supino",
      "chest dip": "mergulho para peito",
      "dip": "mergulho",
      "squat": "agachamento",
      "curl": "rosca",
      "extension": "extensao",
      "raise": "elevacao",
      "pull down": "puxada",
      "pulldown": "puxada",
      "row": "remada",
      "press": "desenvolvimento",
      "lunge": "avanco",
      "crunch": "abdominal",
      "plank": "prancha",
      "barbell": "com barra",
      "dumbbell": "com halteres",
      "cable": "no cabo",
      "machine": "na maquina",
      "seated": "sentado",
      "standing": "em pe",
      "incline": "inclinado",
      "decline": "declinado",
      "flat": "reto",
      "one arm": "unilateral",
      "alternate": "alternado",
      "kneeling": "ajoelhado",
      "stability ball": "com bola de estabilidade",
      "wide-grip": "com pegada aberta",
      "close-grip": "com pegada fechada",
      "assisted": "assistido",
      "stretch": "alongamento",
      "pectoralis major": "peitoral maior",
      "band": "com elastico",
      "bodyweight": "peso corporal",
      "body weight": "peso corporal",
      "right": "",
      "left": "",
    };

    substituicoes.forEach((eng, pt) {
      nome = nome.replaceAll(eng, pt);
    });

    // Substituir rigorosamente todos os caracteres especiais por equivalentes seguros (sem ç ou acentos)
    nome = nome
        .replaceAll('ç', 'c')
        .replaceAll('Ç', 'C')
        .replaceAll('ã', 'a')
        .replaceAll('õ', 'o')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('â', 'a')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('à', 'a')
        .replaceAll('Ã', 'A')
        .replaceAll('Õ', 'O')
        .replaceAll(RegExp(r'\s+'), ' ') // Remove espaços duplicados
        .trim();

    if (nome.isEmpty) return 'Exercicio';
    return nome[0].toUpperCase() + nome.substring(1);
  }

  String limparTexto(String? texto) {
    if (texto == null || texto.isEmpty) return '';
    var limpo = texto.trim()
        .replaceAll('ç', 'c')
        .replaceAll('Ç', 'C')
        .replaceAll('ã', 'a')
        .replaceAll('õ', 'o')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('â', 'a')
        .replaceAll('ê', 'e')
        .replaceAll('ô', 'o')
        .replaceAll('à', 'a');
    if (limpo.isEmpty) return '';
    return limpo[0].toUpperCase() + limpo.substring(1);
  }

  List<dynamic> novosDados = [];
  for (var item in dados) {
    if (item is! Map) continue;
    
    var cOrig = (item['category'] ?? '').toString().toLowerCase().trim();
    if (!categoriasPermitidas.contains(cOrig)) {
      continue; 
    }

    var categoria = traducaoCategorias[cOrig] ?? limparTexto(cOrig);
    var nomeTraduzido = traduzirEFormatarNome(item['name']?.toString() ?? '');

    var bOrig = (item['body_part'] ?? '').toString().toLowerCase();
    var bodyPart = traducaoCategorias[bOrig] ?? limparTexto(bOrig);

    var instMap = item['instructions'];
    String inst = '';
    if (instMap is Map) {
      inst = limparTexto((instMap['es'] ?? instMap['en'] ?? '').toString());
    } else if (instMap is String) {
      inst = limparTexto(instMap);
    }

    var stepsList = item['instruction_steps'];
    List<String> steps = [];
    if (stepsList is List) {
      for (var s in stepsList) {
        steps.add(limparTexto(s.toString()));
      }
    }

    var secMuscles = item['secondary_muscles'];
    List<String> secondary = [];
    if (secMuscles is List) {
      for (var m in secMuscles) {
        secondary.add(limparTexto(m.toString()));
      }
    }

    novosDados.add({
      "id": item['id'],
      "name": nomeTraduzido,
      "category": categoria,
      "body_part": bodyPart,
      "equipment": limparTexto(item['equipment']?.toString()),
      "instructions": inst,
      "instruction_steps": steps,
      "muscle_group": limparTexto(item['muscle_group']?.toString()),
      "secondary_muscles": secondary,
      "target": limparTexto(item['target']?.toString()),
      "image": item['image'],
      "gif_url": item['gif_url'],
      "media_id": item['media_id'],
      "created_at": item['created_at'],
      "attribution": item['attribution']
    });
  }

  final targetFile = File('assets/data/exercises.json');
  await targetFile.writeAsBytes(utf8.encode(json.encode(novosDados)));
  print('SUCESSO FINAL: ${novosDados.length} exercicios traduzidos e limpos com sucesso!');
}