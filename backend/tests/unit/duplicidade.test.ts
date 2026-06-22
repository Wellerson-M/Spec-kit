import {
  detectarDuplicidade,
  SolicitacaoComparavel,
} from "../../src/services/duplicidadeService";

const agora = new Date(Date.UTC(2026, 5, 22, 12, 0, 0));

function dias(n: number): Date {
  return new Date(agora.getTime() - n * 24 * 60 * 60 * 1000);
}

describe("duplicidadeService", () => {
  const existentes: SolicitacaoComparavel[] = [
    { cte: "CTE-1", nf: "NF-1", criadoEm: dias(3), protocolo: "SOL-2026-06-0001" },
    { cte: "CTE-2", nf: "NF-2", criadoEm: dias(10), protocolo: "SOL-2026-06-0002" },
  ];

  it("detecta duplicidade do mesmo CTe/NF dentro de 7 dias", () => {
    const r = detectarDuplicidade({ cte: "CTE-1", nf: "NF-1" }, existentes, agora);
    expect(r.duplicada).toBe(true);
    expect(r.protocoloExistente).toBe("SOL-2026-06-0001");
  });

  it("não alerta para CTe/NF fora da janela de 7 dias", () => {
    const r = detectarDuplicidade({ cte: "CTE-2", nf: "NF-2" }, existentes, agora);
    expect(r.duplicada).toBe(false);
  });

  it("não alerta quando NF é diferente", () => {
    const r = detectarDuplicidade({ cte: "CTE-1", nf: "OUTRA" }, existentes, agora);
    expect(r.duplicada).toBe(false);
  });

  it("não alerta quando não há solicitações anteriores", () => {
    const r = detectarDuplicidade({ cte: "CTE-9", nf: "NF-9" }, [], agora);
    expect(r.duplicada).toBe(false);
  });
});
