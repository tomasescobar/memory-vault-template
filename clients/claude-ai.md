# Claude.ai (app de escritorio y web)

Claude.ai no tiene shell. Lee y escribe el vault por el **conector MCP de GitHub** y las
instrucciones viven en un **Project** de Claude.ai. La memoria nativa de Claude.ai sigue
existiendo: es caché, el vault gana.

## Setup (una vez)

1. **Conector de GitHub.** Settings → Connectors → *Add custom connector*:
   - Name: `GitHub`
   - URL: `https://api.githubcopilot.com/mcp/`
   - Autorizar con OAuth con la cuenta `{{OWNER}}`. Es el servidor MCP remoto oficial de
     GitHub; expone `get_file_contents`, `create_or_update_file` y `push_files`.
   - Los conectores custom requieren plan Pro, Max o Team.
2. **Project.** Crear un Project (p. ej. "{{NAME}}") y en *Instructions* pegar
   `clients/claude-ai/instructions.md`. Activar el conector de GitHub en ese Project.
3. **Probar.** En un chat del Project: "¿qué dice mi PROFILE?" debe leer el archivo del repo.
   "Anotá que X" debe crear o actualizar `journal/<hoy>-claude.md`.
4. **Memoria nativa.** Dejarla encendida está bien; las instrucciones dicen que el vault gana.
   Si molesta que repita cosas viejas, Settings → Memory → limpiar.

## Fallback de sólo lectura

Si no querés un conector custom: Project → *Add content* → *GitHub* sincroniza el repo como
conocimiento del Project. Es de sólo lectura y hay que re-sincronizar a mano después de cada
consolidación. Sirve para leer; para escribir al journal hace falta el conector.

## Nota

Las conversaciones fuera del Project no ven el vault. Hablar siempre dentro del Project, o
poner las mismas instrucciones en Settings → Profile → *Personal preferences* (más corto, sin
el flujo de escritura).
