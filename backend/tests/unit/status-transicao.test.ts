import {
  isTransicaoValida,
  aplicarTransicao,
  isEstadoFinal,
  TransicaoInvalidaError,
} from "../../src/services/statusService";

describe("statusService — máquina de estados", () => {
  it("permite novo -> em_andamento (assumir)", () => {
    expect(isTransicaoValida("novo", "em_andamento")).toBe(true);
  });

  it("permite em_andamento -> aguardando_doc e volta", () => {
    expect(isTransicaoValida("em_andamento", "aguardando_doc")).toBe(true);
    expect(isTransicaoValida("aguardando_doc", "em_andamento")).toBe(true);
  });

  it("permite em_andamento -> escalado -> em_andamento", () => {
    expect(isTransicaoValida("em_andamento", "escalado")).toBe(true);
    expect(isTransicaoValida("escalado", "em_andamento")).toBe(true);
  });

  it("permite em_andamento -> resolvido", () => {
    expect(isTransicaoValida("em_andamento", "resolvido")).toBe(true);
  });

  it("rejeita pular de novo direto para resolvido", () => {
    expect(isTransicaoValida("novo", "resolvido")).toBe(false);
  });

  it("trata resolvido e cancelado como estados finais", () => {
    expect(isEstadoFinal("resolvido")).toBe(true);
    expect(isEstadoFinal("cancelado")).toBe(true);
    expect(isEstadoFinal("novo")).toBe(false);
  });

  it("não permite sair de um estado final", () => {
    expect(isTransicaoValida("resolvido", "em_andamento")).toBe(false);
  });

  it("aplicarTransicao lança em transição inválida", () => {
    expect(() => aplicarTransicao("novo", "resolvido")).toThrow(
      TransicaoInvalidaError
    );
  });
});
