import {
  formatarProtocolo,
  isProtocoloValido,
} from "../../src/services/protocoloService";

describe("protocoloService", () => {
  it("formata protocolo no padrão SOL-AAAA-MM-NNNN", () => {
    const data = new Date(Date.UTC(2026, 5, 1)); // junho/2026
    expect(formatarProtocolo(data, 1)).toBe("SOL-2026-06-0001");
  });

  it("preenche o sequencial com zeros à esquerda", () => {
    const data = new Date(Date.UTC(2026, 0, 15)); // janeiro/2026
    expect(formatarProtocolo(data, 42)).toBe("SOL-2026-01-0042");
  });

  it("rejeita sequencial inválido (< 1)", () => {
    const data = new Date(Date.UTC(2026, 5, 1));
    expect(() => formatarProtocolo(data, 0)).toThrow();
  });

  it("rejeita sequencial acima de 9999", () => {
    const data = new Date(Date.UTC(2026, 5, 1));
    expect(() => formatarProtocolo(data, 10000)).toThrow();
  });

  it("valida o formato do protocolo", () => {
    expect(isProtocoloValido("SOL-2026-06-0001")).toBe(true);
    expect(isProtocoloValido("SOL-2026-6-1")).toBe(false);
    expect(isProtocoloValido("XPTO")).toBe(false);
  });
});
