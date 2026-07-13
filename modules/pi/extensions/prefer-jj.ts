import {
	isToolCallEventType,
	type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";

// Mutating git subcommands that have a jj equivalent. Read-only git
// (log/diff/show/status/blame), clone, checkout, switch, and fetch are
// deliberately NOT here: git is still the right tool for reading history and
// pulling down docs/reference repos.
const JJ_HINTS: Record<string, string> = {
	add: "jj file track <paths>",
	stage: "jj file track <paths>",
	commit: "jj commit / jj describe",
	rm: "jj file untrack <paths>",
	mv: "jj file move / rename",
	restore: "jj restore <paths>",
	reset: "jj restore / jj abandon",
	stash: "jj new (changes are auto-snapshotted)",
	push: "jj git push",
	pull: "jj git fetch && jj rebase",
	fetch: "jj git fetch",
	merge: "jj new <revs> (merge commit) or jj rebase",
	rebase: "jj rebase",
	"cherry-pick": "jj duplicate / jj rebase",
	revert: "jj backout",
	am: "jj git import after applying",
	apply: "apply, then let jj snapshot the change",
};

// Walk up from `dir` looking for a `.jj` directory to decide whether this
// project is jj-managed. Plain git repos are left completely alone.
function isJjRepo(dir: string): boolean {
	let current = dir;
	for (;;) {
		if (existsSync(join(current, ".jj"))) return true;
		const parent = dirname(current);
		if (parent === current) return false;
		current = parent;
	}
}

// Pull the subcommand out of each `git ...` invocation in a (possibly
// compound) shell command, skipping leading global options like `-C path`.
function gitSubcommands(command: string): string[] {
	const subs: string[] = [];
	// An optional leading `jj ` marks the jj-native `jj git ...` form (e.g.
	// `jj git push`, `jj git fetch`), which is exactly what we want callers to
	// use — never flag those. Only bare `git <sub>` invocations are considered.
	const re = /(\bjj\s+)?\bgit\s+((?:-\S+\s+)*)([a-z][a-z-]*)/g;
	let match: RegExpExecArray | null;
	while ((match = re.exec(command)) !== null) {
		if (match[1]) continue;
		subs.push(match[3]);
	}
	return subs;
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", (event, ctx) => {
		if (!isToolCallEventType("bash", event)) return;
		if (!isJjRepo(ctx.cwd)) return;

		for (const sub of gitSubcommands(event.input.command)) {
			const hint = JJ_HINTS[sub];
			if (hint) {
				return {
					block: true,
					reason: `This project is jj-managed. Prefer jj over \`git ${sub}\`: use \`${hint}\`. (Read-only git and \`git clone/checkout/fetch\` are still fine.)`,
				};
			}
		}
	});
}
