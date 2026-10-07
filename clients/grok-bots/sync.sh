#!/usr/bin/env sh
# Sync del memory-vault para los Grok Bots (o cualquier bot con shell).
#
#   sync.sh pull                                  # rebase sobre el remoto
#   sync.sh note <tipo> <proyecto> <texto> <fuente>   # append al journal del día
#   sync.sh push                                  # commit + push de lo pendiente
#
# El journal es append-only y por bot/día, así que el commit nunca toca archivos
# que otro cliente esté editando. BOT se puede sobreescribir por env (default grok).
set -eu

VAULT="${VAULT:-$(cd "$(dirname "$0")/../.." && pwd)}"
BOT="${BOT:-grok}"
cd "$VAULT"

today() { date -u +%Y-%m-%d; }
now() { date -u +%H:%M; }

case "${1:-}" in
  pull)
    git pull --rebase --quiet
    ;;
  note)
    [ $# -eq 5 ] || { echo "uso: sync.sh note <tipo> <proyecto> <texto> <fuente>" >&2; exit 2; }
    tipo="$2"; proyecto="$3"; texto="$4"; fuente="$5"
    case "$tipo" in
      decision|preferencia|estado|correccion|pendiente) ;;
      *) echo "tipo inválido: $tipo" >&2; exit 2 ;;
    esac
    f="journal/$(today)-$BOT.md"
    printf '## %s · %s · %s\n%s\nfuente: %s\n\n' "$(now)" "$tipo" "$proyecto" "$texto" "$fuente" >> "$f"
    git add "$f"
    ;;
  push)
    if git diff --cached --quiet && git diff --quiet; then
      exit 0
    fi
    git add journal/
    git commit --quiet -m "journal($BOT): $(today)" || true
    git pull --rebase --quiet
    git push --quiet
    ;;
  *)
    echo "uso: sync.sh pull | note <tipo> <proyecto> <texto> <fuente> | push" >&2
    exit 2
    ;;
esac
