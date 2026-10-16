import json

def capitalizar(texto):
    if not texto:
        return ""
    return str(texto).strip().capitalize()

# Dicionário de tradução exata para Português das categorias
cat_pt = {
    "waist": "Cintura",
    "upper legs": "Pernas superiores",
    "lower legs": "Pernas inferiores",
    "back": "Costas",
    "chest": "Peito",
    "shoulders": "Ombros",
    "upper arms": "Braços superiores",
    "lower arms": "Antebraços",
    "cardio": "Cardio",
    "neck": "Pescoço"
}

# Carregar o JSON original
with open('exercises.json', 'r', encoding='utf-8') as f:
    dados = json.load(f)

novos_dados = []
for item in dados:
    c_orig = item.get('category', '').lower()
    categoria = cat_pt.get(c_orig, capitalizar(c_orig))
    
    b_orig = item.get('body_part', '').lower()
    body_part = cat_pt.get(b_orig, capitalizar(b_orig))
    
    # Extrair instruções em espanhol/inglês limpas
    inst = item.get('instructions', {}).get('es') or item.get('instructions', {}).get('en', '')
    steps = item.get('instruction_steps', {}).get('es') or item.get('instruction_steps', {}).get('en', [])

    novo_item = {
        "id": item.get('id'),
        "name": capitalizar(item.get('name')),
        "category": categoria,
        "body_part": body_part,
        "equipment": capitalizar(item.get('equipment')),
        "instructions": inst,
        "instruction_steps": [capitalizar(p) for p in steps],
        "muscle_group": capitalizar(item.get('muscle_group')),
        "secondary_muscles": [capitalizar(m) for m in item.get('secondary_muscles', [])],
        "target": capitalizar(item.get('target')),
        "image": item.get('image'),
        "gif_url": item.get('gif_url'),
        "media_id": item.get('media_id'),
        "created_at": item.get('created_at'),
        "attribution": item.get('attribution')
    }
    novos_dados.append(novo_item)

# Guardar diretamente no diretório de assets da aplicação
with open('assets/data/exercises.json', 'w', encoding='utf-8') as f:
    json.dump(novos_dados, f, ensure_ascii=False, indent=2)

print("Tradução e formatação concluídas com sucesso!")