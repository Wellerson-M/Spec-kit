# Feature Specification: SIGOF — Gestão de Ocorrências de Frete

**Feature Branch**: `001-gestao-ocorrencias-frete`

**Created**: 2026-06-22

**Status**: Draft

**Input**: RFC v2.2 — SIGOF (Sistema Inteligente de Gestão de Ocorrências de Frete), Wellerson Meredyk

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Abrir e resolver correção de CTe (Priority: P1)

Um funcionário interno (financeiro, comercial ou operacional) identifica a necessidade de
corrigir um documento de transporte (reversão de frete, troca de pagador ou ajuste fiscal).
Em vez de enviar um e-mail solto, ele abre uma solicitação estruturada no SIGOF: informa o
tipo, CTe/NF, pagador correto, descrição e anexos. O sistema gera um protocolo único, coloca a
solicitação na fila, um analista a assume, trata e marca como resolvida, e o solicitante é
notificado a cada mudança de status. Todo o histórico fica registrado.

**Why this priority**: É o coração do produto e o MVP. Substituir o fluxo caótico de e-mails por
tickets rastreáveis é o que entrega valor imediato à Aceville; sem isso, nada mais importa.

**Independent Test**: Pode ser testada ponta a ponta criando uma solicitação como solicitante,
assumindo-a como analista e finalizando-a — verificando protocolo gerado, fila, notificações e
histórico, sem depender das demais histórias.

**Acceptance Scenarios**:

1. **Given** um solicitante autenticado, **When** ele preenche tipo, CTe/NF, pagador correto,
   descrição e anexa comprovantes e envia, **Then** o sistema gera um protocolo único
   `SOL-AAAA-MM-NNNN`, cria a solicitação com status "Novo" e a coloca na fila.
2. **Given** uma solicitação "Novo" na fila, **When** um analista a assume, **Then** o status
   muda para "Em andamento", a solicitação fica atribuída a ele e o solicitante é notificado.
3. **Given** uma solicitação "Em andamento", **When** o analista a marca como "Resolvido" com a
   descrição da ação, **Then** o solicitante é notificado e o histórico registra a transição
   com autor e timestamp.
4. **Given** uma solicitação anexada, **When** o solicitante tenta enviar um 11º anexo ou um
   arquivo acima de 5MB, **Then** o sistema recusa e informa o limite (até 10 anexos, 5MB cada).

---

### User Story 2 - Troca de pagador com duplicidade e pendência de documentação (Priority: P2)

Um solicitante abre uma "troca de pagador" para um CTe/NF que já teve solicitação recente. O
sistema alerta a possível duplicidade e o solicitante decide vincular ou prosseguir. O analista
assume, percebe que falta documento e marca "Aguardando documentação" (o SLA pausa). O
solicitante anexa o documento, o SLA retoma e o analista conclui.

**Why this priority**: Cobre os estados de exceção (duplicidade e pausa de SLA) que dão robustez
ao fluxo e evitam o retrabalho que motivou o projeto. Depende do fluxo base (US1), por isso P2.

**Independent Test**: Pode ser testada criando duas solicitações para o mesmo CTe/NF em 7 dias
(verificando o alerta), e movendo uma solicitação para "Aguardando documentação" e de volta,
confirmando que o SLA pausa e retoma.

**Acceptance Scenarios**:

1. **Given** uma solicitação existente para um CTe/NF, **When** outra é aberta para o mesmo
   CTe/NF dentro de 7 dias, **Then** o sistema exibe alerta de duplicidade e oferece "vincular"
   ou "prosseguir".
2. **Given** o alerta de duplicidade, **When** o solicitante escolhe "prosseguir", **Then** uma
   nova solicitação com novo protocolo é criada normalmente.
3. **Given** uma solicitação "Em andamento", **When** o analista marca "Aguardando
   documentação", **Then** o status muda, o solicitante é alertado e a contagem de SLA pausa.
4. **Given** uma solicitação "Aguardando documentação", **When** o solicitante anexa o documento
   faltante, **Then** o SLA retoma e o analista pode concluir a solicitação.

---

### User Story 3 - Escalonamento e acompanhamento gerencial (Priority: P3)

Um analista não consegue resolver uma solicitação e a escala. O supervisor é notificado, ajusta
a prioridade para "Urgente", reatribui a um analista sênior que resolve. O supervisor consulta o
dashboard gerencial com KPIs e gera um relatório de desempenho.

