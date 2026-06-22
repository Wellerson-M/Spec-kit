import {
  slaInicialSegundos,
  segundosConsumidos,
  segundosRestantes,
  slaEstourado,
  acumularPausa,
} from "../../src/services/slaService";

describe("slaService", () => {
  const criadoEm = new Date(Date.UTC(2026, 5, 22, 8, 0, 0));

  it("SLA inicial padrão é 4 horas", () => {
    expect(slaInicialSegundos()).toBe(4 * 3600);
  });

  it("consome SLA conforme o tempo decorrido (sem pausa)", () => {
    const agora = new Date(criadoEm.getTime() + 1 * 3600 * 1000); // +1h
    expect(segundosConsumidos(criadoEm, agora, 0)).toBe(3600);
  });

  it("não conta o tempo pausado no consumo", () => {
    const agora = new Date(criadoEm.getTime() + 3 * 3600 * 1000); // +3h
    const pausados = 2 * 3600; // 2h pausadas
    expect(segundosConsumidos(criadoEm, agora, pausados)).toBe(3600); // só 1h conta
  });

  it("calcula segundos restantes descontando pausa", () => {
    const agora = new Date(criadoEm.getTime() + 3 * 3600 * 1000);
    const pausados = 2 * 3600;
    expect(segundosRestantes(criadoEm, agora, pausados)).toBe(3 * 3600); // 4h - 1h
  });

  it("detecta SLA estourado", () => {
    const agora = new Date(criadoEm.getTime() + 5 * 3600 * 1000); // +5h, sem pausa
    expect(slaEstourado(criadoEm, agora, 0)).toBe(true);
  });

  it("não estoura se a pausa compensa o tempo decorrido", () => {
    const agora = new Date(criadoEm.getTime() + 5 * 3600 * 1000);
    const pausados = 2 * 3600; // 2h pausadas -> só 3h contam
    expect(slaEstourado(criadoEm, agora, pausados)).toBe(false);
  });

  it("acumula corretamente o tempo de uma pausa", () => {
    const pausadoEm = new Date(criadoEm.getTime() + 1 * 3600 * 1000);
    const retomadoEm = new Date(pausadoEm.getTime() + 2 * 3600 * 1000);
    expect(acumularPausa(0, pausadoEm, retomadoEm)).toBe(2 * 3600);
    expect(acumularPausa(3600, pausadoEm, retomadoEm)).toBe(3 * 3600);
  });
});
