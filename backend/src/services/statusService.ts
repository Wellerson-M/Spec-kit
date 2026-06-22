// Transições de status da Solicitacao (RF06, FR-014, data-model.md — máquina de estados).
import { Status } from "../domain/types";

// Mapa de transições válidas. Exclusão NÃO existe (FR-014): só finalizar/cancelar.
const TRANSICOES: Record<Status, Status[]> = {
  novo: ["em_andamento", "cancelado"],
  em_andamento: ["aguardando_doc", "escalado", "resolvido", "cancelado"],
  aguardando_doc: ["em_andamento", "cancelado"],
  escalado: ["em_andamento", "cancelado"],
  resolvido: [], // estado final
  cancelado: [], // estado final
};

export function isTransicaoValida(de: Status, para: Status): boolean {
  return TRANSICOES[de]?.includes(para) ?? false;
}

export function isEstadoFinal(status: Status): boolean {
  return TRANSICOES[status].length === 0;
}

export class TransicaoInvalidaError extends Error {
  constructor(de: Status, para: Status) {
    super(`Transição de status inválida: ${de} -> ${para}`);
    this.name = "TransicaoInvalidaError";
  }
}

// Valida e retorna o novo status; lança se a transição for inválida.
export function aplicarTransicao(de: Status, para: Status): Status {
  if (!isTransicaoValida(de, para)) {
    throw new TransicaoInvalidaError(de, para);
  }
  return para;
}
