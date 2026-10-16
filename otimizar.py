import json

def capitalizar(texto):
    if not texto:
        return ""
    return str(texto).strip().capitalize()

# Dicionário de tradução direta para Português das categorias e partes do corpo
traducao_pt = {
    "waist": "Cintura",
    "upper legs": "Pernas superiores",
    "lower legs": "Pernas inferiores",
    "back": "Costas",
    "chest": "Peito",
    "shoulders": "Ombros",
    "upper arms": "Braços superiores",
    "lower arms": "Antebraços",
    "cardio": "Cardio",
    "hips": "Ancas",
    "abdominals": "Abdominais"
}

# Carregar o ficheiro original
with open('exercises.json', 'r', encoding='utf-8') as f:
    dados = json.load(f)

exercicios_otimizados = []

for item in dados:
    # Usa o espanhol ('es') ou inglês ('en') como base de texto para garantir fluidez
    inst_dict = item.get('instructions', {})
    texto_instrucao = inst_dict.get('es') or inst_dict.get('en') or "Instrução indisponível."
    
    steps_dict = item.get('instruction_steps', {})
    lista_passos = steps_dict.get('es') or steps_dict.get('en') or []

    # Traduzir categoria para Português de forma limpa
    cat_original = item.get('category', '').lower()
    categoria_pt = traducao_pt.get(cat_original, capitalizar(cat_original))

    body_original = item.get('body_part', '').lower()
    body_pt = traducao_pt.get(body_original, capitalizar(body_original))

    novo_item = {
        "id": item.get('id'),
        "name": capitalizar(item.get('name')),
        "category": categoria_pt,
        "body_part": body_pt,
        "equipment": capitalizar(item.get('equipment')),
        "instructions": texto_instrucao,
        "instruction_steps": [capitalizar(p) for p in lista_passos],
        "muscle_group": capitalizar(item.get('muscle_group')),
        "secondary_muscles": [capitalizar(m) for m in item.get('secondary_muscles', [])],
        "target": capitalizar(item.get('target')),
        "image": item.get('image'),
        "gif_url": item.get('gif_url'),
        "media_id": item.get('media_id'),
        "created_at": item.get('created_at'),
        "attribution": item.get('attribution')
    }
    exercicios_otimizados.append(novo_item)

# Guardar diretamente no destino dos assets do Flutter
with open('assets/data/exercises.json', 'w', encoding='utf-8') as f:
    json.dump(exercicios_otimizados, f, ensure_ascii=False, indent=2)

print("SUCESSO! Ficheiro otimizado, traduzido para português e guardado em assets/data/exercises.json.")