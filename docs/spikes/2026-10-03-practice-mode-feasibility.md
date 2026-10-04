# Practice mode feasibility spike

Date: 2026-10-03. Status: research complete; runnable proof pending. Capability G-15; open decision D-12. No implementation, installation, app execution, or container launch occurred.

## Question and conclusion

Can players create real environments inside the game, use its reference and guidance to build functional apps, and keep using those apps outside story progression?

Technically plausible. Existing Godot and Node tools provide a starting point, but the inspected game does not yet supply this workflow. The leading recommendation for a future technical proof is one local JavaScript web app in a managed container. This preserves native Node behavior while making runtime access explicit. Container technology is a candidate, not an approved dependency or shipping requirement. Setup burden and an in-game preview could change the recommendation.

The user accepted basic coders who struggle with program structure as the initial audience. Introductory lessons wait for a core-game baseline ([ADR 0011](../decisions/0011-initial-audience-and-deferred-beginner-lessons.md)). Practice exploration is authorized by [ADR 0012](../decisions/0012-explore-optional-practice-mode.md), which accepts no backend.

## What an environment means

A project folder organizes source. A runtime/package environment fixes interpreter and library versions; Python's `venv` supplies package separation, not a separate operating system. A container can restrict filesystem, process, and network access through a configured boundary. A full VM runs a separate guest operating system and needs its own distribution/integration evaluation. These are different promises. The user's first desired app type should determine which is necessary. [Python venv documentation](https://docs.python.org/3/library/venv.html), [Docker isolation documentation](https://docs.docker.com/engine/security/).

Persist the player's source and intended application data independently of replaceable environments. Rebuilding a runtime should recover a project from its saved files and version information, rather than treating the live runtime as the only copy.

## Inspected starting point

- [Workstation source](../../godot/scripts/main.gd): one editable `src/discounts.js`; fixed incident actions; no file creation or test editing. Startup calls `_ensure_sandbox(true)`, and reset recursively removes the incident copy. Practice cannot share that reset location.
- `_run_runner` calls synchronous `OS.execute`. A web server running until stopped would occupy the current path indefinitely. No owned process lifecycle, stop action, streamed logs, or app preview exists.
- [Node runner](../../godot/tools/level_runner.mjs): `spawnSync` for tests/replay, incident `cwd`, and inherited host environment. This runs real code with host access; changing directories does not confine it.
- Current commands save incident drafts, affect scoring, and emit surveillance actions. Practice needs an explicit boundary from story state.
- Godot supports independent processes and redirected, nonblocking I/O. Its documented process APIs do not automatically terminate launched processes when Godot exits; cleanup must be proved. These APIs make an execution bridge plausible, not already implemented. [Godot OS reference](https://docs.godotengine.org/en/stable/classes/class_os.html).
- Read-only tool inspection found Node, Python, WSL, and Docker executables. `docker version --format '{{json .}}'` returned client `29.6.2`, context `desktop-linux`, no server, and a missing engine pipe. No daemon was started. This is an execution limitation, not evidence against container feasibility.

## Three approaches

| Approach | What it offers | Tradeoffs and outstanding evidence |
| --- | --- | --- |
| Local container, leading technical-proof candidate | Real native Node apps, a versioned environment, persistent project storage, and configurable execution limits. | New runtime/setup and distribution decisions; Windows virtualization requirements; preview and shutdown integration. A container is not a full VM or an automatic guarantee of confinement. |
| Browser Node runtime, such as WebContainers | Real Node applications running inside a browser runtime, including a virtual filesystem and application preview. | Requires a browser integration; cross-origin isolation; JavaScript/WebAssembly rather than arbitrary native binaries; licensing and offline boot need review. |
| Existing host Node process | Least change to current execution; native Node behavior. | No OS confinement from the project folder; inherits host access unless separately restricted. Useful only if an explicit host-execution trust model is chosen. It does not satisfy an isolated-environment promise by itself. |

Docker's Windows setup has OS/virtualization requirements and conditional subscription terms. Containers have no CPU/memory limits by default; limits must be configured and measured. Keep installation/provisioning out of the current research. [Docker Windows setup](https://docs.docker.com/desktop/setup/install/windows-install/), [resource constraints](https://docs.docker.com/engine/containers/resource_constraints/).

WebContainers execute Node in a browser; their quickstart requires cross-origin isolation. Native addons are unavailable unless adapted to WebAssembly. Commercial for-profit production use requires a license; prototypes/POCs are exempt under the published guidance. Offline operation has not been established for this game. [Introduction](https://webcontainers.io/guides/introduction), [quickstart](https://webcontainers.io/guides/quickstart), [runtime limitations](https://webcontainers.io/guides/troubleshooting), [commercial usage](https://webcontainers.io/enterprise).

The current native Godot build has no browser integration. Godot's `JavaScriptBridge` exists only for Web exports, so it cannot supply browser execution or embedding here. An external browser can prove an app runs, but the desired in-game preview needs separate integration evidence and potentially a new dependency. [Godot JavaScriptBridge](https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html).

Full guest desktops, cloud machines, arbitrary languages, databases, native desktop apps, public hosting, and arbitrary package installation are not needed for the proposed first proof. Reconsider them only if the chosen practice scope requires them.

## Proposed first player workflow

Enter a quiet practice workspace outside the story. Create a JavaScript project with a visible runtime version. Use a small file list, editable source/tests, neutral reference, optional construction prompts, test output, run/stop controls, and an app preview. Start with built-in Node facilities, HTML, and ordinary browser JavaScript; the proof needs no external app framework.

Candidate app: a task tracker. Players add tasks, mark them complete, save them, and recover them after restart. They choose responsibility boundaries between task behavior, storage, and presentation. Later add due dates and explain what changed. This checks construction and transfer through observable behavior, without prescribing module names or architecture. Exact exercise remains proposed.

Document scope matters: references explain supported APIs and versions; they cannot make every library available. Guidance should support reasoning. The current authored hint ladder cannot answer arbitrary questions about arbitrary apps. General conversational assistance would be a separate product/provider/offline decision; no AI integration is implied. Practice's help/credits remain open. If it uses Dantalion credits, investigation remains their prerequisite until explicitly revised.

Proposed separation: no incident clock, Joel sanctions, story score, or practice-completion escape gate. Project storage and application data survive story resets and the fictional IT wipe. Exact policies need approval; do not silently inherit story mechanics.

## Future runnable proof and exit criteria

Resolve app type and runtime before writing the proof. A minimal console diagnostic may test launch mechanics, but it cannot establish the complete web-app workflow.

1. Create one supported environment/project and confirm the actual runtime version. Build one small app and a behavior test; observe a failing assertion and then a passing result.
2. Start the real app without freezing Godot. Read output and interact with its preview. Separate a working external-browser diagnostic from a working in-game preview.
3. Stop/restart the owned app; recover from a supported crash or infinite loop. Show failures without losing source. Prove shutdown cleanup instead of merely terminating the launcher PID.
4. Close/reopen practice; retain source and intended app data. Reset the story and prove practice remains separate. Rebuild the environment from the saved project/version information.
5. Test the selected isolation promise with controlled fixtures: attempts to access an outside sentinel, another project's files, host credentials/environment, and unapproved networking. Restrict resources and prove the chosen local preview still works. These checks evaluate a configured boundary, not perfect security.
6. Test an offline cold start after approved provisioning. Record actual download/install needs, runtime size, startup time, memory/disk use, logs, limits, and setup friction. No measurements exist yet.
7. Introduce the changed requirement and observe the player's reasoning. Record setup failures separately from construction-learning difficulty before deciding whether to ship or revise the approach.

For a container candidate, use a trusted fixed launch profile: project-only writable storage, no host home/root/daemon mounts, minimal capabilities, nonprivileged execution, a narrow environment, and resource limits. Player code must not control container launch privileges. Local preview ports must be deliberately bound to loopback; restricting egress and preserving preview require a combined proof. A network-disabled container alone does not prove host HTTP preview. [Docker security](https://docs.docker.com/engine/security/), [port publishing](https://docs.docker.com/engine/network/port-publishing/).

No pass/fail runtime claims or performance estimates are made by this research. Approve any necessary new dependency/architecture before implementation, following AGENTS.md. The first unresolved question is whether to support JavaScript web apps first or a broader general-purpose environment.
