# Sistema de Transição de Cenas

Este sistema permite que o jogador mude automaticamente de cena quando sair da tela atual.

## Como Funciona

### 1. Estrutura Implementada

- **Game.gd**: Script principal que gerencia as transições
- **Game.tscn**: Cena principal com 4 áreas de transição nas bordas
- **Player.gd**: Jogador adicionado ao grupo "player" para detecção
- **bar_da_tia_ana_frente.tscn**: Cena de exemplo de destino
- **bar_da_tia_ana_frente.gd**: Script da cena de destino

### 2. Áreas de Transição

O sistema inclui 4 áreas invisíveis posicionadas nas bordas da tela:

- **RightArea**: Borda direita (posição x=400)
- **LeftArea**: Borda esquerda (posição x=-400)  
- **UpArea**: Borda superior (posição y=-300)
- **DownArea**: Borda inferior (posição y=300)

### 3. Detecção de Transição

- Quando o jogador (que está no grupo "player") entra em qualquer área de transição
- O sistema verifica a direção baseada no nome da área
- Carrega a cena correspondente usando `get_tree().change_scene_to_file()`

### 4. Configuração de Cenas de Destino

No arquivo `Game.gd`, você pode configurar as cenas de destino:

```gdscript
var scene_transitions = {
    "right": "res://bar_da_tia_ana_frente.tscn",
    "left": "res://bar_da_tia_ana_frente.tscn",  # Pode ser alterado
    "up": "res://bar_da_tia_ana_frente.tscn",    # Pode ser alterado
    "down": "res://bar_da_tia_ana_frente.tscn"   # Pode ser alterado
}
```

### 5. Navegação de Volta

- Na cena de destino, pressione **ESC** para voltar à cena anterior
- Isso é gerenciado pelo script `bar_da_tia_ana_frente.gd`

## Como Personalizar

### Adicionar Novas Cenas de Destino

1. Crie uma nova cena (.tscn)
2. Adicione um script similar ao `bar_da_tia_ana_frente.gd`
3. Atualize o dicionário `scene_transitions` em `Game.gd`

### Ajustar Posições das Áreas

Modifique as posições das áreas em `Game.tscn`:
- `RightArea`: position = Vector2(400, 0)
- `LeftArea`: position = Vector2(-400, 0)
- `UpArea`: position = Vector2(0, -300)
- `DownArea`: position = Vector2(0, 300)

### Ajustar Tamanhos das Áreas

Modifique os tamanhos das formas em `Game.tscn`:
- `RectangleShape2D_right`: size = Vector2(50, 600)
- `RectangleShape2D_left`: size = Vector2(50, 600)
- `RectangleShape2D_up`: size = Vector2(800, 50)
- `RectangleShape2D_down`: size = Vector2(800, 50)

## Testando

1. Execute a cena `Game.tscn`
2. Mova o jogador para qualquer borda da tela
3. A cena deve mudar automaticamente
4. Na cena de destino, pressione ESC para voltar
