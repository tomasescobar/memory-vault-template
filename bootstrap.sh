#!/usr/bin/env sh
# Rellena los placeholders de la plantilla con tus datos. Correrlo una vez, en la
# raíz del repo recién creado desde el template. Idempotente: si no quedan
# placeholders no hace nada.
#
#   {{OWNER}}/{{REPO}}  → del remoto origin
#   {{NAME}}            → se pregunta
#   {{VAULT_PATH}}      → ruta de este clon (para la regla de Claude Code)
set -eu
cd "$(dirname "$0")"

remote="$(git remote get-url origin 2>/dev/null || true)"
case "$remote" in
  git@github.com:*) slug="${remote#git@github.com:}" ;;
  https://github.com/*) slug="${remote#https://github.com/}" ;;
  *) echo "No encuentro un remoto de GitHub en origin. Hacé push primero o pasá OWNER y REPO por env." >&2
     slug="${OWNER:-}/${REPO:-}" ;;
esac
slug="${slug%.git}"
OWNER="${OWNER:-${slug%%/*}}"
REPO="${REPO:-${slug##*/}}"
[ -n "$OWNER" ] && [ -n "$REPO" ] || { echo "OWNER/REPO vacíos." >&2; exit 2; }

if [ -z "${NAME:-}" ]; then
  printf '¿Tu nombre, como querés que te llamen los agentes? '
  read -r NAME
fi
VAULT_PATH="${VAULT_PATH:-$(pwd)}"
case "$VAULT_PATH" in "$HOME"/*) VAULT_PATH="~${VAULT_PATH#"$HOME"}" ;; esac

files="$(grep -rl --exclude=bootstrap.sh --exclude-dir=.git '{{' . || true)"
[ -n "$files" ] || { echo "Sin placeholders pendientes."; exit 0; }

# sed -i portable (BSD y GNU): escribe .bak y lo borra
echo "$files" | while IFS= read -r f; do
  sed -i.bak \
    -e "s|{{OWNER}}|$OWNER|g" \
    -e "s|{{REPO}}|$REPO|g" \
    -e "s|{{NAME}}|$NAME|g" \
    -e "s|{{VAULT_PATH}}|$VAULT_PATH|g" \
    "$f" && rm -f "$f.bak"
done

echo "Listo: $OWNER/$REPO · $NAME · $VAULT_PATH"

if [ -d "$HOME/.claude" ]; then
  mkdir -p "$HOME/.claude/rules"
  dest="$HOME/.claude/rules/memory-vault.md"
  if [ -e "$dest" ]; then
    echo "Ya existe $dest; no lo piso. La regla queda en clients/claude-code/memory-vault.md."
  else
    cp clients/claude-code/memory-vault.md "$dest"
    echo "Regla de Claude Code instalada en $dest"
  fi
fi

echo "Siguiente: completá PROFILE.md y PREFERENCES.md, enchufá los clientes (clients/), commit y push."
