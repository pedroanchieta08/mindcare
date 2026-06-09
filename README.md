# MindCare

MindCare é um aplicativo Flutter voltado ao acompanhamento emocional do usuário. O app permite registrar sentimentos, visualizar informações semanais, acessar conteúdos de apoio, consultar estudos sobre saúde mental e navegar por áreas como relatórios, avisos, calendário e perfil.

## Tecnologias utilizadas

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- PubMed API via HTTP
- url_launcher
- table_calendar
- fl_chart
- syncfusion_flutter_charts
- intl

## Pré-requisitos

Antes de rodar o projeto, verifique se você possui instalado:

- Flutter SDK
- Dart SDK
- Android Studio ou VS Code
- Emulador Android, dispositivo físico ou navegador Chrome
- Git, caso vá clonar o projeto de um repositório

Para conferir se o ambiente Flutter está configurado corretamente, execute:

```bash
flutter doctor
```

Corrija os problemas indicados pelo comando antes de continuar.

## Como rodar o projeto

### 1. Acesse a pasta do projeto

Depois de baixar ou extrair o projeto, entre na pasta principal:

```bash
cd mindcare
```

### 2. Instale as dependências

Execute o comando abaixo para baixar os pacotes usados pelo app:

```bash
flutter pub get
```

### 3. Verifique a configuração do Firebase

Este projeto usa Firebase para autenticação e banco de dados.

Os principais arquivos de configuração são:

```text
lib/firebase_options.dart
android/app/google-services.json
firebase.json
```

No código atual, o Firebase está configurado para Android e Web. Para iOS, macOS, Windows ou Linux, será necessário configurar novamente com o FlutterFire CLI.

Caso precise refazer a configuração do Firebase, use:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Depois disso, confirme se o arquivo `firebase_options.dart` foi gerado corretamente.

### 4. Rode o aplicativo

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

Para rodar no dispositivo ou emulador padrão:

```bash
flutter run
```

Para rodar no Chrome:

```bash
flutter run -d chrome
```

Para rodar em um emulador Android específico:

```bash
flutter run -d <id-do-dispositivo>
```

O ID do dispositivo aparece no comando `flutter devices`.

## Comandos úteis

Atualizar dependências:

```bash
flutter pub get
```

Limpar arquivos temporários do projeto:

```bash
flutter clean
```

Depois do `flutter clean`, instale as dependências novamente:

```bash
flutter pub get
```

Analisar o código:

```bash
flutter analyze
```

Executar testes:

```bash
flutter test
```

Gerar APK de release:

```bash
flutter build apk --release
```

Gerar versão Web:

```bash
flutter build web
```

## Estrutura principal do projeto

```text
lib/
├── constants/
│   └── app_colors.dart
├── data/
│   ├── profissional_repository.dart
│   ├── sentiment_store.dart
│   └── user_repository.dart
├── models/
│   ├── app_user.dart
│   ├── profissional_model.dart
│   ├── pubmed_artigo.dart
│   └── user_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── sentimental.dart
│   ├── calendar.dart
│   ├── cvv_screen.dart
│   ├── notification_screen.dart
│   ├── perfil_screen.dart
│   ├── relatorios_user.dart
│   ├── relatorios_profissional.dart
│   └── respiration_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── pubmed_service.dart
│   └── user_service.dart
├── widgets/
│   ├── bottombar.dart
│   ├── custom_text_field.dart
│   ├── pubmed_card.dart
│   └── sentimentos_semana.dart
├── firebase_options.dart
└── main.dart
```

## Funcionalidades principais

- Login e cadastro de usuários
- Integração com Firebase Authentication
- Registro de sentimentos
- Exibição dos sentimentos da semana
- Relatórios do usuário
- Tela de calendário
- Tela de perfil
- Tela com informações do CVV
- Botão SOS com contatos de emergência
- Respiração guiada
- Busca de estudos sobre saúde mental usando PubMed

## Observações importantes

- O app inicializa o Firebase no arquivo `main.dart`.
- A localização de datas é configurada para `pt_BR`.
- As imagens usadas pelo projeto ficam em `assets/imagens/`.
- O arquivo `pubspec.yaml` já inclui essa pasta como asset do Flutter.
- Para rodar em Android, mantenha o arquivo `android/app/google-services.json` no projeto.
- Para rodar em Web, confira se as configurações do Firebase Web estão corretas em `firebase_options.dart`.

## Problemas comuns

### Erro ao baixar dependências

Execute:

```bash
flutter clean
flutter pub get
```

### Firebase não inicializa

Verifique se os arquivos abaixo existem e estão corretos:

```text
lib/firebase_options.dart
android/app/google-services.json
```

Também confira se o projeto Firebase está ativo e se Authentication e Firestore foram configurados no console do Firebase.

### Erro ao rodar no iOS, macOS, Windows ou Linux

O arquivo `firebase_options.dart` indica que essas plataformas ainda não foram configuradas. Para habilitá-las, rode:

```bash
flutterfire configure
```

E selecione as plataformas desejadas.

### Imagens não aparecem

Confira se a pasta existe:

```text
assets/imagens/
```

E se ela está declarada no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/imagens/
```
