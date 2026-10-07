# memory-vault-template

Plantilla de un **vault de memoria compartida entre agentes** (Claude, ChatGPT, Grok
Bots, el que venga). Los modelos no se hablan entre sí y cada uno guarda su memoria
en un silo. La estrategia que aguanta es sacar la memoria de los modelos y dejar un
solo almacén canónico en archivos, versionado en git, que todos lean al empezar y al
que escriban con reglas estrictas. **La memoria de cada producto es caché. La fuente
de verdad es el archivo.**

## Cómo usarla

1. Arriba a la derecha, **Use this template → Create a new repository**. Hacelo
   **privado**: acá va a vivir tu perfil.
   O por CLI: `gh repo create <owner>/<repo> --private --template <owner-de-esta-plantilla>/memory-vault-template --clone`
2. Clonalo y corré el bootstrap:
   ```sh
   cd <repo>
   ./bootstrap.sh
   ```
   Detecta `owner/repo` del remoto, te pregunta tu nombre y rellena los
   placeholders (OWNER, REPO, NAME y VAULT_PATH, escritos entre dobles llaves) en todos
   los archivos. Si usás Claude Code, instala la regla global en `~/.claude/rules/`.
3. Completá `PROFILE.md` y `PREFERENCES.md`. Para arrancar, pedile a cada modelo su
   memoria verbatim (rol, proyectos, preferencias, correcciones), partila en esos
   dos archivos y en `projects/`, y tirá el resto.
4. Enchufá cada cliente siguiendo `clients/`.
5. Commit y push. Borrá `bootstrap.sh` cuando termine; ya no hace falta.

## Estructura

```text
INDEX.md            # qué leer según el tipo de tarea (entrada obligatoria)
PROFILE.md          # quién sos, contexto estable. Sólo lo edita la consolidación
PREFERENCES.md      # cómo querés que te respondan. Sólo lo edita la consolidación
projects/<slug>.md  # estado, decisiones y pendientes de cada proyecto
journal/            # hechos nuevos, append-only, un archivo por bot y por día
clients/            # cómo se enchufa cada cliente (Claude Code, GPT, Grok Bots)
CONSOLIDATE.md      # checklist de la consolidación semanal
```

## Protocolo de sesión (igual para todos los bots)

**Al empezar**
1. Leer `INDEX.md`.
2. Leer `PROFILE.md` y `PREFERENCES.md`.
3. Leer el `projects/<slug>.md` del proyecto activo, si lo hay.
4. No inventar contexto que no esté en los archivos.

**Durante la sesión**
- Cuando se cierre un hecho durable (decisión, preferencia nueva, estado de un
  proyecto, corrección), agregarlo al journal del día:
  `journal/YYYY-MM-DD-<bot>.md` con `<bot>` ∈ `claude`, `gpt`, `grok`.
  Formato en `journal/README.md`.
- **Nunca** editar `PROFILE.md`, `PREFERENCES.md` ni `projects/*` desde un chat.
  Eso lo hace la consolidación.

**Qué NO va acá**
- Transcripts de chats. Se pudren. Van decisiones, preferencias y estado.
- Documentos largos. Una decisión cabe en el proyecto; un PDF no.
- Secretos, tokens, credenciales. Nunca.
- Memoria de trabajo que ya vive en el repo de un proyecto. Acá va lo que cruza
  contextos.

## Reglas contra el drift

- Un archivo de journal por bot y por día. Nadie escribe sobre lo mismo, así que
  no hay conflictos de merge y "last-write-wins" deja de ser un problema.
- Cada entrada lleva fecha, bot y fuente.
- Si dos bots discrepan, gana el archivo consolidado, no el chat más reciente.
- La consolidación es un PR: el diff se revisa antes de que todos lo lean como
  verdad. Checklist en `CONSOLIDATE.md`.
- El remoto es la fuente de verdad. Una VM, una laptop o un disco compartido son
  clones, no el origen.

## Clientes

| Cliente | Lee / escribe | Cómo |
|---|---|---|
| Claude Code | shell + git | `clients/claude-code.md` |
| Claude.ai (web / desktop) | MCP de GitHub | `clients/claude-code.md` |
| GPT custom | Action sobre la API REST de GitHub | `clients/chatgpt.md` |
| Grok Bots (VM) | shell + git | `clients/grok-bots.md` |
| Grok chat | ninguno | es caché; lo importante se baja a mano |

Cualquier otro agente con shell entra por `clients/grok-bots/sync.sh` (`BOT=<nombre>`).
Cualquier agente con acceso HTTP entra por el schema de `clients/chatgpt/openapi.yaml`.
