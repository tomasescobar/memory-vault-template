# Consolidación

Semanal, a mano, por PR. Cuando duela, se convierte en una rutina programada de
Claude Code que abre el PR. Nunca se consolida directo a `main` sin leer el diff.

## Pasos

1. `git pull --rebase`.
2. Listar `journal/*.md` posteriores a la fecha de "Última consolidación" en `INDEX.md`.
3. Para cada entrada:
   - **Preferencia o corrección** → `PREFERENCES.md`, con fuente y fecha.
   - **Hecho estable sobre mí** → `PROFILE.md`.
   - **Estado o decisión de un proyecto** → `projects/<slug>.md` (reescribir la
     sección, no apilar).
   - **Ruido** (ya consolidado, obsoleto, contradicho) → se ignora.
4. Contradicciones entre bots: gana lo más reciente **con fuente**, y se anota la
   contradicción en el proyecto si importa.
5. Actualizar "Última consolidación" y "Proyectos activos" en `INDEX.md`.
6. Mover los journals procesados a `journal/archive/YYYY/`.
7. Abrir PR. Revisar el diff. Mergear.

## Señales de que hace falta automatizar

- Más de ~20 entradas por semana.
- Dos semanas seguidas sin consolidar.