**Why this priority**: Fecha o ciclo de gestão (priorização, reatribuição e indicadores). É
valioso, mas só faz sentido depois que o fluxo de tickets e os estados de exceção existem (P3).

**Independent Test**: Pode ser testada escalando uma solicitação, alterando prioridade como
supervisor (e confirmando que um não-supervisor não pode), reatribuindo e abrindo o dashboard de
KPIs.

**Acceptance Scenarios**:

1. **Given** uma solicitação que o analista não resolve, **When** ele a marca como "Escalado",
   **Then** o supervisor é notificado.
2. **Given** um supervisor, **When** ele altera a prioridade de uma solicitação, **Then** a
   prioridade é atualizada; **And** um usuário sem perfil de supervisor não consegue fazê-lo.
3. **Given** um supervisor no dashboard gerencial, **When** ele acessa as métricas, **Then** vê
   KPIs (tempo médio de resolução, solicitações por status, tempo médio por analista) e pode
   gerar um relatório de desempenho.

---

### Edge Cases

- **Acesso cross-tenant**: um usuário da Empresa A jamais visualiza ou age sobre solicitações da
  Empresa B, mesmo manipulando IDs nas requisições.
- **Exclusão proibida**: nenhuma solicitação pode ser excluída; somente finalizada ou cancelada.
- **Protocolo imutável**: o protocolo não muda após a criação, mesmo em edições posteriores.
- **Permissão indevida**: um solicitante não consegue assumir solicitações nem alterar
  prioridade.
- **Anexos no limite**: arquivos acima de 5MB ou além de 10 por solicitação são recusados.
- **Duplicidade fora da janela**: mesma CTe/NF após 7 dias não dispara alerta de duplicidade.
- **SLA pausado**: o tempo em "Aguardando documentação" não conta para o SLA.
- **Sessão expirada**: requisições com JWT expirado são rejeitadas e exigem novo login.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST permitir que funcionários internos autenticados criem uma
  solicitação de ocorrência de frete (tipo, CTe/NF, pagador correto, descrição). *(RF01)*
- **FR-002**: O sistema MUST permitir anexar até 10 arquivos por solicitação, 5MB cada. *(RF02)*
- **FR-003**: O sistema MUST gerar automaticamente um protocolo único e imutável por
  solicitação no formato `SOL-AAAA-MM-NNNN`. *(RF03)*
- **FR-004**: O sistema MUST permitir que usuários internos visualizem solicitações com filtros
  (status, prioridade, minha fila, busca por protocolo). *(RF04)*
- **FR-005**: O sistema MUST permitir que um usuário interno assuma uma solicitação; apenas
  usuários internos podem assumir. *(RF05)*
- **FR-006**: O sistema MUST permitir atualizar o status da solicitação seguindo as transições
  válidas (novo → em_andamento → aguardando_doc/escalado/resolvido/cancelado). *(RF06)*
- **FR-007**: O sistema MUST permitir comunicação registrada entre analista e solicitante
  interno (mensagens, com distinção entre comentário interno e visível). *(RF07)*
- **FR-008**: O sistema MUST permitir que apenas supervisores priorizem solicitações. *(RF08)*
- **FR-009**: O sistema MUST alertar quando há duplicidade de solicitação para o mesmo CTe/NF
  dentro de 7 dias, oferecendo vincular ou prosseguir. *(RF09)*
- **FR-010**: O sistema MUST registrar e exibir histórico completo com timestamp e autor de
  cada mudança de status. *(RF10)*
- **FR-011**: O sistema MUST gerar relatórios e indicadores de desempenho (KPIs). *(RF11)*
- **FR-012**: O sistema MUST suportar diferentes perfis de usuário (solicitante, analista,
  supervisor, administrador) com permissões distintas. *(RF12)*
- **FR-013**: O sistema MUST notificar o solicitante a cada mudança de status da sua
  solicitação. *(Regra de negócio)*
- **FR-014**: O sistema MUST impedir a exclusão de solicitações; elas só podem ser finalizadas
  ou canceladas. *(Regra de negócio)*
- **FR-015**: O sistema MUST pausar a contagem de SLA enquanto a solicitação estiver
  "Aguardando documentação" e retomá-la quando sair desse estado. *(Regra de negócio)*
