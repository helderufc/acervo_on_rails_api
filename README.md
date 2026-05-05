# Acervo SMD — API

Backend da plataforma de acervo de projetos do curso de **Sistemas e Mídias Digitais (SMD/IUVI/UFC)**. Permite que alunos e professores publiquem e consultem artigos, notícias, intervenções semióticas e jogos produzidos no curso.

Construído com **Ruby on Rails 8** no modo API-only, usando PostgreSQL.

---

## Pré-requisitos

- Ruby 3.4+
- PostgreSQL 14+
- Bundler (`gem install bundler`)

---

## Instalação local

### 1. Clone o repositório

```bash
git clone <url-do-repo>
cd acervo_on_rails_api
```

### 2. Instale as dependências

```bash
bundle install
```

### 3. Configure as variáveis de ambiente

Copie o arquivo de exemplo e preencha com os dados do seu PostgreSQL local:

```bash
cp .env.example .env
```

Edite o `.env`:

```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=seu_usuario_postgres
DB_PASSWORD=sua_senha_postgres
DB_NAME_DEV=acervo_smd_development
DB_NAME_TEST=acervo_smd_test

CORS_ORIGINS=http://localhost:5173
```

### 4. Crie e prepare o banco de dados

```bash
bin/rails db:create db:migrate
```

### 5. Suba o servidor

```bash
bin/rails server
```

A API estará disponível em `http://localhost:3000`.

---

## Testes

```bash
bundle exec rspec
```

---

## Variáveis de ambiente

| Variável | Descrição | Padrão |
|---|---|---|
| `DB_HOST` | Host do PostgreSQL | `localhost` |
| `DB_PORT` | Porta do PostgreSQL | `5432` |
| `DB_USERNAME` | Usuário do banco | — |
| `DB_PASSWORD` | Senha do banco | — |
| `DB_NAME_DEV` | Nome do banco de desenvolvimento | `acervo_smd_development` |
| `DB_NAME_TEST` | Nome do banco de testes | `acervo_smd_test` |
| `CORS_ORIGINS` | Origens permitidas pelo CORS | `http://localhost:5173` |
