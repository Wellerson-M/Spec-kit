<!--
SYNC IMPACT REPORT
==================
Version change: TEMPLATE → 1.0.0
Bump rationale: Ratificação inicial da constituição do projeto SIGOF (primeira versão concreta
a partir do template). Versionamento MAJOR por estabelecer o conjunto inicial de princípios.

Modified principles: N/A (ratificação inicial)
Added sections:
  - Core Principles (I a V)
  - Restrições Tecnológicas e de Segurança (Section 2)
  - Fluxo de Desenvolvimento e Quality Gates (Section 3)
  - Governance

Templates requiring updates:
  - .specify/templates/plan-template.md ✅ (Constitution Check alinhado a estes princípios)
  - .specify/templates/spec-template.md ✅ (sem conflito; mantém foco em WHAT/WHY)
  - .specify/templates/tasks-template.md ✅ (categorias de teste/observabilidade refletidas)

Follow-up TODOs: nenhum.
-->

# SIGOF Constitution

**Sistema Inteligente de Gestão de Ocorrências de Frete**

Esta constituição define os princípios não-negociáveis do projeto SIGOF. Ela tem origem direta
no RFC v2.2 (Wellerson Meredyk) e prevalece sobre qualquer prática informal. Toda decisão de
design, todo plano e toda task devem ser verificáveis contra estes princípios.

## Core Principles

### I. Test-First / TDD (NON-NEGOTIABLE)

O desenvolvimento é orientado a testes. Para cada regra de negócio (geração de protocolo,
transições de status, detecção de duplicidade, cálculo/pausa de SLA, isolamento multi-tenant),
o teste é escrito ANTES da implementação e DEVE falhar primeiro (Red-Green-Refactor).

Regras mensuráveis e obrigatórias:

- Cobertura mínima de **75% no backend** e **25% no frontend**; o *quality gate* do CI reprova
  o merge abaixo desse limiar.
- A pirâmide de testes é respeitada: unitários (Jest/Vitest), integração (Supertest +
  PostgreSQL de teste) e E2E (Playwright) para os três fluxos de negócio.
- Casos de segurança são obrigatórios: *cross-tenant* (empresa A nunca lê dados da empresa B),
  RBAC (solicitante não assume/prioriza) e imutabilidade (solicitação nunca é excluída).

**Rationale:** o RFC (seção 5.6) exige TDD explícito com metas de cobertura; testes antes do
código são a barreira primária contra regressões em regras fiscais sensíveis.

### II. Segurança e Isolamento Multi-Tenant por Padrão

Segurança não é etapa final — é precondição de cada feature. O sistema é multi-tenant desde o
MVP, mesmo operando só para a Aceville.

Regras não-negociáveis:

- Toda tabela de negócio carrega `empresa_id`; **toda** consulta é filtrada por `empresa_id`
  derivado do token JWT da sessão — **nunca** de parâmetro enviado pelo cliente.
- Um *middleware* central injeta o filtro de tenant; esquecer o filtro é um defeito bloqueante.
- Autorização por perfil (RBAC: solicitante, analista, supervisor, admin) é validada no
  backend, nunca apenas no frontend.
- Controles OWASP Top 10 (seção 6.1 do RFC): senhas com hash forte (bcrypt/argon2), HTTPS/TLS,
  queries parametrizadas/ORM, segredos em variáveis de ambiente, dependências monitoradas.

**Rationale:** o RFC (seções 5.5 e 6) trata dados fiscais sensíveis e prepara evolução SaaS;
um vazamento *cross-tenant* é a falha mais grave possível do produto.

### III. Auditabilidade e Imutabilidade

O histórico é fonte de verdade e não pode ser adulterado.

Regras não-negociáveis:

- Cada solicitação tem protocolo **único e imutável** (`SOL-AAAA-MM-NNNN`).
- Solicitações **não são excluídas** — apenas finalizadas ou canceladas.
- Toda mudança de status é registrada em `StatusHistorico` (autor + timestamp).
- Logs de operações relevantes são retidos por no mínimo 12 meses (RNF09).

**Rationale:** o RFC (seções 2.5, 5.2 e 6.2) exige rastreabilidade total para auditoria fiscal
e LGPD; sem trilha imutável, o produto perde sua proposta de valor central.

### IV. Arquitetura em Camadas e API-First

