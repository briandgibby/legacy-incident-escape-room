#!/usr/bin/env node
import { existsSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const [repoArg, commandArg] = process.argv.slice(2);
const repo = repoArg ? resolve(repoArg) : "";
const command = commandArg ?? "status";

function fail(message, code = 1) {
  console.error(message);
  process.exit(code);
}

if (!repo || !existsSync(join(repo, "package.json"))) {
  fail("Runner expected a sandbox repo path with package.json.");
}

function runNode(args) {
  return spawnSync(process.execPath, args, {
    cwd: repo,
    encoding: "utf8",
    env: { ...process.env, CI: "1" },
  });
}

function printResult(result) {
  if (result.stdout) process.stdout.write(result.stdout);
  if (result.stderr) process.stderr.write(result.stderr);
  return result.status ?? 1;
}

switch (command) {
  case "status": {
    const source = readFileSync(join(repo, "src", "discounts.js"), "utf8");
    console.log("Incident sandbox ready.");
    console.log("Editable file: src/discounts.js");
    console.log(`Current source length: ${source.length} characters`);
    console.log("Available actions: simulate, test, deploy, status");
    process.exit(0);
  }
  case "simulate": {
    process.exit(printResult(runNode(["scripts/simulate-api.js"])));
  }
  case "test": {
    process.exit(printResult(runNode(["--test"])));
  }
  case "deploy": {
    console.log("Predeploy gate: running deterministic test suite...");
    const tests = runNode(["--test"]);
    const code = printResult(tests);
    if (code !== 0) {
      console.log("\nDeploy blocked: tests do not support the fix yet.");
      process.exit(code);
    }
    console.log("\nSmoke check: replaying production checkout quote...");
    const simulation = runNode(["scripts/simulate-api.js"]);
    const simCode = printResult(simulation);
    if (simCode !== 0) {
      console.log("\nDeploy blocked: production replay still fails.");
      process.exit(simCode);
    }
    console.log("\nDeploy accepted: checkout quotes match the migrated coupon schema.");
    process.exit(0);
  }
  default:
    fail(`Unknown runner command: ${command}`);
}
