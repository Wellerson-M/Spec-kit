---
description: "Task list for SIGOF — Gestão de Ocorrências de Frete"
---

# Tasks: SIGOF — Gestão de Ocorrências de Frete

**Input**: Design documents from `specs/001-gestao-ocorrencias-frete/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/openapi.yaml, quickstart.md

**Tests**: INCLUÍDOS. O RFC (seção 5.6) e a constituição (Princípio I) exigem TDD com cobertura
mínima de 75% backend / 25% frontend; portanto, tarefas de teste são obrigatórias e escritas
antes da implementação correspondente.

**Organization**: Tarefas agrupadas por user story (US1, US2, US3) para implementação e teste
independentes.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Pode rodar em paralelo (arquivos diferentes, sem dependências)
- **[Story]**: A qual user story a tarefa pertence (US1, US2, US3)
- Caminhos de arquivo exatos incluídos nas descrições

## Path Conventions

- Backend: `backend/src/`, `backend/tests/`
- Frontend: `frontend/src/`, `frontend/tests/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicialização do projeto e estrutura base.

- [X] T001 Criar estrutura monorepo (`backend/`, `frontend/`) conforme plan.md e inicializar git
- [X] T002 [P] Inicializar projeto backend Node.js/Express + TypeScript `strict` em `backend/` (package.json, tsconfig.json)
- [X] T003 [P] Inicializar projeto frontend Next.js/React + TypeScript `strict` em `frontend/` (package.json, tsconfig.json)
- [ ] T004 [P] Configurar ESLint + Prettier compartilhados em `backend/` e `frontend/`
- [ ] T005 [P] Configurar Husky + lint-staged (pré-commit roda lint + testes unitários) na raiz
- [X] T006 Criar `docker-compose.yml` (PostgreSQL + Redis + MinIO) e `.env.example` na raiz
- [X] T007 [P] Configurar Jest (backend) em `backend/jest.config.ts` e Vitest (frontend) em `frontend/vitest.config.ts`
- [ ] T008 [P] Configurar Playwright para E2E em `frontend/playwright.config.ts`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Infraestrutura central que DEVE existir antes de qualquer user story.

**⚠️ CRITICAL**: Nenhuma user story começa antes desta fase concluir.

- [X] T009 Definir schema Prisma com todas as entidades e enums em `backend/prisma/schema.prisma` (ver data-model.md)
- [ ] T010 Gerar e aplicar migração inicial (`prisma migrate dev`) em `backend/prisma/migrations/`
- [ ] T011 [P] Criar cliente Prisma e logger Pino (correlation id) em `backend/src/lib/`
- [ ] T012 [P] Implementar middleware de autenticação JWT em `backend/src/middleware/auth.ts`
- [X] T013 Implementar middleware de tenant (injeta `empresa_id` do JWT em todas as queries) em `backend/src/middleware/tenant.ts`
- [ ] T014 [P] Implementar middleware de RBAC por perfil em `backend/src/middleware/rbac.ts`
- [ ] T015 [P] Implementar middleware de tratamento de erros e correlation id em `backend/src/middleware/errorHandler.ts`
- [X] T016 [P] Configurar Express app, Helmet, CORS restrito e roteamento base em `backend/src/app.ts`
- [ ] T017 [P] Implementar endpoint `/health` e `/metrics` (Prometheus) em `backend/src/routes/ops.ts`
- [ ] T018 Implementar endpoint de login (`POST /auth/login`) + hash de senha (argon2) em `backend/src/controllers/authController.ts` e `backend/src/services/authService.ts`
- [ ] T019 [P] Criar seed (empresa Aceville + 1 usuário por perfil) em `backend/prisma/seed.ts`
- [ ] T020 [P] Configurar cliente da API REST e contexto de autenticação no frontend em `frontend/src/services/api.ts` e `frontend/src/lib/auth.ts`
- [ ] T021 [P] Implementar tela de Login (Tela 1) em `frontend/src/app/login/page.tsx`
- [ ] T022 [P] [Integração] Teste de login e rejeição de JWT inválido/expirado em `backend/tests/integration/auth.test.ts`
- [ ] T023 [P] [Integração] Teste de isolamento cross-tenant (empresa A não acessa dados da empresa B) em `backend/tests/integration/tenant-isolation.test.ts`

