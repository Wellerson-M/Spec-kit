// Tipos de domínio compartilhados (espelham os enums do Prisma).

export type Status =
  | "novo"
  | "em_andamento"
  | "aguardando_doc"
  | "escalado"
  | "resolvido"
  | "cancelado";

export type Prioridade = "baixa" | "media" | "alta" | "urgente";

export type Perfil = "solicitante" | "analista" | "supervisor" | "admin";

export type TipoOcorrencia =
  | "reversao"
  | "troca_pagador"
  | "ajuste_fiscal"
  | "outro";
