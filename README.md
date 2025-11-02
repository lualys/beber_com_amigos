# Beber com Amigos

**Beber com Amigos** é um aplicativo Flutter divertido e interativo para animar festas e encontros!
O jogo traz perguntas, desafios e regras que fazem todos entrarem no clima da diversão — com níveis de intensidade, efeitos sonoros e animações.

---

##  Demonstração

Confira o app em funcionamento 👇

 **Versão demonstrativa no YouTube:**
👉 [Assista à demonstração do aplicativo](https://youtube.com/shorts/6Upc4PmBDaY)

 **Captura de tela do app:** <p align="center">
  <img src="https://github.com/lualys/beber_com_amigos/raw/main/assets/demo/demo.png" width="350px"/>
</p>


## Funcionalidades Principais

* **Cartas interativas** com animação de virada (flip)
* **Regras ativas** exibidas no topo até o fim da rodada
* **Sistema de goles** (quem bebe, quantos goles, penalidades)
* **Som de sininho** ao aplicar regras
* **Suporte a modo claro e escuro**
* **Compatível com Device Preview** para testar em múltiplos dispositivos
* Interface moderna com gradiente e Material 3

---

## Estrutura de Pastas

```
lib/
├── main.dart
├── models/
│   ├── game_card.dart
│   └── game_category.dart
├── providers/
│   └── game_provider.dart
├── services/
│   └── data_service.dart
├── screens/
│   ├── home_screen.dart
│   └── game_screen.dart
└── widgets/
    └── filter_chips.dart

assets/
├── data/
│   └── dados_perguntas.json
└── sounds/
    └── bell.mp3
```

---

## 🚀 Como Executar o Projeto

### 1️⃣ Pré-requisitos

* Flutter 3.22 ou superior
* Dart 3
* VS Code ou Android Studio

### 2️⃣ Clonar o projeto

```bash
git clone https://github.com/lualys/beber_com_amigos.git
cd beber_com_amigos
```

### 3️⃣ Instalar dependências

```bash
flutter pub get
```

### 4️⃣ Executar no navegador ou emulador

```bash
flutter run
```

---

## 🔧 Dependências Principais

| Pacote           | Função                           |
| ---------------- | -------------------------------- |
| `provider`       | Gerenciamento de estado          |
| `google_fonts`   | Tipografia estilizada            |
| `vector_math`    | Animação 3D do flip das cartas   |
| `audioplayers`   | Efeitos sonoros do jogo          |
| `device_preview` | Visualização em diferentes telas |

---

## 🔊 Sons e Recursos

* O arquivo de som deve estar em `assets/sounds/bell.mp3`
* Configure os assets no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/data/dados_perguntas.json
    - assets/sounds/bell.mp3
```

---

## 📚 Créditos e Licença

Criado por **Luana Silva Figueiredo** ❤️
Inspirado em jogos de festa como *Eu Nunca* e *Verdade ou Desafio*.


---

## 💡 Ideias Futuras

* 🎵 Som de brinde ao virar carta
* 🔥 Modo “Competitivo” com pontuação
* 🧑‍🤝‍🧑 Perfil de jogadores e ranking
* 🌍 Modo multiplayer online