**Checkpoint**: Fundação pronta — autenticação, multi-tenancy, RBAC e observabilidade ativos.

---

## Phase 3: User Story 1 - Abrir e resolver correção de CTe (Priority: P1) 🎯 MVP

**Goal**: Solicitante abre ticket de correção de CTe; analista assume e resolve; histórico e
notificações registrados.

**Independent Test**: Criar solicitação como solicitante, assumir como analista, resolver e
verificar protocolo, fila, notificações e histórico.

### Tests for User Story 1 (escrever antes da implementação) ⚠️

- [X] T024 [P] [US1] Teste unitário de geração de protocolo `SOL-AAAA-MM-NNNN` (único/imutável/concorrência) em `backend/tests/unit/protocolo.test.ts`
- [X] T025 [P] [US1] Teste unitário das transições de status válidas (novo→em_andamento→resolvido) em `backend/tests/unit/status-transicao.test.ts`
- [ ] T026 [P] [US1] Teste de integração de criar/assumir/resolver solicitação em `backend/tests/integration/solicitacao-fluxo.test.ts`
- [ ] T027 [P] [US1] Teste de integração de limite de anexos (10 arquivos, 5MB) em `backend/tests/integration/anexos.test.ts`
- [ ] T028 [P] [US1] E2E do fluxo feliz de reversão (login→criar→assumir→resolver) em `frontend/tests/e2e/fluxo1-reversao.spec.ts`

### Implementation for User Story 1

- [ ] T029 [P] [US1] Repository de Solicitacao (com filtro `empresa_id`) em `backend/src/repositories/solicitacaoRepository.ts`
- [ ] T030 [P] [US1] Repository de Anexo, Mensagem, StatusHistorico, Notificacao em `backend/src/repositories/`
- [X] T031 [US1] Service de protocolo (geração atômica por empresa/ano/mês) em `backend/src/services/protocoloService.ts`
- [ ] T032 [US1] Service de Solicitacao: criar, listar com filtros, detalhar em `backend/src/services/solicitacaoService.ts` (depende de T029, T031)
- [ ] T033 [US1] Service de transição de status + registro em StatusHistorico em `backend/src/services/statusService.ts`
- [ ] T034 [US1] Service de anexos (validação RF02 + upload S3/MinIO) em `backend/src/services/anexoService.ts`
- [ ] T035 [US1] Service de notificações (e-mail SendGrid/Mailtrap + registro) em `backend/src/services/notificacaoService.ts`
- [ ] T036 [US1] Controller + rotas de Solicitacao (`POST/GET /solicitacoes`, `GET /{id}`, `POST /{id}/assumir`, `PATCH /{id}/status`) em `backend/src/controllers/solicitacaoController.ts` e `backend/src/routes/solicitacoes.ts`
- [ ] T037 [US1] Controller + rota de upload de anexos (`POST /{id}/anexos`) em `backend/src/controllers/anexoController.ts`
- [ ] T038 [P] [US1] Dashboard do Solicitante (Tela 2) em `frontend/src/app/solicitante/page.tsx`
- [ ] T039 [P] [US1] Formulário Nova Solicitação com upload drag-and-drop (Tela 3) em `frontend/src/app/solicitacoes/nova/page.tsx`
- [ ] T040 [P] [US1] Tela de Detalhes da Solicitação (timeline + anexos) (Tela 5) em `frontend/src/app/solicitacoes/[id]/page.tsx`
- [ ] T041 [P] [US1] Dashboard do Analista com fila e botão assumir (Tela 4) em `frontend/src/app/analista/page.tsx`
- [ ] T042 [US1] Validação de entrada (RF01) e tratamento de erros nos endpoints de US1
- [ ] T043 [US1] Logs estruturados das operações de US1 (criar/assumir/resolver)

**Checkpoint**: US1 funcional e testável de forma independente — MVP entregável.

---

## Phase 4: User Story 2 - Troca de pagador: duplicidade e pendência de doc (Priority: P2)

