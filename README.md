# ListaFácil 🛒

Aplicativo mobile desenvolvido em **Flutter** para organizar listas de compras de forma simples, visual e com controle de gastos em tempo real.

> Projeto acadêmico da disciplina **Programação para Dispositivos Móveis** — Unidade 02.

---

## 📌 Objetivo do Aplicativo

O **ListaFácil** tem como objetivo ajudar o usuário a planejar e acompanhar suas compras de mercado antes e durante a ida ao supermercado.

A proposta central é responder a uma pergunta prática: **“quanto vou gastar?”**. Para isso, o aplicativo permite cadastrar itens com quantidade e preço unitário, marcar o que já foi colocado no carrinho e visualizar o total geral, o valor já gasto e o valor que ainda falta comprar.

**Principais objetivos específicos:**

- Reduzir o esquecimento de itens durante as compras;
- Dar previsibilidade financeira por meio do cálculo automático de subtotais e total;
- Oferecer uma experiência de uso simples, com poucos toques para adicionar, editar, marcar e remover itens;
- Manter uma interface agradável, responsiva e acessível em diferentes tamanhos de tela.

---

## ⚙️ Funcionalidades do Aplicativo

### Autenticação

- Tela de login com campos de **e-mail** e **senha**;
- Validação de formato de e-mail e tamanho mínimo da senha (4 caracteres);
- Alternância para **mostrar/ocultar senha**;
- Estado de carregamento no botão durante a autenticação (simulada, sem backend);
- Botão de **sair** com diálogo de confirmação, retornando à tela de login.

### Gerenciamento da lista de compras

- **Adicionar item** informando nome, quantidade e preço unitário;
- **Editar item** existente, reaproveitando o mesmo formulário;
- **Remover item** de duas formas: botão de lixeira ou gesto de **arrastar para o lado** (*swipe to dismiss*);
- **Marcar/desmarcar item** como comprado via checkbox;
- Ações rápidas no menu superior: **marcar todos** e **desmarcar todos**;
- Feedback ao usuário por **SnackBar** ao adicionar, editar ou remover itens.

### Controle de valores

- Cálculo automático do **subtotal** de cada item (`quantidade × preço unitário`);
- **Preview do subtotal** em tempo real enquanto o item é digitado;
- **Total geral** da lista exibido permanentemente na barra inferior;
- **Resumo da compra** em *bottom sheet*, contendo:
  - Total gasto na compra;
  - Quantidade de itens e itens marcados;
  - Valor já marcado (já no carrinho);
  - Valor ainda a comprar.
- Formatação monetária no padrão brasileiro (`R$ 1.234,50`) e aceitação de vírgula ou ponto como separador decimal.

### Estados e validações

- **Estado vazio** (*empty state*) com chamada para ação quando a lista não possui itens;
- Validação de campos: nome obrigatório (mínimo 2 caracteres), quantidade inteira maior que zero e preço maior que zero;
- Botões de quantidade (`+` / `−`) com limite entre 1 e 999;
- Botão de cálculo desabilitado quando a lista está vazia.

> ⚠️ **Observação:** os dados são mantidos apenas em memória nesta versão. Ao sair da conta ou reiniciar o app, a lista é descartada. Não há persistência local nem integração com backend.

---

## 🧭 Estrutura de Telas

```
ListaFácilApp (main.dart)
└── LoginScreen
    └── (login validado)
        └── ListaComprasScreen
            ├── CadastroItemScreen  (novo item)
            ├── CadastroItemScreen  (editar item)
            ├── ResumoTotalSheet    (bottom sheet — resumo da compra)
            └── AlertDialog         (confirmação de logout → volta ao Login)
```

### 1. LoginScreen — `lib/screens/login_screen.dart`

Primeira tela do aplicativo.

- Logo e identidade visual do ListaFácil;
- Formulário com e-mail e senha;
- Validação em tempo de envio;
- Botão **Entrar** com indicador de progresso;
- Redireciona para a lista de compras em caso de sucesso.

### 2. ListaComprasScreen — `lib/screens/lista_compras_screen.dart`

Tela principal, onde a lista é exibida e gerenciada.

- **AppBar** com título “Minhas compras”, menu de opções (marcar/desmarcar todos) e botão de logout;
- **Lista** de itens em cards, com checkbox, nome, quantidade × preço, subtotal e ações de editar/remover;
- **Estado vazio** ilustrado com ícone e botão “Adicionar item”;
- **FAB** “Novo item” quando há itens na lista;
- **Barra inferior** fixa com total geral e botão “Calcular total”;
- **Bottom sheet** de resumo da compra.

### 3. CadastroItemScreen — `lib/screens/cadastro_item_screen.dart`

Formulário compartilhado entre criação e edição.

- Cabeçalho explicativo;
- Campo **nome do item**;
- Campo **quantidade** com botões de incremento/decremento;
- Campo **preço unitário** com prefixo `R$`;
- Card de **preview do subtotal** atualizado em tempo real;
- Botão fixo no rodapé: “Adicionar à lista” ou “Salvar alterações”;
- Retorna o `ItemCompra` criado/editado via `Navigator.pop`.

---

## 🎨 Proposta de Layout (UX/UI)

A interface segue os princípios do **Material Design 3**, com uma linguagem visual limpa, acolhedora e focada em leitura rápida de valores.

### Identidade visual

| Elemento | Cor | Hex |
|---|---|---|
| Primária (verde) | Verde supermercado | `#12755F` |
| Primária escura | Verde profundo | `#0A5747` |
| Destaque | Âmbar | `#F4A623` |
| Fundo | Verde-acinzentado claro | `#F5F8F6` |
| Texto principal | Verde quase preto | `#14211D` |
| Texto secundário | Cinza esverdeado | `#5F6F69` |
| Borda | Cinza claro | `#E3EAE7` |
| Erro / remoção | Vermelho | `#C0392B` |

