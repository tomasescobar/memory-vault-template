# journal

Append-only. Un archivo por bot y por día: `YYYY-MM-DD-<bot>.md`,
`<bot>` ∈ `claude`, `gpt`, `grok`. Nunca editar entradas viejas ni archivos ajenos.

## Formato de entrada

```markdown
## HH:MM · <tipo> · <proyecto|general>
<una o dos oraciones con el hecho>
fuente: <qué lo originó: "Tomás lo pidió", "decisión en sesión X", URL>
```

`<tipo>` ∈ `decision`, `preferencia`, `estado`, `correccion`, `pendiente`.

## Ejemplo

```markdown
## 15:40 · preferencia · general
Prefiere que los reportes ejecutivos no incluyan cómo se calcularon los números.
fuente: Tomás lo pidió al revisar el informe semanal
```

Los journals procesados se mueven a `archive/YYYY/` en la consolidación.
