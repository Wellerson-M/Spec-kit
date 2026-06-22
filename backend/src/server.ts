import { criarApp } from "./app";

const port = Number(process.env.PORT ?? 3001);
const app = criarApp();

app.listen(port, () => {
  // Substituir por logger Pino (Princípio V) na implementação completa.
  console.log(`SIGOF API ouvindo em http://localhost:${port}`);
});