- **Gradiente primário:** `#1A8A71 → #0A5747`, usado no ícone do login, no card de total e em destaques;
- **Paleta semântica:** verde para ações positivas e valores; vermelho para remoção e erros; âmbar como cor de apoio.

### Tipografia

- Fonte padrão do Material Design;
- Títulos com peso `w700`/`w800` e *letter spacing* levemente negativo para aparência moderna;
- Textos de apoio em `13–14,5 px` com altura de linha `1.4–1.5` para melhor legibilidade;
- Valores monetários destacados em `21–32 px` com peso `w800`.

### Formas e profundidade

- Cantos arredondados generosos: **14 px** (inputs e botões), **18 px** (cards), **26–28 px** (containers e bottom sheet);
- Sombras suaves e difusas (`blurRadius` entre 12 e 32) para criar hierarquia sem pesar;
- Botões principais com altura mínima de **52–54 px**, favorecendo o toque.

### Componentes e padrões de interação

- **Cards de item** que mudam de cor de borda e aplicam **texto riscado** quando o item é marcado;
- **Feedback imediato:** animações curtas (160–200 ms) em containers, botões e troca de conteúdo;
- **Gestos:** *swipe* para excluir, com fundo vermelho e ícone de lixeira;
- **Acessibilidade:** `tooltip` e `semanticLabel` nos botões e checkboxes, áreas de toque ampliadas e bom contraste de texto;
- **Responsividade:** conteúdo centralizado com larguras máximas (`440 px` no login, `600 px` no formulário, `720 px` na lista), evitando linhas longas em tablets e desktops;
- **Estados claros:** carregamento, vazio, erro de validação e confirmação de logout;
- **Organização do tema:** todas as cores, bordas, tipografia e estilos de componentes centralizados em `lib/theme/app_theme.dart`, facilitando a futura implementação de **modo escuro**.

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão / Uso |
|---|---|
| **Flutter** | SDK estável (canal `stable`) |
| **Dart** | `^3.13.7` |
| **Material Design 3** | `useMaterial3: true` |
| **flutter_lints** | `^6.0.0` — análise estática e boas práticas |
| **flutter_test** | Testes (estrutura inicial) |

**Dependências externas:** nenhuma. O projeto utiliza apenas a biblioteca padrão do Flutter, mantendo o app leve e sem integrações de terceiros.

### Estrutura de pastas

```
lib/
├── main.dart                      # Ponto de entrada e configuração do MaterialApp
├── models/
│   └── item_compra.dart           # Modelo de dados do item (imutável + copyWith)
├── screens/
│   ├── login_screen.dart          # Autenticação simulada
│   ├── lista_compras_screen.dart  # Lista, resumo, logout e exclusão
│   └── cadastro_item_screen.dart  # Formulário de criação/edição
├── theme/
│   └── app_theme.dart             # Design tokens e ThemeData (Material 3)
├── utils/
│   └── functions.dart             # Formatação de moeda, parser e cálculos de total
└── widgets/
    ├── barra_total.dart           # Barra inferior com total geral
    ├── botao_acao.dart            # Botão de ícone reutilizável
    ├── item_compra_tile.dart      # Card de item da lista
    └── no_empty_items.dart        # Estado vazio da lista
```

### Arquitetura

- **UI declarativa** com `StatefulWidget` e `setState` para o gerenciamento de estado local;
- **Separação de responsabilidades** entre modelos, telas, widgets reutilizáveis, tema e utilitários;
- **Modelo imutável** (`ItemCompra`) com `copyWith` para atualizações seguras;
- **Navegação** com `Navigator.push` / `pushReplacement` e retorno de dados tipado entre telas;
- **Cálculos centralizados** em `lib/utils/functions.dart`, evitando duplicação de regras de negócio.

---

## 🚀 Instalação e Execução

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (canal `stable`);
- Dart `3.13.7` ou superior (acompanha o Flutter);
- Para Android: **Android Studio** com um emulador configurado ou dispositivo físico com depuração USB;
- Para iOS (apenas macOS): **Xcode** e CocoaPods;
- Opcional: **VS Code** com a extensão Flutter ou **Android Studio** com o plugin Flutter.

Verifique o ambiente:

```bash
flutter --version
flutter doctor
```

### 1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd listafacil
```

### 2. Instalar as dependências

```bash
flutter pub get
```

### 3. Executar o aplicativo

```bash
flutter run
```

Para escolher um dispositivo específico:

```bash
flutter devices
flutter run -d <device_id>
```

Exemplos:

```bash
flutter run -d chrome     # Navegador
flutter run -d linux      # Desktop Linux
flutter run -d emulator-5554
```

### 4. Gerar build de produção

**Android (APK):**

```bash
flutter build apk --release
```

O arquivo será gerado em `build/app/outputs/flutter-apk/app-release.apk`.

**Android (App Bundle para Play Store):**

```bash
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web --release
```

### 5. Qualidade de código e testes

```bash
flutter analyze
flutter test
```

---

## 📱 Plataformas suportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

---

## 🔮 Melhorias futuras

- Persistência local com `shared_preferences`, `sqflite` ou `Isar`;
- Autenticação real com backend (Firebase Auth, Supabase ou API própria);
- Múltiplas listas por usuário (ex.: “Mercado”, “Farmácia”, “Churrasco”);
- Categorias, unidades de medida e observações por item;
- Histórico de compras e comparação de preços;
- Compartilhamento/exportação da lista;
- Modo escuro e suporte a temas personalizados;
- Testes unitários e de widget para cálculos e fluxos principais.

---

Desenvolvido como projeto acadêmico para a disciplina de **Programação para Dispositivos Móveis**. 💚