- **FR-016**: O sistema MUST isolar dados por empresa (tenant): todo acesso é filtrado pela
  empresa do usuário autenticado, derivada da sessão e nunca de parâmetro do cliente. *(Multi-tenancy)*

### Non-Functional Requirements

- **NFR-001**: Suportar no mínimo 50 usuários simultâneos. *(RNF01)*
- **NFR-002**: Tempo de resposta < 2s para 95% das requisições. *(RNF02)*
- **NFR-003**: Autenticação segura (JWT). *(RNF03)*
- **NFR-004**: Disponibilidade ≥ 99% em horário comercial. *(RNF04)*
- **NFR-005**: Acessível via navegador web moderno e responsivo (desktop e mobile). *(RNF05, RNF08)*
- **NFR-006**: Dados sensíveis criptografados em repouso e em trânsito. *(RNF06)*
- **NFR-007**: Backup automático diário dos dados. *(RNF07)*
- **NFR-008**: Logs de operações retidos por no mínimo 12 meses. *(RNF09)*
- **NFR-009**: Código aderente ao OWASP Top 10. *(RNF10)*

### Key Entities *(include if feature involves data)*

- **Empresa**: a transportadora (tenant). Chave de isolamento multi-tenant. Atributos: razão
  social, CNPJ, ativa.
- **Usuário**: usuário interno vinculado a uma empresa. Atributos: nome, e-mail, perfil
  (solicitante/analista/supervisor/admin), área (financeiro/comercial/operacional).
- **Solicitação**: registro central da ocorrência. Atributos: protocolo, tipo, CTe, NF, pagador
  correto, descrição, status, prioridade, datas. Relaciona-se a Empresa, solicitante e
  responsável.
- **Mensagem**: comunicação dentro de uma solicitação, com distinção interna/visível.
- **Anexo**: arquivo comprobatório associado a uma solicitação.
- **StatusHistorico**: registro imutável de cada transição de status (autor + timestamp).
- **Notificacao**: aviso enviado a um usuário sobre uma solicitação.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% das solicitações ficam registradas e rastreáveis por protocolo único. *(KPI rastreabilidade)*
- **SC-002**: Redução de 40% no tempo médio de resolução (de ~3 dias para ~1,8 dia), medido
  contra a baseline coletada antes do MVP.
- **SC-003**: Redução de 95% na duplicidade de solicitações para o mesmo CTe/NF.
- **SC-004**: 90% da equipe usando o sistema regularmente após a implantação do MVP.
- **SC-005**: Um solicitante consegue abrir uma solicitação completa (com anexos) em até 3
  minutos, sem treinamento prévio.
- **SC-006**: 95% das ações dos usuários retornam resposta perceptível em menos de 2 segundos.
- **SC-007**: Zero acessos cross-tenant em testes automatizados de isolamento (empresa A nunca
  acessa dados da empresa B).
- **SC-008**: Aumento de 40% na satisfação das áreas solicitantes (financeiro e comercial) com o
  tempo de resposta.

## Assumptions

- O MVP opera para uma única transportadora (Aceville); o isolamento multi-tenant é preparado,
  mas a comercialização SaaS (planos, cobrança, onboarding self-service) está fora de escopo.
- Clientes externos não interagem com o sistema; todos os usuários são internos.
- Os tipos de ocorrência oficiais do MVP são reversão de frete, troca de pagador e ajuste
  fiscal; "avaria/extravio" em mockups são apenas ilustrativos.
- Integrações com SEFAZ, ERPs legados, WhatsApp e emissão automática de CTe estão fora de escopo.
- Os percentuais de KPI são metas estimadas; a baseline será medida formalmente antes do
  desenvolvimento e validada após a implantação, com a equipe.
- Acesso exclusivamente por navegador, em horário comercial.
- Serviços gerenciados (S3, Redis, SendGrid) podem ser substituídos por equivalentes
  locais/gratuitos (MinIO, cache em memória, Mailtrap) sem alterar a arquitetura.

## Out of Scope

- Portal de acesso para clientes externos.
- Recursos comerciais de SaaS no MVP (planos/assinaturas, cobrança automática, onboarding
  self-service, SLA contratual por plano).
- Integração com sistemas fiscais (SEFAZ).
- Automação completa de cálculos de comissão.
- Integração com WhatsApp para notificações.
- Emissão automática de CTe corrigido.
- Integração com sistemas ERP legados.
