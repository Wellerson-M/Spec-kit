# Implementation Plan: SIGOF — Gestão de Ocorrências de Frete

**Branch**: `001-gestao-ocorrencias-frete` | **Date**: 2026-06-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-gestao-ocorrencias-frete/spec.md`

## Summary

O SIGOF substitui o fluxo caótico de e-mails de correção de CTe por um sistema de tickets
estruturado: protocolo único, fila priorizada, atribuição, chat registrado e histórico
auditável, com isolamento multi-tenant desde o MVP. A abordagem técnica é uma aplicação web
desacoplada — frontend Next.js/React (TypeScript) consumindo uma API REST Node.js/Express
(TypeScript) em camadas Controller–Service–Repository, sobre PostgreSQL (Prisma), com Redis,
storage S3/MinIO e e-mail SendGrid/Mailtrap. Tudo orientado a TDD, observabilidade (logs, Sentry,
Prometheus/Grafana, `/health`) e CI/CD com quality gate.

## Technical Context

**Language/Version**: TypeScript 5.x em modo `strict` (Node.js 22 LTS no backend, React 18/Next.js no frontend)

**Primary Dependencies**: Next.js + React (frontend); Express + Prisma ORM (backend); JWT, bcrypt/argon2, Pino, Helmet

**Storage**: PostgreSQL (relacional, gerenciado em nuvem); Redis (cache de filas/dashboards); S3/MinIO (anexos)

**Testing**: Jest (backend unit), Vitest (frontend unit), Supertest + Testcontainers/PostgreSQL (integração), Playwright (E2E)

**Target Platform**: Navegador web moderno (desktop e mobile); backend em container Docker em nuvem (AWS ECS/EC2 ou Render); frontend na Vercel

**Project Type**: Web application (frontend + backend desacoplados)

**Performance Goals**: < 2s em 95% das requisições (RNF02); suportar ≥ 50 usuários simultâneos (RNF01)

**Constraints**: Disponibilidade ≥ 99% em horário comercial (RNF04); até 10 anexos/solicitação de 5MB (RF02); alerta de duplicidade CTe/NF em 7 dias (RF09); SLA inicial de 4h com pausa em "Aguardando documentação"; dados sensíveis criptografados em repouso e trânsito (RNF06); OWASP Top 10 (RNF10)

**Scale/Scope**: MVP single-tenant (Aceville, ~20-30 solicitações/dia, equipe de 2-3 analistas), arquitetura preparada para multi-tenant; ~6 telas, 4 perfis de usuário, 7 entidades

## Constitution Check

*GATE: Deve passar antes da Fase 0. Reavaliado após a Fase 1.*

| Princípio (Constitution v1.0.0) | Como o plano atende | Status |
|---|---|---|
| I. Test-First / TDD (NON-NEGOTIABLE) | Jest/Vitest/Supertest/Playwright no pipeline; metas 75% backend / 25% frontend no quality gate; testes de protocolo, status, duplicidade, SLA e cross-tenant | ✅ PASS |
| II. Segurança e Isolamento Multi-Tenant | `empresa_id` em todas as tabelas; middleware de tenant deriva empresa do JWT; RBAC no backend; OWASP (Helmet, bcrypt/argon2, queries parametrizadas, segredos em env) | ✅ PASS |
| III. Auditabilidade e Imutabilidade | Protocolo `SOL-AAAA-MM-NNNN` único/imutável; sem exclusão (apenas finalizar/cancelar); `StatusHistorico`; logs ≥ 12 meses | ✅ PASS |
| IV. Arquitetura em Camadas e API-First | Controller→Service→Repository; contratos REST em `contracts/` antes dos endpoints; regras só no backend | ✅ PASS |
| V. Observabilidade e Excelência Operacional | Pino (correlation id), Sentry, `/health` + `/metrics` (Prometheus/Grafana), metas RNF02/RNF04 | ✅ PASS |

**Resultado**: Sem violações. Nenhuma entrada em Complexity Tracking necessária. A stack segue
integralmente o RFC seção 5.4, conforme exigido pela Section 2 da constituição.

## Project Structure

### Documentation (this feature)

```text
specs/001-gestao-ocorrencias-frete/
├── plan.md              # Este arquivo (/speckit-plan)
├── spec.md              # Especificação (/speckit-specify)
├── research.md          # Fase 0 (/speckit-plan)
├── data-model.md        # Fase 1 (/speckit-plan)
├── quickstart.md        # Fase 1 (/speckit-plan)
├── contracts/           # Fase 1 (/speckit-plan)
│   └── openapi.yaml
├── checklists/
│   └── requirements.md  # Checklist de qualidade da spec
├── tasks.md             # Fase 2 (/speckit-tasks)
└── issues/              # Issues geradas (/speckit-taskstoissues)
```

### Source Code (repository root)

```text
backend/
├── src/
│   ├── models/          # Tipos/entidades de domínio (Prisma schema em prisma/)
│   ├── repositories/    # Acesso a dados isolado (filtro empresa_id)
│   ├── services/        # Regras de negócio (protocolo, status, duplicidade, SLA)
│   ├── controllers/     # Handlers HTTP (REST)
│   ├── routes/          # Definição de rotas/endpoints
│   ├── middleware/      # auth (JWT), tenant (empresa_id), rbac, errorHandler, correlationId
│   ├── lib/             # logger (Pino), prisma client, storage (S3/MinIO), mailer
│   └── config/          # env, constantes (limites de anexo, janela de duplicidade, SLA)
├── prisma/
│   ├── schema.prisma    # Modelo de dados (ver data-model.md)
│   └── migrations/
└── tests/
    ├── unit/            # Jest — regras de negócio puras
    ├── integration/     # Supertest + Testcontainers — endpoints, RBAC, cross-tenant
    └── e2e/             # (compartilhado com frontend via Playwright)

frontend/
├── src/
│   ├── app/             # Rotas Next.js (login, dashboards, nova solicitação, detalhes)
│   ├── components/      # UI reutilizável (fila, formulário, timeline, chat, cards KPI)
│   ├── services/        # Cliente da API REST
│   └── lib/             # auth client, helpers
└── tests/
    ├── unit/            # Vitest
    └── e2e/             # Playwright (3 fluxos de negócio)

.github/workflows/       # CI/CD (lint, testes, SonarCloud, build Docker, deploy)
docker-compose.yml       # app + PostgreSQL + Redis + MinIO (ambiente local)
```

**Structure Decision**: Aplicação web com **dois projetos desacoplados** (`backend/` e
`frontend/`), conforme o Project Type "web application" e a arquitetura cliente-servidor do RFC
(seção 5.3). O backend segue Controller–Service–Repository (Princípio IV), com `middleware/`
centralizando autenticação, tenant e RBAC (Princípio II). `docker-compose.yml` reproduz o
ambiente completo localmente (RFC seção 5.8).

## Complexity Tracking

> Sem violações de Constitution Check. Nenhuma justificativa de complexidade necessária.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| (nenhuma) | — | — |