**Goal**: Alerta de duplicidade (CTe/NF em 7 dias) e pausa/retomada de SLA em "Aguardando
documentação".

**Independent Test**: Criar duas solicitações para o mesmo CTe/NF em 7 dias (verificar alerta) e
mover uma para "Aguardando documentação" e de volta (verificar pausa/retomada de SLA).

### Tests for User Story 2 (escrever antes da implementação) ⚠️

- [X] T044 [P] [US2] Teste unitário de detecção de duplicidade (mesmo CTe/NF em 7 dias; fora da janela não alerta) em `backend/tests/unit/duplicidade.test.ts`
- [X] T045 [P] [US2] Teste unitário de cálculo/pausa/retomada de SLA em `backend/tests/unit/sla.test.ts`
- [ ] T046 [P] [US2] Teste de integração do alerta de duplicidade (HTTP 409) e do "prosseguir" em `backend/tests/integration/duplicidade.test.ts`
- [ ] T047 [P] [US2] E2E do fluxo de troca de pagador com duplicidade + aguardando doc em `frontend/tests/e2e/fluxo2-troca-pagador.spec.ts`

### Implementation for User Story 2

- [X] T048 [US2] Service de detecção de duplicidade (janela de 7 dias por empresa) em `backend/src/services/duplicidadeService.ts`
- [ ] T049 [US2] Integrar duplicidade na criação de solicitação (retorno 409 + vincular/prosseguir) em `backend/src/services/solicitacaoService.ts`
- [ ] T050 [US2] Estender statusService para `aguardando_doc` com pausa de SLA e retomada em `backend/src/services/statusService.ts`
- [X] T051 [US2] Lógica de SLA (limite 4h úteis, acúmulo de tempo pausado) em `backend/src/services/slaService.ts`
- [ ] T052 [P] [US2] UI de alerta de duplicidade (modal vincular/prosseguir) no formulário em `frontend/src/components/AlertaDuplicidade.tsx`
- [ ] T053 [P] [US2] Indicador de SLA na fila do analista (Tela 4) em `frontend/src/components/IndicadorSLA.tsx`

**Checkpoint**: US1 e US2 funcionam de forma independente.

---

## Phase 5: User Story 3 - Escalonamento e acompanhamento gerencial (Priority: P3)

**Goal**: Escalonamento, priorização e reatribuição por supervisor; dashboard gerencial com KPIs.

**Independent Test**: Escalar solicitação, alterar prioridade como supervisor (e confirmar 403
para não-supervisor), reatribuir e abrir o dashboard de KPIs.

### Tests for User Story 3 (escrever antes da implementação) ⚠️

- [ ] T054 [P] [US3] Teste de integração de escalonamento + notificação ao supervisor em `backend/tests/integration/escalonamento.test.ts`
- [ ] T055 [P] [US3] Teste de integração de RBAC de prioridade (só supervisor; solicitante recebe 403) em `backend/tests/integration/rbac-prioridade.test.ts`
- [ ] T056 [P] [US3] Teste unitário de cálculo de KPIs (tempo médio, por status, por analista) em `backend/tests/unit/kpis.test.ts`
- [ ] T057 [P] [US3] E2E do fluxo de escalonamento + dashboard gerencial em `frontend/tests/e2e/fluxo3-escalonamento.spec.ts`

### Implementation for User Story 3

- [ ] T058 [US3] Estender statusService para `escalado` + notificação ao supervisor em `backend/src/services/statusService.ts`
- [ ] T059 [US3] Endpoints de prioridade e reatribuição (`PATCH /{id}/prioridade`, `PATCH /{id}/responsavel`, só supervisor) em `backend/src/controllers/solicitacaoController.ts`
- [ ] T060 [US3] Service de relatórios/KPIs em `backend/src/services/relatorioService.ts`
- [ ] T061 [US3] Endpoint `GET /relatorios/kpis` (supervisor/admin) em `backend/src/controllers/relatorioController.ts`
- [ ] T062 [P] [US3] Dashboard Gerencial com cards de KPI e gráficos (Tela 6) em `frontend/src/app/gerencial/page.tsx`
- [ ] T063 [P] [US3] Endpoint e UI de mensagens/chat da solicitação (`/{id}/mensagens`, RF07) em `backend/src/controllers/mensagemController.ts` e `frontend/src/components/Chat.tsx`

