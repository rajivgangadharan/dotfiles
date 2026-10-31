# Proposal

## Why

The same API keys are duplicated verbatim across `~/.hermes/.env` and every profile `.env` (`stocks`, `socrates`, `statisys`, `invest`, `ensemblehp`, and others), making key rotation a manual multi-file operation that is error-prone and has already produced drift (stale keys in some profiles, a corrupted `REDIS_PORT` value in the main `.env`). A single shared source of truth eliminates the duplication while preserving the small number of genuinely profile-specific overrides (Kite broker credentials per profile, Perplexity key in `socrates`).

## What Changes

- Introduce `~/.hermes/shared.env` — a single file holding all API keys common to every profile.
- Reduce each profile `.env` to only its profile-specific keys (3–4 lines instead of 230+).
- Wire a `command` secret source into each profile's `config.yaml` that reads `shared.env` at hermes startup and injects the shared keys without overriding any profile-specific values already set by the profile's own `.env`.
- Fix the corrupted `REDIS_PORT=6379mu0pph4gfmm81f6g` line in the main `.env` (Kite key was accidentally appended).
- Add a `sync-shared-env` helper script so that adding a new key to `shared.env` can be validated across profiles without manual diffing.

## Capabilities

### New Capabilities

- `hermes/shared-env`: Hermes reads common API keys from a single shared environment file at startup, injecting them into every profile without duplicating them per-profile. Profile-specific keys in the profile's own `.env` take precedence over the shared file.

### Modified Capabilities

*(none — no existing specs exist)*

## Impact

- **Files modified**: `~/.hermes/profiles/*/config.yaml` (add `command` secret source entry), `~/.hermes/profiles/*/.env` (strip shared keys, keep only profile-specific ones), `~/.hermes/.env` (fix `REDIS_PORT` corruption; becomes the canonical template / reference copy).
- **New files**: `~/.hermes/shared.env`, `~/.hermes/scripts/sync-shared-env.sh`.
- **Hermes secret source system**: Uses the existing `command` secret source plugin — no new code required in hermes itself.
- **No breaking changes**: profiles continue to start normally; shared keys are injected before hermes reads `os.environ`.
