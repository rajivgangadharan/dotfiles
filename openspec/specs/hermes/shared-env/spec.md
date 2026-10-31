# Hermes Shared Env Specification

## Purpose

Allows hermes profiles to share a common set of API keys from a single file, so that adding or rotating a key requires editing one file rather than one file per profile.

## Requirements

### Requirement: Shared env file is the single source of truth for common keys
The system SHALL load API keys from `~/.hermes/shared.env` at startup for every profile. Any key present in `shared.env` SHALL be available to hermes without being duplicated in individual profile `.env` files.

#### Scenario: Common key available in profile that has no copy of it
- **WHEN** a profile's own `.env` does not contain `OPENROUTER_API_KEY`
- **AND** `~/.hermes/shared.env` contains `OPENROUTER_API_KEY=sk-or-v1-...`
- **THEN** hermes resolves `OPENROUTER_API_KEY` from `shared.env` and the key is available at runtime

#### Scenario: New key added to shared.env is immediately available to all profiles
- **WHEN** a new key is appended to `~/.hermes/shared.env`
- **THEN** every profile sees the new key on next startup without any per-profile edit

### Requirement: Profile-specific keys take precedence over shared keys
The system SHALL NOT override a key that is already set in the profile's own `.env` with the value from `shared.env`. The profile `.env` is the higher-precedence source.

#### Scenario: Profile has a different Kite API key than shared.env would provide
- **WHEN** a profile's `.env` contains `KITE_API_KEY=<profile-specific-value>`
- **AND** `~/.hermes/shared.env` also contains a `KITE_API_KEY` entry
- **THEN** hermes uses the profile `.env` value, not the shared value

#### Scenario: Profile .env is empty or minimal
- **WHEN** a profile's `.env` contains no keys
- **THEN** hermes uses all values from `shared.env`

### Requirement: Shared env loading is non-interactive and fast
The mechanism that reads `shared.env` SHALL complete within 3 seconds, SHALL NOT prompt for user input, and SHALL NOT block hermes startup if the file is absent or unreadable.

#### Scenario: shared.env is missing at startup
- **WHEN** `~/.hermes/shared.env` does not exist
- **THEN** hermes starts normally, logs a warning, and the profile's own `.env` values remain in effect

#### Scenario: shared.env is present and readable
- **WHEN** `~/.hermes/shared.env` exists and is a valid `KEY=VALUE` file
- **THEN** hermes injects the shared keys before any tool or model call, within the 3-second startup budget

### Requirement: shared.env is excluded from version control
The file `~/.hermes/shared.env` SHALL be excluded from git tracking. It SHALL never appear in `git status` as a file to be committed.

#### Scenario: shared.env is created on a tracked dotfiles repo
- **WHEN** `~/.hermes/shared.env` is created
- **THEN** `git status` in the dotfiles repo does not show it as untracked or modified
