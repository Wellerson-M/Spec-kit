#!/usr/bin/env pwsh
# Publica as issues no GitHub. Requer: repositÃ³rio git com remote origin (GitHub) e `gh auth login`.
# Uso: ./create-github-issues.ps1
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    gh issue create --title "T001: Criar estrutura monorepo (`backend/`, `frontend/`) conforme plan.md e inicializar git" --body-file "issues/T001.md" --label sigof
    gh issue create --title "T002: Inicializar projeto backend Node.js/Express + TypeScript `strict` em `backend/` (package.json, tsconfig.json)" --body-file "issues/T002.md" --label sigof
    gh issue create --title "T003: Inicializar projeto frontend Next.js/React + TypeScript `strict` em `frontend/` (package.json, tsconfig.json)" --body-file "issues/T003.md" --label sigof
    gh issue create --title "T004: Configurar ESLint + Prettier compartilhados em `backend/` e `frontend/`" --body-file "issues/T004.md" --label sigof
    gh issue create --title "T005: Configurar Husky + lint-staged (pré-commit roda lint + testes unitários) na raiz" --body-file "issues/T005.md" --label sigof
    gh issue create --title "T006: Criar `docker-compose.yml` (PostgreSQL + Redis + MinIO) e `.env.example` na raiz" --body-file "issues/T006.md" --label sigof
    gh issue create --title "T007: Configurar Jest (backend) em `backend/jest.config.ts` e Vitest (frontend) em `frontend/vitest.config.ts`" --body-file "issues/T007.md" --label sigof
    gh issue create --title "T008: Configurar Playwright para E2E em `frontend/playwright.config.ts`" --body-file "issues/T008.md" --label sigof
    gh issue create --title "T009: Definir schema Prisma com todas as entidades e enums em `backend/prisma/schema.prisma` (ver data-model.md)" --body-file "issues/T009.md" --label sigof
    gh issue create --title "T010: Gerar e aplicar migração inicial (`prisma migrate dev`) em `backend/prisma/migrations/`" --body-file "issues/T010.md" --label sigof
    gh issue create --title "T011: Criar cliente Prisma e logger Pino (correlation id) em `backend/src/lib/`" --body-file "issues/T011.md" --label sigof
    gh issue create --title "T012: Implementar middleware de autenticação JWT em `backend/src/middleware/auth.ts`" --body-file "issues/T012.md" --label sigof
    gh issue create --title "T013: Implementar middleware de tenant (injeta `empresa_id` do JWT em todas as queries) em `backend/src/middleware/tenant.ts`" --body-file "issues/T013.md" --label sigof
    gh issue create --title "T014: Implementar middleware de RBAC por perfil em `backend/src/middleware/rbac.ts`" --body-file "issues/T014.md" --label sigof
    gh issue create --title "T015: Implementar middleware de tratamento de erros e correlation id em `backend/src/middleware/errorHandler.ts`" --body-file "issues/T015.md" --label sigof
    gh issue create --title "T016: Configurar Express app, Helmet, CORS restrito e roteamento base em `backend/src/app.ts`" --body-file "issues/T016.md" --label sigof
    gh issue create --title "T017: Implementar endpoint `/health` e `/metrics` (Prometheus) em `backend/src/routes/ops.ts`" --body-file "issues/T017.md" --label sigof
    gh issue create --title "T018: Implementar endpoint de login (`POST /auth/login`) + hash de senha (argon2) em `backend/src/controllers/authController.ts` e `backend/src/services/authService.ts`" --body-file "issues/T018.md" --label sigof
    gh issue create --title "T019: Criar seed (empresa Aceville + 1 usuário por perfil) em `backend/prisma/seed.ts`" --body-file "issues/T019.md" --label sigof
    gh issue create --title "T020: Configurar cliente da API REST e contexto de autenticação no frontend em `frontend/src/services/api.ts` e `frontend/src/lib/auth.ts`" --body-file "issues/T020.md" --label sigof
    gh issue create --title "T021: Implementar tela de Login (Tela 1) em `frontend/src/app/login/page.tsx`" --body-file "issues/T021.md" --label sigof
    gh issue create --title "T022: [Integração] Teste de login e rejeição de JWT inválido/expirado em `backend/tests/integration/auth.test.ts`" --body-file "issues/T022.md" --label sigof
    gh issue create --title "T023: [Integração] Teste de isolamento cross-tenant (empresa A não acessa dados da empresa B) em `backend/tests/integration/tenant-isolation.test.ts`" --body-file "issues/T023.md" --label sigof
    gh issue create --title "T024: Teste unitário de geração de protocolo `SOL-AAAA-MM-NNNN` (único/imutável/concorrência) em `backend/tests/unit/protocolo.test.ts`" --body-file "issues/T024.md" --label sigof --label us1
    gh issue create --title "T025: Teste unitário das transições de status válidas (novo→em_andamento→resolvido) em `backend/tests/unit/status-transicao.test.ts`" --body-file "issues/T025.md" --label sigof --label us1
    gh issue create --title "T026: Teste de integração de criar/assumir/resolver solicitação em `backend/tests/integration/solicitacao-fluxo.test.ts`" --body-file "issues/T026.md" --label sigof --label us1
    gh issue create --title "T027: Teste de integração de limite de anexos (10 arquivos, 5MB) em `backend/tests/integration/anexos.test.ts`" --body-file "issues/T027.md" --label sigof --label us1
    gh issue create --title "T028: E2E do fluxo feliz de reversão (login→criar→assumir→resolver) em `frontend/tests/e2e/fluxo1-reversao.spec.ts`" --body-file "issues/T028.md" --label sigof --label us1
    gh issue create --title "T029: Repository de Solicitacao (com filtro `empresa_id`) em `backend/src/repositories/solicitacaoRepository.ts`" --body-file "issues/T029.md" --label sigof --label us1
    gh issue create --title "T030: Repository de Anexo, Mensagem, StatusHistorico, Notificacao em `backend/src/repositories/`" --body-file "issues/T030.md" --label sigof --label us1
    gh issue create --title "T031: Service de protocolo (geração atômica por empresa/ano/mês) em `backend/src/services/protocoloService.ts`" --body-file "issues/T031.md" --label sigof --label us1
    gh issue create --title "T032: Service de Solicitacao: criar, listar com filtros, detalhar em `backend/src/services/solicitacaoService.ts` (depende de T029, T031)" --body-file "issues/T032.md" --label sigof --label us1
    gh issue create --title "T033: Service de transição de status + registro em StatusHistorico em `backend/src/services/statusService.ts`" --body-file "issues/T033.md" --label sigof --label us1
    gh issue create --title "T034: Service de anexos (validação RF02 + upload S3/MinIO) em `backend/src/services/anexoService.ts`" --body-file "issues/T034.md" --label sigof --label us1
    gh issue create --title "T035: Service de notificações (e-mail SendGrid/Mailtrap + registro) em `backend/src/services/notificacaoService.ts`" --body-file "issues/T035.md" --label sigof --label us1
    gh issue create --title "T036: Controller + rotas de Solicitacao (`POST/GET /solicitacoes`, `GET /{id}`, `POST /{id}/assumir`, `PATCH /{id}/status`) em `backend/src/controllers/solicitacaoController.ts` e `backend/src/routes/solicitacoes.ts`" --body-file "issues/T036.md" --label sigof --label us1
    gh issue create --title "T037: Controller + rota de upload de anexos (`POST /{id}/anexos`) em `backend/src/controllers/anexoController.ts`" --body-file "issues/T037.md" --label sigof --label us1
    gh issue create --title "T038: Dashboard do Solicitante (Tela 2) em `frontend/src/app/solicitante/page.tsx`" --body-file "issues/T038.md" --label sigof --label us1
    gh issue create --title "T039: Formulário Nova Solicitação com upload drag-and-drop (Tela 3) em `frontend/src/app/solicitacoes/nova/page.tsx`" --body-file "issues/T039.md" --label sigof --label us1
    gh issue create --title "T040: Tela de Detalhes da Solicitação (timeline + anexos) (Tela 5) em `frontend/src/app/solicitacoes/[id]/page.tsx`" --body-file "issues/T040.md" --label sigof --label us1
    gh issue create --title "T041: Dashboard do Analista com fila e botão assumir (Tela 4) em `frontend/src/app/analista/page.tsx`" --body-file "issues/T041.md" --label sigof --label us1
    gh issue create --title "T042: Validação de entrada (RF01) e tratamento de erros nos endpoints de US1" --body-file "issues/T042.md" --label sigof --label us1
    gh issue create --title "T043: Logs estruturados das operações de US1 (criar/assumir/resolver)" --body-file "issues/T043.md" --label sigof --label us1
    gh issue create --title "T044: Teste unitário de detecção de duplicidade (mesmo CTe/NF em 7 dias; fora da janela não alerta) em `backend/tests/unit/duplicidade.test.ts`" --body-file "issues/T044.md" --label sigof --label us2
    gh issue create --title "T045: Teste unitário de cálculo/pausa/retomada de SLA em `backend/tests/unit/sla.test.ts`" --body-file "issues/T045.md" --label sigof --label us2
    gh issue create --title "T046: Teste de integração do alerta de duplicidade (HTTP 409) e do `"prosseguir`" em `backend/tests/integration/duplicidade.test.ts`" --body-file "issues/T046.md" --label sigof --label us2
    gh issue create --title "T047: E2E do fluxo de troca de pagador com duplicidade + aguardando doc em `frontend/tests/e2e/fluxo2-troca-pagador.spec.ts`" --body-file "issues/T047.md" --label sigof --label us2
    gh issue create --title "T048: Service de detecção de duplicidade (janela de 7 dias por empresa) em `backend/src/services/duplicidadeService.ts`" --body-file "issues/T048.md" --label sigof --label us2
    gh issue create --title "T049: Integrar duplicidade na criação de solicitação (retorno 409 + vincular/prosseguir) em `backend/src/services/solicitacaoService.ts`" --body-file "issues/T049.md" --label sigof --label us2
    gh issue create --title "T050: Estender statusService para `aguardando_doc` com pausa de SLA e retomada em `backend/src/services/statusService.ts`" --body-file "issues/T050.md" --label sigof --label us2
    gh issue create --title "T051: Lógica de SLA (limite 4h úteis, acúmulo de tempo pausado) em `backend/src/services/slaService.ts`" --body-file "issues/T051.md" --label sigof --label us2
    gh issue create --title "T052: UI de alerta de duplicidade (modal vincular/prosseguir) no formulário em `frontend/src/components/AlertaDuplicidade.tsx`" --body-file "issues/T052.md" --label sigof --label us2
    gh issue create --title "T053: Indicador de SLA na fila do analista (Tela 4) em `frontend/src/components/IndicadorSLA.tsx`" --body-file "issues/T053.md" --label sigof --label us2
    gh issue create --title "T054: Teste de integração de escalonamento + notificação ao supervisor em `backend/tests/integration/escalonamento.test.ts`" --body-file "issues/T054.md" --label sigof --label us3
    gh issue create --title "T055: Teste de integração de RBAC de prioridade (só supervisor; solicitante recebe 403) em `backend/tests/integration/rbac-prioridade.test.ts`" --body-file "issues/T055.md" --label sigof --label us3
    gh issue create --title "T056: Teste unitário de cálculo de KPIs (tempo médio, por status, por analista) em `backend/tests/unit/kpis.test.ts`" --body-file "issues/T056.md" --label sigof --label us3
    gh issue create --title "T057: E2E do fluxo de escalonamento + dashboard gerencial em `frontend/tests/e2e/fluxo3-escalonamento.spec.ts`" --body-file "issues/T057.md" --label sigof --label us3
    gh issue create --title "T058: Estender statusService para `escalado` + notificação ao supervisor em `backend/src/services/statusService.ts`" --body-file "issues/T058.md" --label sigof --label us3
    gh issue create --title "T059: Endpoints de prioridade e reatribuição (`PATCH /{id}/prioridade`, `PATCH /{id}/responsavel`, só supervisor) em `backend/src/controllers/solicitacaoController.ts`" --body-file "issues/T059.md" --label sigof --label us3
    gh issue create --title "T060: Service de relatórios/KPIs em `backend/src/services/relatorioService.ts`" --body-file "issues/T060.md" --label sigof --label us3
    gh issue create --title "T061: Endpoint `GET /relatorios/kpis` (supervisor/admin) em `backend/src/controllers/relatorioController.ts`" --body-file "issues/T061.md" --label sigof --label us3
    gh issue create --title "T062: Dashboard Gerencial com cards de KPI e gráficos (Tela 6) em `frontend/src/app/gerencial/page.tsx`" --body-file "issues/T062.md" --label sigof --label us3
    gh issue create --title "T063: Endpoint e UI de mensagens/chat da solicitação (`/{id}/mensagens`, RF07) em `backend/src/controllers/mensagemController.ts` e `frontend/src/components/Chat.tsx`" --body-file "issues/T063.md" --label sigof --label us3
    gh issue create --title "T064: Integrar Sentry (frontend e backend) para error tracking" --body-file "issues/T064.md" --label sigof
    gh issue create --title "T065: Configurar dashboards Grafana e alertas (indisponibilidade `/health`, picos de erro)" --body-file "issues/T065.md" --label sigof
    gh issue create --title "T066: Configurar SonarCloud + `npm audit`/Dependabot no repositório" --body-file "issues/T066.md" --label sigof
    gh issue create --title "T067: Criar pipeline GitHub Actions em `.github/workflows/ci.yml` (lint→testes→análise→quality gate→build→deploy→migração→health)" --body-file "issues/T067.md" --label sigof
    gh issue create --title "T068: Garantir cobertura ≥ 75% backend / ≥ 25% frontend e ajustar testes faltantes" --body-file "issues/T068.md" --label sigof
    gh issue create --title "T069: Documentação: README, `.env.example` completo e atualização do quickstart" --body-file "issues/T069.md" --label sigof
    gh issue create --title "T070: Hardening de segurança (revisão OWASP Top 10, política de senha, expiração de token)" --body-file "issues/T070.md" --label sigof
    gh issue create --title "T071: Validar performance (RNF02 < 2s p95) com cache Redis em fila/dashboard" --body-file "issues/T071.md" --label sigof
    gh issue create --title "T072: Executar `quickstart.md` ponta a ponta (3 fluxos) e validar KPIs" --body-file "issues/T072.md" --label sigof
} finally { Pop-Location }