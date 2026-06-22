// Cálculo de SLA com pausa em "aguardando_doc" (FR-015, fluxo 2 do RFC seção 3.3).
// O tempo decorrido em "aguardando_doc" não conta. Modelamos o SLA como segundos restantes
// a partir de um limite inicial (default 4h), descontando os períodos pausados.

const HORA_EM_SEGUNDOS = 3600;

export function slaInicialSegundos(horas = 4): number {
  return horas * HORA_EM_SEGUNDOS;
}

// Segundos de SLA já consumidos = tempo total decorrido - tempo acumulado pausado.
export function segundosConsumidos(
  criadoEm: Date,
  agora: Date,
  segundosPausados: number
): number {
  const decorrido = Math.floor((agora.getTime() - criadoEm.getTime()) / 1000);
  return Math.max(0, decorrido - segundosPausados);
}

// Segundos restantes de SLA (pode ser negativo se estourado).
export function segundosRestantes(
  criadoEm: Date,
  agora: Date,
  segundosPausados: number,
  horas = 4
): number {
  return slaInicialSegundos(horas) - segundosConsumidos(criadoEm, agora, segundosPausados);
}

export function slaEstourado(
  criadoEm: Date,
  agora: Date,
  segundosPausados: number,
  horas = 4
): boolean {
  return segundosRestantes(criadoEm, agora, segundosPausados, horas) < 0;
}

// Ao retomar de uma pausa, acumula os segundos que ficaram pausados.
export function acumularPausa(
  segundosPausadosAtual: number,
  pausadoEm: Date,
  retomadoEm: Date
): number {
  const pausa = Math.floor((retomadoEm.getTime() - pausadoEm.getTime()) / 1000);
  return segundosPausadosAtual + Math.max(0, pausa);
}
