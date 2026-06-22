// Middleware de isolamento multi-tenant (Princípio II da constituição).
// O empresa_id é SEMPRE derivado do JWT da sessão — NUNCA de um parâmetro do cliente.
import { Request, Response, NextFunction } from "express";

export interface TenantRequest extends Request {
  auth?: { usuarioId: string; empresaId: string; perfil: string };
}

export function tenantMiddleware(
  req: TenantRequest,
  res: Response,
  next: NextFunction
): void {
  if (!req.auth?.empresaId) {
    res.status(401).json({ erro: "Empresa não identificada na sessão" });
    return;
  }
  // A partir daqui, todos os repositórios devem filtrar por req.auth.empresaId.
  // (Ex.: prisma.solicitacao.findMany({ where: { empresaId: req.auth.empresaId } }))
  next();
}
