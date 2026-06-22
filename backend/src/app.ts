// Esqueleto da API REST do SIGOF (Princípio IV — API-first em camadas).
import express, { Express, Request, Response } from "express";
import helmet from "helmet";
import cors from "cors";

export function criarApp(): Express {
  const app = express();

  app.use(helmet());
  app.use(cors({ origin: process.env.CORS_ORIGIN ?? true }));
  app.use(express.json());

  // Observabilidade (Princípio V): health check para disponibilidade (RNF04).
  app.get("/health", (_req: Request, res: Response) => {
    res.status(200).json({ status: "ok" });
  });

  // TODO: montar rotas /api/v1 (auth, solicitacoes, mensagens, anexos, relatorios)
  //       protegidas por authMiddleware + tenantMiddleware + rbac.

  return app;
}
