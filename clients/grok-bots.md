# Grok Bots (VM compartida)

Los Grok Bots comparten una computadora en la nube. Cada bot tiene memoria propia
de conversación, pero el disco es común. Ese disco es un **clon** del vault, no el
origen: el remoto en GitHub es la fuente de verdad.

## Setup (una vez, en la VM)

1. Deploy key o PAT fine-grained con Contents: read & write sobre `{{REPO}}`.
   Con PAT: `git remote set-url origin https://<PAT>@github.com/{{OWNER}}/{{REPO}}.git`
   (o guardarlo en el credential helper; nunca en un archivo del repo).
2. Clonar:
   ```sh
   git clone git@github.com:{{OWNER}}/{{REPO}}.git ~/memory-vault
   ```
3. Copiar `clients/grok-bots/sync.sh` a un lugar en PATH, o invocarlo por ruta.

## En la rutina de cada bot

```sh
~/memory-vault/clients/grok-bots/sync.sh pull        # al empezar
# ... el bot lee INDEX.md, PROFILE.md, PREFERENCES.md y su proyecto ...
~/memory-vault/clients/grok-bots/sync.sh note "decision" "general" "texto" "fuente"
~/memory-vault/clients/grok-bots/sync.sh push        # al cerrar
```

`note` agrega al `journal/YYYY-MM-DD-grok.md` del día. Varios bots escribiendo el
mismo día comparten el archivo, pero están en la misma máquina, así que no hay
conflicto de merge: el push es secuencial.

## Instrucción para cada bot

```text
Tu memoria de largo plazo es ~/memory-vault (un clon de git). Al empezar, corré
sync.sh pull y leé INDEX.md, PROFILE.md, PREFERENCES.md y projects/<slug>.md si
aplica. No inventes contexto que no esté ahí. Cuando se cierre un hecho durable,
anotalo con sync.sh note. Al terminar, sync.sh push. No edites PROFILE,
PREFERENCES ni projects/: eso lo hace la consolidación.
```

## Grok chat (no el bot)

No tiene gancho al disco. Es caché. Si en un chat de Grok se decide algo que
importa, se lo pedís a un bot de la VM para que lo anote, o lo anotás vos.
