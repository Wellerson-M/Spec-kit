import type { Config } from "jest";

const config: Config = {
  preset: "ts-jest",
  testEnvironment: "node",
  roots: ["<rootDir>/tests"],
  collectCoverageFrom: ["src/**/*.ts"],
  coverageThreshold: {
    // Princípio I da constituição: >= 75% no backend
    global: { statements: 75, branches: 75, functions: 75, lines: 75 },
  },
};

export default config;