O backend é organizado em **Controller → Service → Repository** e exposto como **API REST**;
o frontend (Next.js) é um cliente desacoplado.

Regras não-negociáveis:

- *Controllers* só orquestram HTTP; regras de negócio vivem nos *Services*; acesso a dados é
  isolado nos *Repositories*.
- Nenhuma regra de negócio é implementada apenas no frontend.
- Contratos de API são definidos antes da implementação dos endpoints.

**Rationale:** o RFC (seção 5.3) define esse padrão para favorecer testabilidade, manutenção e
a futura separação de tenants/SaaS.

### V. Observabilidade e Excelência Operacional

O sistema deve ser observável e operável desde o primeiro deploy.

Regras não-negociáveis:

- Logs estruturados (JSON) com *correlation id* por requisição (Pino).
- *Error tracking* (Sentry) no frontend e backend.
- Endpoint `/health` para *health check* e `/metrics` para Prometheus + Grafana.
- Metas operacionais do RFC são alvos verificáveis: resposta < 2s em 95% das requisições
  (RNF02) e disponibilidade ≥ 99% em horário comercial (RNF04).

**Rationale:** o RFC (seções 5.7 a 5.9) exige observabilidade e CI/CD; sem ela, KPIs (seção 1.6)
e SLAs não são mensuráveis nem defensáveis.

## Restrições Tecnológicas e de Segurança

A stack é fixada pelo RFC (seção 5.4) e qualquer desvio exige justificativa registrada em
Complexity Tracking do plano:

- **Frontend:** React + Next.js (TypeScript em modo `strict`).
- **Backend:** Node.js + Express (TypeScript em modo `strict`).
- **Banco:** PostgreSQL (relacional, integridade referencial), migrações via Prisma Migrate.
- **Cache:** Redis · **Storage de anexos:** S3/MinIO · **E-mail:** SendGrid/Mailtrap.
- **Autenticação:** JWT *stateless* integrado a RBAC.
- **Análise estática obrigatória:** ESLint + Prettier, SonarCloud, `npm audit`/Dependabot,
  Husky + lint-staged (pré-commit roda lint e testes unitários).
- **Limites de dados do RFC:** até 10 anexos por solicitação, 5MB cada (RF02); alerta de
  duplicidade para mesmo CTe/NF em 7 dias (RF09); SLA inicial de 4h em horário comercial.
- **LGPD:** dados pessoais de funcionários sob finalidade interna; correção/remoção via
  administrador; dados operacionais não excluídos por exigência fiscal (seção 6.2).

## Fluxo de Desenvolvimento e Quality Gates

O pipeline (GitHub Actions, seção 5.9) é a autoridade de qualidade. O merge na `main` só ocorre
quando, em ordem:

1. **Lint + type-check** (ESLint, Prettier, `tsc`) passam.
2. **Testes** (unitários + integração + E2E) passam.
3. **Análise estática** (SonarCloud + `npm audit`) passa no *quality gate*.
4. Cobertura ≥ 75% backend / ≥ 25% frontend é atingida.

Após aprovação, o deploy em produção é automático (Vercel + AWS/Render), com aplicação de
migrações e verificação de `/health`. Todo deploy gera imagem imutável, permitindo *rollback*.
Segredos sempre via variáveis de ambiente; nunca credenciais no código (`.env.example`
versionado documenta as variáveis).

## Governance

- Esta constituição **prevalece** sobre quaisquer práticas conflitantes do projeto.
- **Emendas** exigem: (a) descrição da mudança, (b) justificativa, (c) atualização dos templates
  dependentes em `.specify/templates/` e (d) incremento de versão.
- **Versionamento semântico** desta constituição:
  - MAJOR — remoção/redefinição incompatível de princípios ou governança;
  - MINOR — novo princípio/seção ou expansão material de orientação;
  - PATCH — esclarecimentos e correções não-semânticas.
- **Conformidade:** todo PR e toda revisão de código DEVEM verificar aderência aos princípios; o
  Constitution Check do `plan-template.md` é o ponto de verificação obrigatório antes do design.
- **Complexidade** que viole um princípio só é aceita se registrada e justificada na tabela
  Complexity Tracking do plano.

**Version**: 1.0.0 | **Ratified**: 2026-06-22 | **Last Amended**: 2026-06-22
