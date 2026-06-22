# Phase 1 — Data Model: SIGOF

Modelo de dados derivado da spec (Key Entities) e do RFC (seção 5.2). Todas as tabelas de
negócio carregam `empresa_id` (Princípio II — isolamento multi-tenant). Chaves primárias são
UUID. Timestamps em UTC.

## Entidades

### Empresa (tenant)

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| razao_social | string | obrigatório |
| cnpj | string (UK) | único, válido |
| ativa | boolean | default true |
| criado_em | timestamp | default now |

- No MVP existe apenas a Aceville. É a chave de isolamento que viabiliza a evolução SaaS.

### Usuario

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| empresa_id | uuid (FK→Empresa) | obrigatório |
| nome | string | obrigatório |
| email | string | único por empresa; formato válido |
| senha_hash | string | bcrypt/argon2; nunca exposto |
| perfil | enum | `solicitante` \| `analista` \| `supervisor` \| `admin` |
| area | enum | `financeiro` \| `comercial` \| `operacional` |
| criado_em | timestamp | default now |

- **RBAC**: o `perfil` define permissões (ver matriz abaixo).

### Solicitacao

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| empresa_id | uuid (FK→Empresa) | obrigatório |
| protocolo | string (UK) | `SOL-AAAA-MM-NNNN`, único, **imutável** |
| solicitante_id | uuid (FK→Usuario) | obrigatório |
| responsavel_id | uuid (FK→Usuario) | nulo até ser assumida |
| tipo | enum | `reversao` \| `troca_pagador` \| `ajuste_fiscal` \| `outro` |
| cte | string | obrigatório |
| nf | string | opcional |
| pagador_correto | string | obrigatório para `troca_pagador` |
| descricao | text | obrigatório |
| status | enum | `novo` \| `em_andamento` \| `aguardando_doc` \| `escalado` \| `resolvido` \| `cancelado` |
| prioridade | enum | `baixa` \| `media` \| `alta` \| `urgente` (default `media`) |
| sla_limite_em | timestamp | calculado (4h úteis a partir da criação) |
| sla_pausado_em | timestamp | nulo; preenchido ao entrar em `aguardando_doc` |
| sla_segundos_pausados | int | acumulado de tempo pausado |
| criado_em | timestamp | default now |
| resolvido_em | timestamp | preenchido ao resolver/cancelar |

- **Imutabilidade**: registro nunca é excluído; só transita para `resolvido`/`cancelado`.

### Mensagem

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| solicitacao_id | uuid (FK→Solicitacao) | obrigatório |
| autor_id | uuid (FK→Usuario) | obrigatório |
| conteudo | text | obrigatório |
| interna | boolean | true = comentário interno; false = visível ao solicitante |
| criado_em | timestamp | default now |

### Anexo

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| solicitacao_id | uuid (FK→Solicitacao) | obrigatório |
| nome_arquivo | string | obrigatório |
| url_storage | string | prefixo `empresa/{empresa_id}/...` |
| tamanho_bytes | int | ≤ 5.242.880 (5MB) |
| criado_em | timestamp | default now |

- **Limite**: máximo de 10 anexos por solicitação (RF02), validado no service.

### StatusHistorico

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| solicitacao_id | uuid (FK→Solicitacao) | obrigatório |
| autor_id | uuid (FK→Usuario) | obrigatório |
| status_anterior | enum | igual ao enum de status (nulo na criação) |
| status_novo | enum | igual ao enum de status |
| criado_em | timestamp | default now |

- Registro **append-only** (nunca atualizado/excluído) — trilha de auditoria (Princípio III).

### Notificacao

| Campo | Tipo | Regras |
|---|---|---|
| id | uuid (PK) | gerado |
| usuario_id | uuid (FK→Usuario) | destinatário |
| solicitacao_id | uuid (FK→Solicitacao) | origem |
| mensagem | string | obrigatório |
| lida | boolean | default false |
| criado_em | timestamp | default now |

## Relacionamentos

- Empresa (1) → (N) Usuario
- Empresa (1) → (N) Solicitacao
- Usuario (1) → (N) Solicitacao (como solicitante) e (N) Solicitacao (como responsável)
- Solicitacao (1) → (N) Mensagem, Anexo, StatusHistorico, Notificacao
- Usuario (1) → (N) Mensagem (autor), (N) Notificacao (destinatário)

## Máquina de estados da Solicitacao

```text
            assume (analista)
novo ───────────────────────► em_andamento
                                  │  │  │
        marca aguardando doc ◄────┘  │  └────► resolvido (com descrição da ação)
   (SLA pausa) aguardando_doc        │
        │  anexa doc / retoma        └────► escalado (notifica supervisor)
        └──────► em_andamento                 │ reatribui sênior
                                              └──► em_andamento ──► resolvido

qualquer estado não-final ──► cancelado   (nunca excluído)
```

Transições válidas:

- `novo → em_andamento` (assumir — apenas usuário interno; RF05)
- `em_andamento → aguardando_doc` (pausa SLA)
- `aguardando_doc → em_andamento` (retoma SLA)
- `em_andamento → escalado` (notifica supervisor)
- `escalado → em_andamento` (supervisor reatribui)
- `em_andamento → resolvido` (com descrição)
- `* (não-final) → cancelado`
- Exclusão: **proibida** em qualquer estado (FR-014).

## Matriz de permissões (RBAC)

| Ação | solicitante | analista | supervisor | admin |
|---|---|---|---|---|
| Criar solicitação | ✅ | ✅ | ✅ | ✅ |
| Ver minhas solicitações | ✅ | ✅ | ✅ | ✅ |
| Ver fila completa (da empresa) | — | ✅ | ✅ | ✅ |
| Assumir solicitação | — | ✅ | ✅ | — |
| Atualizar status | — | ✅ | ✅ | — |
| Alterar prioridade | — | — | ✅ | — |
| Reatribuir responsável | — | — | ✅ | — |
| Ver dashboard gerencial/relatórios | — | — | ✅ | ✅ |
| Gerenciar usuários/parâmetros | — | — | — | ✅ |

> Todas as ações são restritas à `empresa_id` do usuário autenticado (cross-tenant negado).

## Índices e restrições relevantes

- `UNIQUE(empresa_id, protocolo)` e `UNIQUE(protocolo)` — protocolo imutável.
- Índice em `(empresa_id, cte, nf, criado_em)` — detecção de duplicidade em 7 dias (RF09).
- Índice em `(empresa_id, status, prioridade)` — fila e filtros (RF04).
- `UNIQUE(empresa_id, email)` — login por empresa.
