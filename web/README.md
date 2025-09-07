# SantosPunk - Versão Web

Esta pasta contém a versão web do SantosPunk para GitHub Pages.

## 📋 Como Exportar o Jogo para Web

### 1. **No Godot Engine:**
1. Abra o projeto SantosPunk
2. Vá em **Project → Export**
3. Clique **"Add..."** → Selecione **"Web"**
4. Configure as opções:
   - **Export Path**: `web/santospunk.html`
   - **Custom HTML Shell**: Deixe vazio (usaremos nosso index.html)
5. Clique **"Export Project"**

### 2. **Arquivos Gerados:**
Após exportar, você terá:
- `santospunk.html` - Arquivo principal do jogo
- `santospunk.js` - Script do jogo
- `santospunk.wasm` - Binário WebAssembly
- `santospunk.pck` - Pacote de recursos

### 3. **Atualizar index.html:**
Substitua o conteúdo do `index.html` pelo conteúdo do `santospunk.html` exportado, mantendo o estilo cyberpunk.

### 4. **Commit e Push:**
```bash
git add web/
git commit -m "Add web export for SantosPunk"
git push
```

## 🌐 GitHub Pages

O jogo estará disponível em:
**https://hericmr.github.io/santospunk/**

## 🔧 Troubleshooting

- **Jogo não carrega**: Verifique se todos os arquivos foram exportados
- **Erro 404**: Confirme se GitHub Pages está ativado
- **Performance lenta**: Otimize assets no Godot antes de exportar

## 📱 Compatibilidade

- ✅ Chrome/Chromium
- ✅ Firefox  
- ✅ Safari
- ✅ Edge
- ⚠️ Dispositivos móveis (pode precisar de ajustes)
