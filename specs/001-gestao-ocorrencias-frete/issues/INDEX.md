# Issues â€” SIGOF (001-gestao-ocorrencias-frete)

Total de issues geradas: 72

| ID | User Story | Fase | TÃ­tulo |
|----|-----------|------|--------|
| [T001](T001.md) |  | Phase 1: Setup (Shared Infrastructure) | Criar estrutura monorepo (`backend/`, `frontend/`) conforme plan.md e inicializar git |
| [T002](T002.md) |  | Phase 1: Setup (Shared Infrastructure) | Inicializar projeto backend Node.js/Express + TypeScript `strict` em `backend/` (package.json, tsconfig.json) |
| [T003](T003.md) |  | Phase 1: Setup (Shared Infrastructure) | Inicializar projeto frontend Next.js/React + TypeScript `strict` em `frontend/` (package.json, tsconfig.json) |
| [T004](T004.md) |  | Phase 1: Setup (Shared Infrastructure) | Configurar ESLint + Prettier compartilhados em `backend/` e `frontend/` |
| [T005](T005.md) |  | Phase 1: Setup (Shared Infrastructure) | Configurar Husky + lint-staged (pré-commit roda lint + testes unitários) na raiz |
| [T006](T006.md) |  | Phase 1: Setup (Shared Infrastructure) | Criar `docker-compose.yml` (PostgreSQL + Redis + MinIO) e `.env.example` na raiz |
| [T007](T007.md) |  | Phase 1: Setup (Shared Infrastructure) | Configurar Jest (backend) em `backend/jest.config.ts` e Vitest (frontend) em `frontend/vitest.config.ts` |
| [T008](T008.md) |  | Phase 1: Setup (Shared Infrastructure) | Configurar Playwright para E2E em `frontend/playwright.config.ts` |
| [T009](T009.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Definir schema Prisma com todas as entidades e enums em `backend/prisma/schema.prisma` (ver data-model.md) |
| [T010](T010.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Gerar e aplicar migração inicial (`prisma migrate dev`) em `backend/prisma/migrations/` |
| [T011](T011.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Criar cliente Prisma e logger Pino (correlation id) em `backend/src/lib/` |
| [T012](T012.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar middleware de autenticação JWT em `backend/src/middleware/auth.ts` |
| [T013](T013.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar middleware de tenant (injeta `empresa_id` do JWT em todas as queries) em `backend/src/middleware/tenant.ts` |
| [T014](T014.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar middleware de RBAC por perfil em `backend/src/middleware/rbac.ts` |
| [T015](T015.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar middleware de tratamento de erros e correlation id em `backend/src/middleware/errorHandler.ts` |
| [T016](T016.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Configurar Express app, Helmet, CORS restrito e roteamento base em `backend/src/app.ts` |
| [T017](T017.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar endpoint `/health` e `/metrics` (Prometheus) em `backend/src/routes/ops.ts` |
| [T018](T018.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar endpoint de login (`POST /auth/login`) + hash de senha (argon2) em `backend/src/controllers/authController.ts` e `backend/src/services/authService.ts` |
| [T019](T019.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Criar seed (empresa Aceville + 1 usuário por perfil) em `backend/prisma/seed.ts` |
| [T020](T020.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Configurar cliente da API REST e contexto de autenticação no frontend em `frontend/src/services/api.ts` e `frontend/src/lib/auth.ts` |
| [T021](T021.md) |  | Phase 2: Foundational (Blocking Prerequisites) | Implementar tela de Login (Tela 1) em `frontend/src/app/login/page.tsx` |
| [T022](T022.md) |  | Phase 2: Foundational (Blocking Prerequisites) | [Integração] Teste de login e rejeição de JWT inválido/expirado em `backend/tests/integration/auth.test.ts` |
| [T023](T023.md) |  | Phase 2: Foundational (Blocking Prerequisites) | [Integração] Teste de isolamento cross-tenant (empresa A não acessa dados da empresa B) em `backend/tests/integration/tenant-isolation.test.ts` |
| [T024](T024.md) | US1 | Tests for User Story 1 (escrever antes da implementação) ⚠️ | Teste unitário de geração de protocolo `SOL-AAAA-MM-NNNN` (único/imutável/concorrência) em `backend/tests/unit/protocolo.test.ts` |
| [T025](T025.md) | US1 | Tests for User Story 1 (escrever antes da implementação) ⚠️ | Teste unitário das transições de status válidas (novo→em_andamento→resolvido) em `backend/tests/unit/status-transicao.test.ts` |
| [T026](T026.md) | US1 | Tests for User Story 1 (escrever antes da implementação) ⚠️ | Teste de integração de criar/assumir/resolver solicitação em `backend/tests/integration/solicitacao-fluxo.test.ts` |
| [T027](T027.md) | US1 | Tests for User Story 1 (escrever antes da implementação) ⚠️ | Teste de integração de limite de anexos (10 arquivos, 5MB) em `backend/tests/integration/anexos.test.ts` |
| [T028](T028.md) | US1 | Tests for User Story 1 (escrever antes da implementação) ⚠️ | E2E do fluxo feliz de reversão (login→criar→assumir→resolver) em `frontend/tests/e2e/fluxo1-reversao.spec.ts` |
| [T029](T029.md) | US1 | Implementation for User Story 1 | Repository de Solicitacao (com filtro `empresa_id`) em `backend/src/repositories/solicitacaoRepository.ts` |
| [T030](T030.md) | US1 | Implementation for User Story 1 | Repository de Anexo, Mensagem, StatusHistorico, Notificacao em `backend/src/repositories/` |
| [T031](T031.md) | US1 | Implementation for User Story 1 | Service de protocolo (geração atômica por empresa/ano/mês) em `backend/src/services/protocoloService.ts` |
| [T032](T032.md) | US1 | Implementation for User Story 1 | Service de Solicitacao: criar, listar com filtros, detalhar em `backend/src/services/solicitacaoService.ts` (depende de T029, T031) |
| [T033](T033.md) | US1 | Implementation for User Story 1 | Service de transição de status + registro em StatusHistorico em `backend/src/services/statusService.ts` |
| [T034](T034.md) | US1 | Implementation for User Story 1 | Service de anexos (validação RF02 + upload S3/MinIO) em `backend/src/services/anexoService.ts` |
| [T035](T035.md) | US1 | Implementation for User Story 1 | Service de notificações (e-mail SendGrid/Mailtrap + registro) em `backend/src/services/notificacaoService.ts` |
| [T036](T036.md) | US1 | Implementation for User Story 1 | Controller + rotas de Solicitacao (`POST/GET /solicitacoes`, `GET /{id}`, `POST /{id}/assumir`, `PATCH /{id}/status`) em `backend/src/controllers/solicitacaoController.ts` e `backend/src/routes/solicitacoes.ts` |
| [T037](T037.md) | US1 | Implementation for User Story 1 | Controller + rota de upload de anexos (`POST /{id}/anexos`) em `backend/src/controllers/anexoController.ts` |
| [T038](T038.md) | US1 | Implementation for User Story 1 | Dashboard do Solicitante (Tela 2) em `frontend/src/app/solicitante/page.tsx` |
| [T039](T039.md) | US1 | Implementation for User Story 1 | Formulário Nova Solicitação com upload drag-and-drop (Tela 3) em `frontend/src/app/solicitacoes/nova/page.tsx` |
| [T040](T040.md) | US1 | Implementation for User Story 1 | Tela de Detalhes da Solicitação (timeline + anexos) (Tela 5) em `frontend/src/app/solicitacoes/[id]/page.tsx` |
| [T041](T041.md) | US1 | Implementation for User Story 1 | Dashboard do Analista com fila e botão assumir (Tela 4) em `frontend/src/app/analista/page.tsx` |
| [T042](T042.md) | US1 | Implementation for User Story 1 | Validação de entrada (RF01) e tratamento de erros nos endpoints de US1 |
| [T043](T043.md) | US1 | Implementation for User Story 1 | Logs estruturados das operações de US1 (criar/assumir/resolver) |
| [T044](T044.md) | US2 | Tests for User Story 2 (escrever antes da implementação) ⚠️ | Teste unitário de detecção de duplicidade (mesmo CTe/NF em 7 dias; fora da janela não alerta) em `backend/tests/unit/duplicidade.test.ts` |
| [T045](T045.md) | US2 | Tests for User Story 2 (escrever antes da implementação) ⚠️ | Teste unitário de cálculo/pausa/retomada de SLA em `backend/tests/unit/sla.test.ts` |
| [T046](T046.md) | US2 | Tests for User Story 2 (escrever antes da implementação) ⚠️ | Teste de integração do alerta de duplicidade (HTTP 409) e do "prosseguir" em `backend/tests/integration/duplicidade.test.ts` |
| [T047](T047.md) | US2 | Tests for User Story 2 (escrever antes da implementação) ⚠️ | E2E do fluxo de troca de pagador com duplicidade + aguardando doc em `frontend/tests/e2e/fluxo2-troca-pagador.spec.ts` |
| [T048](T048.md) | US2 | Implementation for User Story 2 | Service de detecção de duplicidade (janela de 7 dias por empresa) em `backend/src/services/duplicidadeService.ts` |
| [T049](T049.md) | US2 | Implementation for User Story 2 | Integrar duplicidade na criação de solicitação (retorno 409 + vincular/prosseguir) em `backend/src/services/solicitacaoService.ts` |
| [T050](T050.md) | US2 | Implementation for User Story 2 | Estender statusService para `aguardando_doc` com pausa de SLA e retomada em `backend/src/services/statusService.ts` |
| [T051](T051.md) | US2 | Implementation for User Story 2 | Lógica de SLA (limite 4h úteis, acúmulo de tempo pausado) em `backend/src/services/slaService.ts` |
| [T052](T052.md) | US2 | Implementation for User Story 2 | UI de alerta de duplicidade (modal vincular/prosseguir) no formulário em `frontend/src/components/AlertaDuplicidade.tsx` |
| [T053](T053.md) | US2 | Implementation for User Story 2 | Indicador de SLA na fila do analista (Tela 4) em `frontend/src/components/IndicadorSLA.tsx` |
| [T054](T054.md) | US3 | Tests for User Story 3 (escrever antes da implementação) ⚠️ | Teste de integração de escalonamento + notificação ao supervisor em `backend/tests/integration/escalonamento.test.ts` |
| [T055](T055.md) | US3 | Tests for User Story 3 (escrever antes da implementação) ⚠️ | Teste de integração de RBAC de prioridade (só supervisor; solicitante recebe 403) em `backend/tests/integration/rbac-prioridade.test.ts` |
| [T056](T056.md) | US3 | Tests for User Story 3 (escrever antes da implementação) ⚠️ | Teste unitário de cálculo de KPIs (tempo médio, por status, por analista) em `backend/tests/unit/kpis.test.ts` |
| [T057](T057.md) | US3 | Tests for User Story 3 (escrever antes da implementação) ⚠️ | E2E do fluxo de escalonamento + dashboard gerencial em `frontend/tests/e2e/fluxo3-escalonamento.spec.ts` |
| [T058](T058.md) | US3 | Implementation for User Story 3 | Estender statusService para `escalado` + notificação ao supervisor em `backend/src/services/statusService.ts` |
| [T059](T059.md) | US3 | Implementation for User Story 3 | Endpoints de prioridade e reatribuição (`PATCH /{id}/prioridade`, `PATCH /{id}/responsavel`, só supervisor) em `backend/src/controllers/solicitacaoController.ts` |
| [T060](T060.md) | US3 | Implementation for User Story 3 | Service de relatórios/KPIs em `backend/src/services/relatorioService.ts` |
| [T061](T061.md) | US3 | Implementation for User Story 3 | Endpoint `GET /relatorios/kpis` (supervisor/admin) em `backend/src/controllers/relatorioController.ts` |
| [T062](T062.md) | US3 | Implementation for User Story 3 | Dashboard Gerencial com cards de KPI e gráficos (Tela 6) em `frontend/src/app/gerencial/page.tsx` |
| [T063](T063.md) | US3 | Implementation for User Story 3 | Endpoint e UI de mensagens/chat da solicitação (`/{id}/mensagens`, RF07) em `backend/src/controllers/mensagemController.ts` e `frontend/src/components/Chat.tsx` |
| [T064](T064.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Integrar Sentry (frontend e backend) para error tracking |
| [T065](T065.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Configurar dashboards Grafana e alertas (indisponibilidade `/health`, picos de erro) |
| [T066](T066.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Configurar SonarCloud + `npm audit`/Dependabot no repositório |
| [T067](T067.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Criar pipeline GitHub Actions em `.github/workflows/ci.yml` (lint→testes→análise→quality gate→build→deploy→migração→health) |
| [T068](T068.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Garantir cobertura ≥ 75% backend / ≥ 25% frontend e ajustar testes faltantes |
| [T069](T069.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Documentação: README, `.env.example` completo e atualização do quickstart |
| [T070](T070.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Hardening de segurança (revisão OWASP Top 10, política de senha, expiração de token) |
| [T071](T071.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Validar performance (RNF02 < 2s p95) com cache Redis em fila/dashboard |
| [T072](T072.md) |  | Phase 6: Polish & Cross-Cutting Concerns | Executar `quickstart.md` ponta a ponta (3 fluxos) e validar KPIs |