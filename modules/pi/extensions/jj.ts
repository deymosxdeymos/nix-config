/**
 * JJ Extension — bans `git` in favor of `jj`.
 *
 * We use Jujutsu (jj), not git directly. This extension wraps the bash tool to:
 *   1. Prepend the intercepted-commands directory to PATH, which contains a
 *      `git` shim that errors with the jj equivalents.
 *   2. Block bare `git` invocations at spawn time via regex, closing the gap
 *      where the shim is bypassed with an explicit path (e.g. /usr/bin/git).
 *
 * `jj` subcommands such as `jj git push` and `jj git fetch` invoke the jj
 * binary (not the git binary), so they are neither shimmed nor blocked.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createBashTool } from "@earendil-works/pi-coding-agent";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const interceptedCommandsPath = join(__dirname, "..", "intercepted-commands");

function getBlockedCommandMessage(command: string): string | null {
  // Match `git` at the start of a shell segment (start/newline/;/&&/||/|),
  // optionally with a leading path (e.g. /usr/bin/git). Does not match
  // `jj git ...` because `git` there is preceded by `jj ` (no segment break).
  const gitCommandPattern = /(?:^|\n|[;|&]{1,2})\s*(?:\S+\/)?git\s*(?:$|\s)/m;

  if (gitCommandPattern.test(command)) {
    return [
      "Error: git is disabled. Use jj instead:",
      "",
      "  git add FILE      ->  jj file track FILE",
      "  git status        ->  jj st",
      "  git diff          ->  jj diff",
      "  git log           ->  jj log",
      "  git commit        ->  jj describe / jj commit",
      "  git push          ->  jj git push",
      "  git pull / fetch  ->  jj git fetch",
      "",
    ].join("\n");
  }

  return null;
}

export default function (pi: ExtensionAPI) {
  const cwd = process.cwd();
  const bashTool = createBashTool(cwd, {
    commandPrefix: `export PATH="${interceptedCommandsPath}:$PATH"`,
    spawnHook: (ctx) => {
      const blockedMessage = getBlockedCommandMessage(ctx.command);
      if (blockedMessage) {
        throw new Error(blockedMessage);
      }
      return ctx;
    },
  });

  pi.registerTool(bashTool);
}
