// Detecção de duplicidade de solicitação (RF09): mesmo CTe/NF em até 7 dias, por empresa.
// A função é pura: recebe as solicitações candidatas (já filtradas por empresa pelo repositório)
// e a janela em dias, e decide se há duplicidade.

export interface SolicitacaoComparavel {
  cte: string;
  nf?: string | null;
  criadoEm: Date;
  protocolo: string;
}

export interface ResultadoDuplicidade {
  duplicada: boolean;
  protocoloExistente?: string;
}

export function detectarDuplicidade(
  nova: { cte: string; nf?: string | null },
  existentes: SolicitacaoComparavel[],
  agora: Date,
  janelaDias = 7
): ResultadoDuplicidade {
  const janelaMs = janelaDias * 24 * 60 * 60 * 1000;
  const candidata = existentes
    .filter((s) => s.cte === nova.cte && (s.nf ?? null) === (nova.nf ?? null))
    .filter((s) => agora.getTime() - s.criadoEm.getTime() <= janelaMs)
    .sort((a, b) => b.criadoEm.getTime() - a.criadoEm.getTime())[0];

  if (candidata) {
    return { duplicada: true, protocoloExistente: candidata.protocolo };
  }
  return { duplicada: false };
}
