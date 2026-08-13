# Hooks (V1 / legacy)

The included session-start hook depends on V1 files such as `STATUS.md` and is not part of the V2 workflow. Do not install it for a new V2 product. Runtime-specific hooks are opt-in, project-local adapters; see [`docs/runtime-adapters.md`](../docs/runtime-adapters.md).

---

# Hooks

Automatisierte Event-Handler für Claude Code Sessions. Hooks injizieren Kontext oder validieren Zustände bei bestimmten Events.

## Verfügbare Hooks

### `session-start.sh` — SessionStart Hook

Wird beim Start jeder Claude Code Session ausgeführt und injiziert automatisch den richtigen Projektkontext:

- **Phase & Scope** aus STATUS.md
- **Lessons Learned** Hinweis (wenn vorhanden)
- **SoT-Register** Zusammenfassung (Anzahl verfügbarer Einträge)
- **Phase-spezifische Handoff-Hinweise** (welche Docs zuerst gelesen werden sollen)

## Installation

Kopiere die Hook-Konfiguration in die `.claude/settings.json` deines Ziel-Projekts:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "type": "command",
        "command": "sh hooks/session-start.sh"
      }
    ]
  }
}
```

## Voraussetzungen

- POSIX-kompatible Shell (sh/bash/zsh)
- Keine externen Abhängigkeiten
- `STATUS.md` im Projekt-Root (wird von Phase 1/Setup erstellt)

## Eigene Hooks erstellen

Hooks sind Shell-Scripts die JSON auf stdout ausgeben:

```json
{
  "hookEventName": "SessionStart",
  "additionalContext": "Dein injizierter Kontext hier."
}
```

Unterstützte Events:
- `SessionStart` — Wird beim Session-Start ausgeführt
- `UserPromptSubmit` — Wird vor Verarbeitung eines User-Prompts ausgeführt
- `Stop` — Wird am Ende einer Session ausgeführt
