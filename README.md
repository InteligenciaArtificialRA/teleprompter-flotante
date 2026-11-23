# Teleprompter flotante para Mac, Windows y el móvil

Un teleprompter **transparente, siempre encima de todo y que deja pasar los clics**: lees tu guion mientras usas el navegador o lo que tengas debajo, como si no estuviera.

Lo hizo una inteligencia artificial, sin saber programar, para leer los programas del canal **Rodrigo Arnedo Inteligencia Artificial** (IA News). Es gratis y es tuyo: úsalo, cámbialo y compártelo.

## 📱 Para el móvil o la tableta: ábrelo e instálalo

**https://inteligenciaartificialra.github.io/teleprompter-flotante/**

Es una **PWA** (aplicación web progresiva): una web que se instala como si fuera una app, sin App Store ni Google Play. Funciona **sin internet** y tu guion **no sale de tu aparato**.

- **Android:** ábrelo en Chrome y toca «Instalar como app».
- **iPhone / iPad:** ábrelo en Safari → Compartir → «Añadir a pantalla de inicio».
- **Ordenador:** en Chrome o Edge, el icono de instalar de la barra de direcciones.

No flota encima de otras ventanas (eso solo lo pueden hacer los de Mac y Windows): es para leer en el móvil, la tableta o con un teleprompter de cristal (tiene modo espejo). El código está en la carpeta [`docs/`](docs/).

## La forma más fácil: que te lo haga tu IA

- **Mac:** [`PROMPT.txt`](PROMPT.txt)
- **Windows 10/11:** [`PROMPT_WINDOWS.txt`](PROMPT_WINDOWS.txt) (probado en Windows: funciona)
- **Móvil (PWA):** [`PROMPT_PWA.txt`](PROMPT_PWA.txt)

Lo copias, se lo pegas a Claude o a ChatGPT y te va diciendo los pasos. La IA no puede compilarlo desde el chat: si al compilar te sale un error, pégaselo y lo arregla.

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

- El programa `.swift` es para **macOS**; para Windows, usa el prompt de Windows; para el móvil, la PWA. Ninguno necesita permisos especiales.
- En Windows se engancha con el **Alt de la izquierda** (el AltGr se usa para escribir @, # y €).
- Mientras está abierto, **Ctrl+P** no sirve para imprimir en otros programas (Mac y Windows).
- Se comparte **tal cual, sin soporte**. Si algo no te va, pídeselo a tu IA: es justo lo que hacemos en el canal.
- Licencia [MIT](LICENSE).

## Gracias

- **Javi**, del equipo, por probarlo en Windows.
- La idea de la versión PWA nos la dio **Santos**, un seguidor del canal, que nos enseñó el teleprompter PWA que había hecho para una clienta. Esta versión la hemos escrito desde cero.

Canal: https://www.youtube.com/@RodrigoArnedo_InteligenciaA · Web: https://funontheride.com