**Checkpoint**: Todas as user stories funcionam de forma independente.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Melhorias transversais e endurecimento.

- [ ] T064 [P] Integrar Sentry (frontend e backend) para error tracking
- [ ] T065 [P] Configurar dashboards Grafana e alertas (indisponibilidade `/health`, picos de erro)
- [ ] T066 Configurar SonarCloud + `npm audit`/Dependabot no repositório
- [ ] T067 Criar pipeline GitHub Actions em `.github/workflows/ci.yml` (lint→testes→análise→quality gate→build→deploy→migração→health)
- [ ] T068 [P] Garantir cobertura ≥ 75% backend / ≥ 25% frontend e ajustar testes faltantes
- [ ] T069 [P] Documentação: README, `.env.example` completo e atualização do quickstart
- [ ] T070 Hardening de segurança (revisão OWASP Top 10, política de senha, expiração de token)
- [ ] T071 Validar performance (RNF02 < 2s p95) com cache Redis em fila/dashboard
- [ ] T072 Executar `quickstart.md` ponta a ponta (3 fluxos) e validar KPIs

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sem dependências — começa imediatamente.
- **Foundational (Phase 2)**: Depende do Setup — BLOQUEIA todas as user stories.
- **User Stories (Phase 3+)**: Dependem da Fundação. US1 (P1) primeiro; US2 e US3 podem seguir em
  paralelo após a fundação, mas a ordem recomendada é P1 → P2 → P3.
- **Polish (Phase 6)**: Depende das user stories desejadas concluídas.

### User Story Dependencies

- **US1 (P1)**: Só depende da Fundação. É o MVP.
- **US2 (P2)**: Depende da Fundação; reutiliza o service de solicitação e status de US1.
- **US3 (P3)**: Depende da Fundação; reutiliza status/notificação de US1.

### Within Each User Story

- Testes escritos e FALHANDO antes da implementação (TDD).
- Models/Repositories → Services → Controllers/Endpoints → UI.
- História completa antes de passar para a próxima prioridade.

### Parallel Opportunities

- Todas as tarefas marcadas [P] no Setup podem rodar em paralelo.
- Tarefas [P] da Fundação (middlewares, libs, telas independentes) em paralelo.
- Dentro de cada US, os testes [P] e os repositories/telas [P] em paralelo.
- Após a Fundação, US2 e US3 podem ser tocadas por desenvolvedores diferentes.

---

## Parallel Example: User Story 1

```bash
# Testes de US1 em paralelo (escrever primeiro, devem falhar):
Task: "T024 Teste unitário de geração de protocolo"
Task: "T025 Teste unitário de transições de status"
Task: "T026 Teste de integração criar/assumir/resolver"
Task: "T028 E2E do fluxo feliz de reversão"

# Repositories de US1 em paralelo:
Task: "T029 Repository de Solicitacao"
Task: "T030 Repositories de Anexo/Mensagem/StatusHistorico/Notificacao"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Phase 1: Setup.
2. Phase 2: Foundational (CRÍTICO — bloqueia tudo).
3. Phase 3: US1.
4. **PARAR e VALIDAR**: testar US1 de forma independente (quickstart Fluxo 1).
5. Deploy/demo do MVP.

### Incremental Delivery

1. Setup + Foundational → fundação pronta.
2. US1 → testar → deploy/demo (MVP).
3. US2 → testar → deploy/demo.
4. US3 → testar → deploy/demo.

---

## Notes

- [P] = arquivos diferentes, sem dependências.
- Rótulo [Story] mapeia a tarefa à user story para rastreabilidade.
- Verifique que os testes falham antes de implementar (TDD — Princípio I).
- Commit após cada tarefa ou grupo lógico.
- Total: 72 tarefas (Setup 8, Foundational 15, US1 20, US2 10, US3 10, Polish 9).
