<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan:
`specs/001-gestao-ocorrencias-frete/plan.md`

## SIGOF — resumo do contexto ativo

- **Feature ativa**: `001-gestao-ocorrencias-frete` (RFC v2.2 — SIGOF).
- **Stack**: TypeScript `strict`; Frontend Next.js/React; Backend Node.js/Express em camadas
  Controller→Service→Repository; PostgreSQL + Prisma; Redis; S3/MinIO; JWT + RBAC.
- **Estrutura**: `backend/` e `frontend/` desacoplados; `docker-compose.yml` (app+PG+Redis+MinIO).
- **Não-negociáveis** (`.specify/memory/constitution.md`): TDD (75% back / 25% front),
  isolamento multi-tenant por `empresa_id` derivado do JWT, auditabilidade/imutabilidade
  (protocolo imutável, sem exclusão, StatusHistorico), observabilidade (Pino/Sentry/health/metrics).
- **Artefatos**: spec.md, plan.md, research.md, data-model.md, contracts/openapi.yaml,
  quickstart.md, tasks.md em `specs/001-gestao-ocorrencias-frete/`.
<!-- SPECKIT END -->
