# memory-vault (memoria entre agentes)

`{{VAULT_PATH}}` es el clon del repo privado `{{OWNER}}/{{REPO}}`:
la memoria canónica de {{NAME}} que comparten Claude, el GPT custom y los Grok Bots.
Es distinta de la memoria por proyecto de Claude Code (`~/.claude/projects/*/memory/`),
que sigue siendo el lugar para lo que es específico de un repo.

**Al empezar una sesión**, si el clon existe:
1. `git -C {{VAULT_PATH}} pull --rebase --quiet` (si falla por red, seguir con lo local).
2. Leer `INDEX.md`, `PROFILE.md` y `PREFERENCES.md`. Son cortos.
3. Si la tarea es sobre un proyecto listado en INDEX, leer `projects/<slug>.md`.

**Durante la sesión**, cuando se cierre un hecho durable que cruza proyectos
(una preferencia nueva, una corrección sobre cómo trabajar, una decisión personal,
el estado de un proyecto del vault), agregarlo al final de
`journal/YYYY-MM-DD-claude.md` con el formato de `journal/README.md`, y hacer
`git add` + `git commit -m "journal(claude): <resumen>"` + `git push`. El journal
está exento de la regla de confirmar antes de commitear: es append-only y por bot/día.
Si el hecho es específico de un repo, va a la memoria de proyecto, no al vault.

**Nunca** editar `PROFILE.md`, `PREFERENCES.md`, `INDEX.md` ni `projects/*` desde
una sesión. Eso lo hace la consolidación (`CONSOLIDATE.md`), por PR, cuando {{NAME}}
la pide. Si el vault y una memoria de producto se contradicen, gana el vault.
