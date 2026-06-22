# SIGOF — Sistema Inteligente de Gestão de Ocorrências de Frete

Projeto desenvolvido com a metodologia **SDD (Spec-Driven Development)** usando o
[GitHub Spec-Kit](https://github.com/github/spec-kit), a partir do RFC v2.2 do SIGOF.

O SIGOF substitui o fluxo caótico de e-mails de correção de CTe (reversão de frete, troca de
pagador, ajuste fiscal) por um sistema de tickets estruturado: protocolo único, fila priorizada,
atribuição, chat registrado, histórico auditável e isolamento multi-tenant.

## Artefatos do Spec-Kit

| Etapa | Comando Spec-Kit | Artefato |
|------|------------------|----------|
| Constitution | `/speckit-constitution` | [`.specify/memory/constitution.md`](.specify/memory/constitution.md) |
| Specify | `/speckit-specify` | [`specs/001-gestao-ocorrencias-frete/spec.md`](specs/001-gestao-ocorrencias-frete/spec.md) |
| Plan | `/speckit-plan` | [`plan.md`](specs/001-gestao-ocorrencias-frete/plan.md) + research/data-model/contracts/quickstart |
| Tasks | `/speckit-tasks` | [`tasks.md`](specs/001-gestao-ocorrencias-frete/tasks.md) |
| Tasks → Issues | `/speckit-taskstoissues` | [`issues/`](specs/001-gestao-ocorrencias-frete/issues/) + `create-github-issues.ps1` |
| Implement | `/speckit-implement` | scaffolding em `backend/` e `frontend/` |

## Stack

- **Frontend**: Next.js + React (TypeScript `strict`)
- **Backend**: Node.js + Express (TypeScript `strict`), camadas Controller→Service→Repository
- **Banco**: PostgreSQL + Prisma · **Cache**: Redis · **Storage**: S3/MinIO · **Auth**: JWT + RBAC

## Como rodar (resumo)

```bash
docker compose up -d            # PostgreSQL + Redis + MinIO
cd backend && npm install
npx prisma migrate dev && npm run seed
npm run dev                     # API em http://localhost:3001/api/v1

cd ../frontend && npm install && npm run dev   # app em http://localhost:3000
```

Detalhes e validação dos 3 fluxos de negócio: ver
[`quickstart.md`](specs/001-gestao-ocorrencias-frete/quickstart.md).

## Testes

```bash
cd backend
npm run test:unit          # regras puras: protocolo, status, duplicidade, SLA
npm run test:coverage      # meta >= 75% (Princípio I da constituição)
```
