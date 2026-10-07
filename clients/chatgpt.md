# GPT custom (ChatGPT)

ChatGPT no tiene git. El GPT lee y escribe el vault por una **Action** contra la
API REST de GitHub. Sin servidor intermedio.

## Setup (una vez)

1. **PAT fine-grained** en GitHub → Settings → Developer settings → Fine-grained tokens:
   - Repository access: *Only select repositories* → `{{REPO}}`.
   - Permissions → Repository → **Contents: Read and write**. Nada más.
   - Expiración: 1 año. Anotarse la fecha en `projects/memory-vault.md`.
2. En el GPT → Configure → Actions → *Create new action*:
   - Schema: pegar `clients/chatgpt/openapi.yaml`.
   - Authentication: **API Key** · Auth type **Bearer** · pegar el PAT.
   - Privacy policy: cualquier URL propia (es obligatoria para publicar; para uso
     privado no importa).
3. En *Instructions* del GPT: pegar `clients/chatgpt/instructions.md`.
4. Probar: "¿qué dice mi PROFILE?" debe leer el archivo. "Anotá que X" debe crear o
   actualizar `journal/<hoy>-gpt.md`.

## Cómo funciona

- `listFiles` → árbol del repo (para saber qué proyectos hay).
- `readFile` → devuelve el contenido en **base64** más el `sha`. El GPT decodifica.
- `writeFile` → `PUT` con contenido en base64. Para **actualizar** un archivo hay
  que mandar el `sha` actual (el de `readFile`); para **crear** uno nuevo, no.
  Por eso el flujo de escritura siempre es: `readFile` del journal del día → si
  existe, decodificar, agregar la entrada al final, re-encodear y mandar con `sha`;
  si da 404, crear.

## Limitaciones conocidas

- Base64 lo hace el modelo. Para entradas cortas anda bien; para textos largos
  puede fallar. El journal es corto por diseño.
- Si empieza a fallar seguido, la mejora es un Worker mínimo en Cloudflare que
  acepte texto plano y haga el base64 y el `sha` por el GPT. No se arranca por ahí.
- La memoria nativa de ChatGPT sigue existiendo. Es caché. Lo que importe tiene que
  terminar en el journal.
