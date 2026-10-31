# Tasks

## 1. Build shared.env

- [x] 1.1 Extract all keys common to every profile from the existing `~/.hermes/.env` into a new `~/.hermes/shared.env` — include every key whose value is identical (or whose value should be shared) across profiles; verify the file exists and contains at least the OpenRouter, Groq, HuggingFace, Cohere, Sarvam, LlamaCloud, Tavily, LangSmith, Qdrant Cloud, Perplexity, Modal, Telegram, GitHub PAT, and infrastructure config keys
- [x] 1.2 Fix the corrupted `REDIS_PORT=6379mu0pph4gfmm81f6g` line in `~/.hermes/.env` so it reads `REDIS_PORT=6379`; verify with `grep REDIS_PORT ~/.hermes/.env`
- [x] 1.3 Confirm `shared.env` is covered by `.gitignore` — run `git -C ~/dotfiles check-ignore -v ~/.hermes/shared.env` and verify it matches a rule (the existing `*` catch-all in `hermes/.hermes/.gitignore` should cover it; if not, add an explicit entry)

## 2. Reduce profile .env files to overrides only

- [x] 2.1 For each of the following profiles — `stocks`, `socrates`, `statisys`, `invest`, `ensemblehp` — replace the profile's `.env` with only the profile-specific keys: `KITE_API_KEY`, `KITE_API_SECRET`, `MCP_KITE_API_KEY` (using the `5qookbi0uyzt3pf7` credentials, not the main `.env` set); verify each profile `.env` is ≤ 10 lines
- [x] 2.2 Add `PERPLEXITY_API_KEY` to the `socrates` profile `.env` (its unique key not shared with others); verify it is present with `grep PERPLEXITY ~/.hermes/profiles/socrates/.env`
- [x] 2.3 For `ham` and `echoesofinsight`, audit what keys they actually need and reduce their `.env` files to only profile-specific overrides (or leave them empty if all keys come from `shared.env`); verify each starts hermes without missing-key errors

## 3. Wire the command secret source into each profile

- [x] 3.1 For each profile that has a `config.yaml` (`stocks`, `socrates`, `statisys`, `invest`, `ensemblehp`, `ham`, `echoesofinsight`) add the following block under the existing `secrets:` section (create the section if absent):
  ```yaml
  secrets:
    command:
      enabled: true
      command: "cat $HOME/.hermes/shared.env"
  ```
  Verify the block is present in each profile's `config.yaml` with `grep -A3 'secrets:' ~/.hermes/profiles/<name>/config.yaml`
- [x] 3.2 Confirm `override_existing` is NOT set (or explicitly `false`) in each command block — the default ensures profile `.env` values win over `shared.env` values; verify with `grep override_existing ~/.hermes/profiles/*/config.yaml` (should return nothing or `false` lines only)

## 4. Verify end-to-end per profile

- [x] 4.1 Start hermes in the `stocks` profile and confirm `OPENROUTER_API_KEY` resolves (e.g. `hermes --profile stocks run "echo $OPENROUTER_API_KEY"` or equivalent); confirm `KITE_API_KEY` is the profile-specific value `5qookbi0uyzt3pf7`, not the one in `shared.env`
- [x] 4.2 Start hermes in the `socrates` profile and confirm both `OPENROUTER_API_KEY` (from shared) and `PERPLEXITY_API_KEY` (from profile override) resolve correctly
- [x] 4.3 Verify that removing a key from `shared.env` and restarting any profile causes that key to be unavailable (regression guard for the single-source-of-truth requirement)

## 5. Add sync validation script

- [x] 5.1 Create `~/.hermes/scripts/check-shared-env.sh` — a script that reads `shared.env` and for each key checks whether any profile `.env` still duplicates it (prints a warning if so); verify it runs without error and produces no warnings for the fully migrated state: `bash ~/.hermes/scripts/check-shared-env.sh`
- [x] 5.2 Confirm the script itself is covered by the hermes `.gitignore` allowlist (`!scripts/**`) so it will be tracked when the dotfiles repo is stowed; verify with `git -C ~/dotfiles check-ignore -v hermes/.hermes/scripts/check-shared-env.sh` — it should NOT be ignored
