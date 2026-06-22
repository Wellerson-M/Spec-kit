# Quickstart — Validação do SIGOF

Guia para subir o ambiente e validar os três fluxos de negócio ponta a ponta (RFC seção 3.3).
Detalhes de modelo e contrato estão em [data-model.md](./data-model.md) e
[contracts/openapi.yaml](./contracts/openapi.yaml).

## Pré-requisitos

- Node.js 22 LTS e npm
- Docker + Docker Compose (PostgreSQL + Redis + MinIO locais)
- Variáveis de ambiente a partir de `.env.example` (copiar para `.env`)

## Setup

```bash
# 1. Subir infraestrutura local (PostgreSQL, Redis, MinIO)
docker compose up -d

# 2. Backend
cd backend
npm install
npx prisma migrate dev      # aplica migrações e cria o schema
npm run seed                # cria empresa Aceville + usuários de exemplo (1 por perfil)
npm run dev                 # API em http://localhost:3001/api/v1

# 3. Frontend (em outro terminal)
cd frontend
npm install
npm run dev                 # app em http://localhost:3000
```

## Verificações rápidas

```bash
curl http://localhost:3001/api/v1/health     # deve retornar 200
curl http://localhost:3001/metrics           # métricas Prometheus
```

## Fluxo 1 — Abertura e resolução de correção de CTe (US1, P1)

1. Login como **solicitante** (financeiro).
2. "Nova Solicitação" → tipo `reversao`, informar CTe/NF, descrição, anexar PDF → enviar.
3. **Esperado**: protocolo `SOL-2026-06-NNNN` gerado, status `novo`, solicitação na fila.
4. Login como **analista** → assumir a solicitação → status `em_andamento`.
5. Marcar `resolvido` com descrição da ação.
6. **Esperado**: solicitante notificado; histórico mostra todas as transições com autor/timestamp.

## Fluxo 2 — Troca de pagador com duplicidade e pendência de doc (US2, P2)

1. Login como **solicitante** → criar `troca_pagador` para um CTe/NF já usado nos últimos 7 dias.
2. **Esperado**: alerta de duplicidade (HTTP 409) com opção vincular/prosseguir.
3. Escolher "prosseguir" → nova solicitação criada com novo protocolo.
4. Login como **analista** → assumir → marcar `aguardando_doc`.
5. **Esperado**: SLA pausa (`sla_pausado_em` preenchido); solicitante alertado.
6. Solicitante anexa o documento → analista volta para `em_andamento` → `resolvido`.
7. **Esperado**: SLA retoma; tempo em `aguardando_doc` não conta para o SLA.

## Fluxo 3 — Escalonamento e acompanhamento gerencial (US3, P3)

1. Login como **analista** → marcar uma solicitação como `escalado`.
2. **Esperado**: supervisor recebe notificação.
3. Login como **supervisor** → alterar prioridade para `urgente` (um não-supervisor recebe 403).
4. Reatribuir a um analista sênior → analista sênior resolve.
5. Abrir **Dashboard Gerencial** → ver KPIs (tempo médio, por status, por analista) e gerar relatório.

## Testes automatizados

```bash
# Backend
cd backend
npm run test:unit          # Jest — protocolo, status, duplicidade, SLA
npm run test:integration   # Supertest + Testcontainers — endpoints, RBAC, cross-tenant
npm run test:coverage      # deve atingir >= 75%

# E2E (raiz ou frontend)
npm run test:e2e           # Playwright — os 3 fluxos acima (1 feliz + 1 exceção por fluxo)
```

**Critério de aceite do quickstart**: os três fluxos passam manualmente e a suíte automatizada
fica verde com cobertura ≥ 75% backend / ≥ 25% frontend, incluindo o cenário cross-tenant
(empresa A não acessa dados da empresa B).
