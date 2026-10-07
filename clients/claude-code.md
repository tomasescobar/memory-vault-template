# Claude Code y Claude.ai

## Claude Code (CLI / desktop)

Tiene shell y git, así que el clon local es el enganche.

- Clon: `{{VAULT_PATH}}`.
- Regla global: `~/.claude/rules/memory-vault.md` (copia de `clients/claude-code/memory-vault.md`, la instala `bootstrap.sh`). Se carga en todas las sesiones y
  le dice a Claude que lea `INDEX.md`, `PROFILE.md` y `PREFERENCES.md` al arrancar,
  y que escriba hechos durables en `journal/YYYY-MM-DD-claude.md`.
- La memoria de proyecto de Claude Code (`~/.claude/projects/<repo>/memory/`) sigue
  siendo la memoria **por repo**. El vault es lo que cruza repos.

Sync: la regla hace `git pull --rebase` antes de leer y `git push` después de
escribir al journal. Si el push falla por red, el commit queda local y sube la
próxima vez.

## Claude.ai (web / desktop)

Ver `clients/claude-ai.md`.
