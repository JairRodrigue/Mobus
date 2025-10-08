# Mobus

> Aplicativo de monitoramento de ônibus, com compartilhamento e visualização de localização em tempo real. Projeto multiplataforma (Flutter) para Android e Web — atualmente em desenvolvimento.

---

## Índice

- [Descrição Geral](#descrição-geral)
- [Recursos e Funcionalidades](#recursos-e-funcionalidades)
- [Dependências e Tecnologias](#dependências-e-tecnologias)
- [Instalação](#instalação)
- [Configuração do Ambiente (.env)](#configuração-do-ambiente-env)
- [Execução do Aplicativo](#execução-do-aplicativo)
- [Contribuição](#contribuição)
- [Licença](#licença)
- [Contato](#contato)


---

## Descrição Geral

Mobus é um aplicativo desenvolvido em Flutter com suporte multiplataforma (Android e Web) voltado ao acompanhamento da localização de ônibus em tempo real. O objetivo principal é facilitar o deslocamento dos usuários, permitindo o compartilhamento da posição do ônibus entre motoristas e passageiros, garantindo melhor planejamento e organização ao aguardar seu transporte.

---

## Recursos e Funcionalidades

- Geolocalização em tempo real para monitoramento de veículos
- Compartilhamento de localização entre usuários
- Visualização em mapas interativos (OpenStreetMap)
- Plataforma de autenticação e backend via Firebase
- Sistema seguro e flexível de configuração via variáveis de ambiente (.env)
- Interface multiplataforma responsiva: Android e Web

---

## Dependências e Tecnologias

### Principais

- [Flutter](https://flutter.dev) (mobile e web)
- [Firebase](https://firebase.google.com) (Realtime Database e Authentication)

### Bibliotecas utilizadas

- `flutter_dotenv: ^6.0.0`
- `firebase_core: ^2.27.0`
-  `firebase_auth: ^4.17.0`
-  `geolocator: ^12.0.0`
-  `flutter_map: ^7.0.2`
-  `latlong2: ^0.9.1`
- Outras dependências descritas em `pubspec.yaml`


---

## Instalação

### 1. Clonagem do Repositório

    git clone https://github.com/JairRodrigue/Mobus.
    
    cd Mobus
   

---

### 2. Instalação das Dependências

    flutter pub get


---

## Configuração do Ambiente (.env)

Crie um arquivo `.env` na raiz do projeto contendo as credenciais e variáveis necessárias para inicialização dos serviços (exemplo para Firebase):

- `API_KEY=...` (Chave de API do Firebase)
- `AUTH_DOMAIN=...` (Domínio de autenticação do Firebase)
- `PROJECT_ID=...` (ID do projeto Firebase)
- `STORAGE_BUCKET=...` (Bucket de armazenamento do Firebase)
- `MESSAGING_SENDER_ID=...` (ID do remetente de mensagens Firebase)
- `APP_ID=...` (ID da aplicação Firebase)
- `MEASUREMENT_ID=...` (ID de medição do Google Analytics 4)


> **Atenção:** O arquivo `.env` contém informações sensíveis e não deve ser compartilhado, versionado ou exposto publicamente.

---

## Execução do Aplicativo

### Android (Mobile)

1. Verifique os emuladores disponíveis:
    ```
    flutter emulators
    ```
2. Inicie o emulador desejado:
    ```
    flutter emulators --launch <nome_do_emulador>
    ```
3. Execute o projeto:
    ```
    flutter run
    ```

### Web
 Execute o app diretamente no navegador Chrome:

    flutter run -d chrome


---

## Contribuição

Contribuições e sugestões para aprimoramento são bem-vindas e podem ser realizadas via Pull Requests, seguindo as etapas:
1. Realizar fork do repositório
2. Criar branch específica para sua contribuição
3. Descrever claramente a proposta no Pull Request

---

## Licença

Este projeto está sob a licença MIT. Detalhes disponíveis em [`LICENSE`](LICENSE).

---

## Contato

Este projeto foi desenvolvido por uma equipe de três colaboradores:

- **Jair Rodrigues**  
  GitHub: [https://github.com/JairRodrigue](https://github.com/JairRodrigue)

- **Keila Roberta**  
  GitHub: [https://github.com/keilarobertasv](https://github.com/keilarobertasv)

- **Chaylane Franco**  
  GitHub: [https://github.com/Chayfranco](https://github.com/Chayfranco)

Repositório oficial do projeto: [Mobus](https://github.com/JairRodrigue/Mobus)
