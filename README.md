# Teleprompter flotante para Mac

Un teleprompter **transparente, siempre encima de todo y que deja pasar los clics**: lees tu guion mientras usas el navegador o lo que tengas debajo, como si no estuviera.

Lo hizo una inteligencia artificial, sin saber programar, para leer los programas del canal **Rodrigo Arnedo Inteligencia Artificial** (IA News). Es gratis y es tuyo: úsalo, cámbialo y compártelo.

## La forma más fácil: que te lo haga tu IA

En [`PROMPT.txt`](PROMPT.txt) tienes el prompt. Lo copias, se lo pegas a Claude o a ChatGPT y te va diciendo los pasos. Si tienes un PC en vez de un Mac, díselo («no tengo Mac, tengo un PC») y te lo adapta.

## O usa este directamente (solo macOS)

1. Abre la app **Terminal**.
2. Si es la primera vez, instala las herramientas de Apple: `xcode-select --install`
3. Descarga este repositorio (botón verde «Code» → «Download ZIP») y descomprímelo.
4. En la Terminal, entra en la carpeta y compílalo:
   ```
   swiftc -O teleprompter_flotante.swift -o teleprompter_flotante
   ```
5. Ábrelo con el guion de ejemplo:
   ```
   ./teleprompter_flotante ejemplo/guion.txt
   ```

## Cómo se usa

| Tecla | Qué hace |
|---|---|
| **⌥ (Opción), un toque** | Engancha la ventana (borde naranja): ya puedes moverla, cambiarla de tamaño desde la esquina, desplazar el texto y usar los botones. Otro toque la suelta. |
| **⌥ dos toques rápidos** | Play / pausa, estés en la app que estés. |
| **Ctrl+P** | Muestra o esconde el teleprompter. Al mostrarlo relee el guion, así que siempre sale la última versión. |
| Espacio · ↑ · ↓ | Con la ventana enganchada: play/pausa, más rápido, más lento. |

Botones de la barra: ▶ play · 🐢 🐇 velocidad · A− A+ tamaño de letra · ◐− ◐+ transparencia · ⤒ volver arriba · ✕ cerrar. Recuerda dónde lo dejaste, su tamaño, la letra, la transparencia y la velocidad.

Para arrancarlo escondido (y sacarlo con Ctrl+P): `./teleprompter_flotante guion.txt --oculto`

## Cómo escribir el guion

Un archivo `.txt` normal:

- `# TEXTO` → titular: se lee, en naranja.
- Texto normal → se lee, en blanco.
- `> NOTA (pestaña 3)` → nota para ti, que **no se lee**: raya y texto **azules** («cambia de pestaña»).
- `> NOTA` sin la palabra «pestaña» → raya y texto **verdes** («sigues en la misma pestaña»).

## Avisos

- Funciona **solo en macOS** y no necesita permisos especiales.
- Se comparte **tal cual, sin soporte**. Si algo no te va, pídeselo a tu IA: es justo lo que hacemos en el canal.
- Licencia [MIT](LICENSE).

Canal: https://www.youtube.com/@RodrigoArnedo_InteligenciaA · Web: https://funontheride.com
