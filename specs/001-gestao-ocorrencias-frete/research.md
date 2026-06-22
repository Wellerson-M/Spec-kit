# Phase 0 — Research: SIGOF

Consolidação das decisões técnicas. Cada item segue o formato Decision / Rationale /
Alternatives considered. A stack é majoritariamente fixada pelo RFC (seção 5.4) e pela
constituição (Section 2); a pesquisa documenta o *porquê* e resolve os pontos em aberto.

## D1 — Linguagem única (TypeScript) no front e back

- **Decision**: TypeScript em modo `strict` no backend (Node.js + Express) e no frontend (Next.js).
- **Rationale**: Reduz troca de contexto, compartilha tipos/validações e dá tipagem estática como
  primeira barreira de erros (Princípio I). Node é forte para APIs REST I/O-bound como tickets.
- **Alternatives considered**: Backend em Python/Django ou Java/Spring — rejeitados por aumentar a
  diversidade de stack em um projeto individual e divergir do RFC.

## D2 — PostgreSQL + Prisma ORM

- **Decision**: PostgreSQL como banco relacional; Prisma como ORM e Prisma Migrate para migrações.
- **Rationale**: Os dados (solicitações, usuários, histórico) são fortemente relacionais e exigem
  integridade referencial e auditoria. Prisma dá queries parametrizadas (anti-SQLi, OWASP) e
  migrações versionadas aplicadas no deploy.
- **Alternatives considered**: MongoDB — rejeitado pela natureza relacional e necessidade de
  joins/integridade; TypeORM/Knex — Prisma oferece melhor DX e tipagem.

## D3 — Multi-tenancy: shared database, shared schema com `empresa_id`

- **Decision**: Tenant único por banco, isolamento lógico por coluna `empresa_id` em toda tabela
  de negócio; filtro injetado por middleware central a partir do JWT.
- **Rationale**: Menor custo/complexidade para o MVP (RFC seção 5.5) e permite evoluir para
  schema/banco por tenant sem reescrever a aplicação. `empresa_id` nunca vem do cliente.
- **Alternatives considered**: Schema por tenant ou banco por tenant — rejeitados por custo
  operacional desnecessário no MVP.

## D4 — Autenticação JWT + RBAC

- **Decision**: JWT stateless com claims de `usuario_id`, `empresa_id` e `perfil`; autorização
  por perfil (solicitante/analista/supervisor/admin) validada no backend.
- **Rationale**: Adequado a API REST; integra-se ao isolamento de tenant e ao RBAC (Princípios II).
  Senhas com hash forte (bcrypt/argon2), tokens com expiração.
- **Alternatives considered**: Sessão em servidor — adiciona estado e dificulta escala horizontal;
  OAuth2 externo — desnecessário para usuários internos no MVP.

## D5 — Geração de protocolo `SOL-AAAA-MM-NNNN`

- **Decision**: Protocolo composto por ano, mês e sequencial mensal por empresa, único e imutável.
- **Rationale**: Atende RF03 e o Princípio III (imutabilidade/auditoria). Sequencial por
  empresa+mês evita colisão e mantém legibilidade.
- **Alternatives considered**: UUID puro como protocolo visível — rejeitado por não ser legível
  para a equipe; sequencial global — rejeitado por vazar volume entre tenants no futuro SaaS.
- **Implementação**: transação com `SELECT ... FOR UPDATE`/contador por (empresa, ano, mês) para
  garantir atomicidade sob concorrência.

## D6 — Detecção de duplicidade (mesmo CTe/NF em 7 dias)

- **Decision**: Ao criar solicitação, consultar solicitações da mesma empresa com mesmo CTe/NF
  criadas nos últimos 7 dias; se houver, retornar alerta com opção vincular/prosseguir.
- **Rationale**: Atende RF09 e reduz duplicidade (SC-003). Janela de 7 dias conforme regra de
  negócio do RFC (seção 2.5).
- **Alternatives considered**: Bloqueio rígido de duplicidade — rejeitado porque há casos
  legítimos de reabertura; cabe ao solicitante decidir.

## D7 — SLA com pausa em "Aguardando documentação"

- **Decision**: SLA inicial de 4h (horário comercial). O tempo acumulado em "Aguardando
  documentação" não conta; ao sair do estado, a contagem retoma.
- **Rationale**: Atende FR-015 e o fluxo 2 do RFC (seção 3.3). Modelado como acúmulo de
  intervalos ativos, não como simples diferença entre criação e resolução.
- **Alternatives considered**: SLA simples (resolvido − criado) — rejeitado por penalizar o
  analista por pendências do solicitante.

## D8 — Storage de anexos desacoplado (S3/MinIO)

- **Decision**: Anexos em bucket S3-compatível, organizados por `empresa/{id}/...`, com acesso
  autenticado; banco guarda apenas metadados (nome, url, tamanho).
- **Rationale**: Mantém o banco enxuto e escala melhor (RFC seção 5.4). Prefixo por empresa
  reforça isolamento (Princípio II). Limites RF02 (10 arquivos, 5MB) validados no backend.
- **Alternatives considered**: Blobs no PostgreSQL — rejeitado por inchar o banco e prejudicar
  backups/performance.

## D9 — Observabilidade

- **Decision**: Pino (logs JSON com correlation id), Sentry (erros front/back), `/health` e
  `/metrics` para Prometheus + Grafana.
- **Rationale**: Atende Princípio V e RNF02/RNF04/RNF09; alimenta os KPIs do dashboard gerencial.
- **Alternatives considered**: `console.log` + sem tracing — rejeitado por não permitir auditar o
  ciclo de vida da solicitação nem medir SLA/disponibilidade.

## D10 — Cache com Redis

- **Decision**: Redis para acelerar consultas frequentes (fila, dashboard de KPIs).
- **Rationale**: Suporta o RNF02 (< 2s) reduzindo carga no banco. Substituível por cache em
  memória no ambiente local sem mudar a arquitetura.
- **Alternatives considered**: Sem cache no MVP — aceitável, mas a fila e o dashboard são as
  telas mais acessadas; cache reduz risco de violar o RNF02.

## D11 — CI/CD e quality gate

- **Decision**: GitHub Actions: lint+type-check → testes (unit/integração/E2E) → SonarCloud +
  `npm audit` → quality gate → build Docker → deploy (Vercel + AWS/Render) → migrações + health.
- **Rationale**: Atende Section 3 da constituição e RFC seção 5.9. Merge na `main` bloqueado se
  cobertura < 75%/25% ou se a qualidade regredir.
- **Alternatives considered**: Deploy manual — rejeitado por contrariar a entrega contínua exigida
  pela linha Web Apps.

## Pontos resolvidos (sem NEEDS CLARIFICATION pendentes)

Todos os itens de Technical Context foram resolvidos pela combinação RFC + constituição. Não
restam marcadores NEEDS CLARIFICATION.
