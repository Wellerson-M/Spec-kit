// Geração de protocolo SOL-AAAA-MM-NNNN (RF03, Princípio III — imutável/auditável).
// A função é pura: recebe a data e o próximo sequencial mensal (resolvido atomicamente
// pelo repositório, ex.: contador por empresa/ano/mês com transação) e formata o protocolo.

export function formatarProtocolo(data: Date, sequencialMensal: number): string {
  if (!Number.isInteger(sequencialMensal) || sequencialMensal < 1) {
    throw new Error("Sequencial do protocolo deve ser inteiro >= 1");
  }
  if (sequencialMensal > 9999) {
    throw new Error("Sequencial mensal excede o limite de 9999");
  }
  const ano = data.getUTCFullYear().toString().padStart(4, "0");
  const mes = (data.getUTCMonth() + 1).toString().padStart(2, "0");
  const seq = sequencialMensal.toString().padStart(4, "0");
  return `SOL-${ano}-${mes}-${seq}`;
}

export const PROTOCOLO_REGEX = /^SOL-\d{4}-\d{2}-\d{4}$/;

export function isProtocoloValido(protocolo: string): boolean {
  return PROTOCOLO_REGEX.test(protocolo);
}
