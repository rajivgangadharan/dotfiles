# Design

## Context

See proposal.md — Why for motivation.

Hermes loads secrets in a fixed order per profile (from `hermes_cli/env_loader.py`):

1. `HERMES_HOME/.env` — profile-specific env file, `override=True`
2. External secret sources (BWS, 1Password, `command`) — applied after, with `override_existing` controlling precedence

The `command` secret source (`agent/secret_sources/command.py`) runs an arbitrary shell command once at startup with an empty `HERMES_SECRET_KEY`, parses its stdout as a `KEY=VALUE` dotenv blob, and returns the map to the orchestrator. With `override_existing: false` (the default), any key already set by the profile `.env` is left untouched — profile values win.

Each profile is isolated: `HERMES_HOME` resolves to `~/.hermes/profiles/<name>/` per profile, so every profile needs its own `secrets.command` block in its `config.yaml`.

## Goals / Non-Goals

**Goals:**
- Single file (`shared.env`) holds all common API keys
- Profile `.env` files shrink to only genuinely profile-specific keys
- No new binaries, daemons, or services required
- Profile-specific keys always win over shared keys

**Non-Goals:**
- Encryption at rest of `shared.env` (out of scope; threat model is git exposure, not filesystem access)
- Automatic key rotation (still manual; this change only reduces the number of places to update)
- Cross-machine sync of `shared.env` (local-only by design)

## Decisions

### Decision: Use `cat ~/.hermes/shared.env` as the command helper

The `command` secret source accepts any shell command that prints `KEY=VALUE` lines. `cat` of a local file is the simplest possible implementation — zero dependencies, sub-millisecond execution, well within the 3-second hard timeout.

**Alternatives considered:**

- `gpg --decrypt shared.env.gpg` / `age -d shared.env.age` — adds encryption at rest, but requires GPG/age installed and a passphrase or key available non-interactively. Out of scope for this change since the threat model is git exposure (already handled by `.gitignore`), not filesystem access.
- Symlinks — doesn't work because profiles have a real per-profile difference (Kite credentials) that needs to override shared values. Symlinks provide no layering.
- Custom secret source plugin — more correct long-term but requires hermes code changes; `command` source already ships this exact use case.

### Decision: `override_existing: false` (keep the default)

Profile `.env` is loaded before the command source. With `override_existing: false`, any key the profile `.env` already sets is left untouched when the command source runs. This gives the profile `.env` higher precedence without any extra configuration — the Kite credentials in each profile `.env` naturally win.

### Decision: `shared.env` lives at `~/.hermes/shared.env` (HERMES_HOME root)

Co-locating it with the main `.env` makes the relationship obvious. The command in `config.yaml` uses an absolute path (`$HOME/.hermes/shared.env`) so it works regardless of which profile is active.

### Decision: Fix `REDIS_PORT` corruption in main `.env` but keep the main `.env` as a reference template

The main `~/.hermes/.env` has a corruption: `REDIS_PORT=6379mu0pph4gfmm81f6g` (the Kite key was accidentally appended). Fix it. The main `.env` becomes the reference/template for what goes into `shared.env`, not directly used by named profiles (they each load their own `HERMES_HOME/.env`).

## Risks / Trade-offs

**Risk: `shared.env` file missing on a new machine** → Mitigation: the `command` source degrades gracefully (logs a warning, hermes continues). Profile `.env` still needs to contain any profile-specific keys. Document in `shared.env` header what to do on a new machine.

**Risk: A key added to `shared.env` silently shadows an intended profile-level default** → Mitigation: `override_existing: false` means the profile `.env` always wins; shared.env only fills gaps. Adding a key to `shared.env` only affects profiles whose `.env` doesn't already have it.

**Risk: Profile `config.yaml` files are managed by hermes and may be overwritten on upgrade** → Mitigation: `secrets.command` is a stable, documented config section. Hermes config upgrades use field-level merges, not full overwrites. Verify after any hermes upgrade.

**Risk: Command runs as a shell subprocess — `cat` is safe but the surface exists** → `command` is taken from `config.yaml` (user-controlled, same trust level as `.env`); the key is passed via env var, never interpolated. Risk is no different from the existing config.

## Migration Plan

1. Build `shared.env` from the common keys in the current main `.env`.
2. Fix the `REDIS_PORT` corruption in main `.env`.
3. For each profile: add `secrets.command` block to `config.yaml`, strip shared keys from the profile `.env` leaving only profile-specific keys (Kite credentials, Socrates' Perplexity key).
4. Verify: start each profile and confirm `OPENROUTER_API_KEY` etc. are available.

**Rollback**: Remove the `secrets.command` block from a profile's `config.yaml` and restore the full key set to that profile's `.env`. No data is deleted during migration — the full `.env` content can be reconstructed from `shared.env` + the profile-specific overrides.
