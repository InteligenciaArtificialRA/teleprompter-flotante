// Teleprompter flotante para macOS: ventana semitransparente, siempre encima y que deja
// pasar los clics a lo que hay debajo (el navegador, tus notas…). Con la tecla ⌥ (Opción)
// la ventana se «engancha»: trackpad para subir y bajar, arrastrar por la barra de arriba,
// botones de play, velocidad, letra y transparencia, y la esquina inferior derecha para
// cambiar el tamaño. No pide permisos especiales de macOS.
// Compilar: swiftc -O teleprompter_flotante.swift -o teleprompter_flotante
// Usar:     ./teleprompter_flotante guion.txt        (añade --oculto para arrancar escondido; Ctrl+P lo muestra)
// Hecho con IA para el canal «Rodrigo Arnedo Inteligencia Artificial». Licencia MIT.
import AppKit
import Carbon.HIToolbox

func cargarGuion() -> String {
    let a = CommandLine.arguments
    guard a.count > 1, let t = try? String(contentsOfFile: a[1], encoding: .utf8) else {
        print("Uso: teleprompter_flotante <guion.txt>"); exit(1)
    }
    return t
}
var raw = cargarGuion()
// Con --oculto arranca escondido; Ctrl+P lo muestra y lo esconde desde cualquier app.
let arrancaOculto = CommandLine.arguments.contains("--oculto")
let defaults = UserDefaults.standard
var fontSize = CGFloat(defaults.object(forKey: "tp_font") as? Double ?? 30)
var alpha = CGFloat(defaults.object(forKey: "tp_alpha") as? Double ?? 0.45)
var speed = CGFloat(defaults.object(forKey: "tp_speed") as? Double ?? 1.0)
var playing = false

func buildText() -> NSAttributedString {
    let out = NSMutableAttributedString()
    let para = NSMutableParagraphStyle(); para.alignment = .center; para.paragraphSpacing = fontSize * 0.25
    let shadow = NSShadow(); shadow.shadowColor = NSColor.black; shadow.shadowBlurRadius = 4; shadow.shadowOffset = .zero
    var blanks = 0
    for line in raw.components(separatedBy: "\n") {
        let t = line.trimmingCharacters(in: .whitespaces)
        if t.isEmpty { blanks += 1; if blanks <= 2 { out.append(NSAttributedString(string: "\n", attributes: [.font: NSFont.systemFont(ofSize: fontSize * 0.4)])) }; continue }
        blanks = 0
        var attrs: [NSAttributedString.Key: Any] = [.paragraphStyle: para, .shadow: shadow]
        var text = t
        if t.hasPrefix("# ") {
            text = String(t.dropFirst(2)); attrs[.font] = NSFont.boldSystemFont(ofSize: fontSize); attrs[.foregroundColor] = NSColor(red: 1, green: 0.42, blue: 0.1, alpha: 1)
        } else if t.hasPrefix("> ") {
            // Pestaña NUEVA (la marca lleva «(pestaña N)») = línea y texto AZULES.
            // Otra nota en la MISMA pestaña (sin «pestaña») = línea discontinua y texto VERDES.
            let nueva = t.contains("pestaña")
            let col = nueva ? NSColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1) : NSColor(red: 0.2, green: 0.85, blue: 0.45, alpha: 1)
            var la = attrs; la[.font] = NSFont.systemFont(ofSize: max(11, fontSize * 0.42), weight: .black); la[.foregroundColor] = col
            out.append(NSAttributedString(string: String(repeating: nueva ? "━" : "╍", count: 40) + "\n", attributes: la))
            text = "· " + String(t.dropFirst(2)) + " ·"; attrs[.font] = NSFont.systemFont(ofSize: max(11, fontSize * 0.42), weight: .semibold); attrs[.foregroundColor] = col
        } else {
            attrs[.font] = NSFont.boldSystemFont(ofSize: fontSize); attrs[.foregroundColor] = NSColor.white
        }
        out.append(NSAttributedString(string: text + "\n", attributes: attrs))
    }
    return out
}

final class Panel: NSPanel {
    override var canBecomeKey: Bool { true }
    override func constrainFrameRect(_ r: NSRect, to s: NSScreen?) -> NSRect { r }
}

// Arrastre A MANO: con performDrag y la ⌥ pulsada, macOS activa el mosaico de
// ventanas (izquierda/derecha/completa) y no deja dejarla arriba del todo.
final class DragBar: NSView {
    var start = NSPoint.zero; var startOrigin = NSPoint.zero
    override func mouseDown(with e: NSEvent) { start = NSEvent.mouseLocation; startOrigin = window!.frame.origin }
    override func mouseDragged(with e: NSEvent) {
        let p = NSEvent.mouseLocation
        window!.setFrameOrigin(NSPoint(x: startOrigin.x + (p.x - start.x), y: startOrigin.y + (p.y - start.y)))
    }
}
final class ResizeGrip: NSView {
    var start = NSPoint.zero; var startFrame = NSRect.zero
    override func draw(_ r: NSRect) { NSColor(white: 1, alpha: 0.35).setFill(); let p = NSBezierPath(); p.move(to: NSPoint(x: bounds.maxX, y: 0)); p.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY)); p.line(to: NSPoint(x: 0, y: 0)); p.fill() }
    override func mouseDown(with e: NSEvent) { start = NSEvent.mouseLocation; startFrame = window!.frame }
    override func mouseDragged(with e: NSEvent) {
        let p = NSEvent.mouseLocation; var f = startFrame
        f.size.width = max(300, startFrame.width + (p.x - start.x))
        let h = max(120, startFrame.height - (p.y - start.y)); f.origin.y = startFrame.maxY - h; f.size.height = h
        window!.setFrame(f, display: true)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let screen = NSScreen.main!.visibleFrame
let panel = Panel(contentRect: NSRect(x: screen.minX + 80, y: screen.maxY - 380, width: min(1300, screen.width - 160), height: 340),
                  styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
panel.level = .floating
panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
panel.isOpaque = false; panel.backgroundColor = .clear; panel.hasShadow = false
panel.ignoresMouseEvents = true
panel.setFrameAutosaveName("TeleprompterFlotante")

let root = NSView(frame: panel.contentView!.bounds); root.autoresizingMask = [.width, .height]
root.wantsLayer = true; root.layer?.cornerRadius = 12
root.layer?.backgroundColor = NSColor(white: 0, alpha: alpha).cgColor
root.layer?.borderWidth = 0; root.layer?.borderColor = NSColor(red: 1, green: 0.42, blue: 0.1, alpha: 1).cgColor
panel.contentView = root

let barH: CGFloat = 26
let bar = DragBar(frame: NSRect(x: 0, y: root.bounds.height - barH, width: root.bounds.width, height: barH))
bar.autoresizingMask = [.width, .minYMargin]; bar.wantsLayer = true; bar.layer?.backgroundColor = NSColor(white: 1, alpha: 0.08).cgColor
root.addSubview(bar)
let hint = NSTextField(labelWithString: "⌥ = enganchar/soltar · ⌥⌥ = play/pausa · Ctrl+P = subir/bajar")
hint.font = .systemFont(ofSize: 11); hint.textColor = NSColor(white: 1, alpha: 0.55); hint.frame = NSRect(x: 10, y: 5, width: 700, height: 16)
bar.addSubview(hint)

let scroll = NSScrollView(frame: NSRect(x: 0, y: 0, width: root.bounds.width, height: root.bounds.height - barH))
scroll.autoresizingMask = [.width, .height]; scroll.drawsBackground = false; scroll.hasVerticalScroller = false
let tv = NSTextView(frame: scroll.bounds); tv.isEditable = false; tv.isSelectable = false; tv.drawsBackground = false
tv.textContainerInset = NSSize(width: 30, height: 20); tv.autoresizingMask = [.width]
tv.textContainer?.widthTracksTextView = true
tv.textStorage?.setAttributedString(buildText())
scroll.documentView = tv
root.addSubview(scroll)

let grip = ResizeGrip(frame: NSRect(x: root.bounds.width - 18, y: 0, width: 18, height: 18)); grip.autoresizingMask = [.minXMargin, .maxYMargin]
root.addSubview(grip)

final class Actions: NSObject {
    var playBtn: NSButton!
    @objc func play() { playing.toggle(); playBtn.title = playing ? "❚❚" : "▶" }
    @objc func slower() { speed = max(0.2, speed - 0.2); defaults.set(Double(speed), forKey: "tp_speed") }
    @objc func faster() { speed = min(6, speed + 0.2); defaults.set(Double(speed), forKey: "tp_speed") }
    @objc func smaller() { fontSize = max(14, fontSize - 2); refont() }
    @objc func bigger() { fontSize = min(80, fontSize + 2); refont() }
    @objc func moreClear() { alpha = max(0, alpha - 0.1); reAlpha() }
    @objc func lessClear() { alpha = min(1, alpha + 0.1); reAlpha() }
    @objc func top() { tv.scroll(NSPoint.zero) }
    @objc func quit() { NSApp.terminate(nil) }
    func refont() { defaults.set(Double(fontSize), forKey: "tp_font"); let y = scroll.contentView.bounds.origin.y; tv.textStorage?.setAttributedString(buildText()); tv.scroll(NSPoint(x: 0, y: y)) }
    func reAlpha() { defaults.set(Double(alpha), forKey: "tp_alpha"); root.layer?.backgroundColor = NSColor(white: 0, alpha: alpha).cgColor }
}
let acts = Actions()
let botones: [(String, Selector)] = [("▶", #selector(Actions.play)), ("🐢", #selector(Actions.slower)), ("🐇", #selector(Actions.faster)),
    ("A−", #selector(Actions.smaller)), ("A+", #selector(Actions.bigger)), ("◐−", #selector(Actions.moreClear)), ("◐+", #selector(Actions.lessClear)),
    ("⤒", #selector(Actions.top)), ("✕", #selector(Actions.quit))]
var x = root.bounds.width - CGFloat(botones.count) * 40 - 8
for (t, sel) in botones {
    let b = NSButton(title: t, target: acts, action: sel); b.bezelStyle = .inline; b.isBordered = false
    b.font = .systemFont(ofSize: 13); b.contentTintColor = .white
    b.frame = NSRect(x: x, y: 3, width: 38, height: 20); b.autoresizingMask = [.minXMargin]
    bar.addSubview(b); if t == "▶" { acts.playBtn = b }; x += 40
}

// ⌥ pulsada = ventana interactiva; suelta = los clics la atraviesan. Se consulta el estado
// de las teclas modificadoras (NSEvent.modifierFlags), que no necesita permisos.
// Doble toque de ⌥ = play/pausa desde cualquier app (sin permisos: solo se mira el estado
// de las modificadoras). Toque = pulsar y soltar en < 0,3 s; dos toques en < 0,45 s.
var optDown = false, optDownAt = Date.distantPast, lastTapAt = Date.distantPast
// Un toque de ⌥ = ENGANCHAR: el teleprompter coge ratón y teclado aunque se suelte ⌥;
// otro toque = soltar. El doble toque cambia dos veces → queda igual, y además play/pausa.
var fijo = false
func setFijo(_ v: Bool) {
    fijo = v
    if v { NSApp.activate(ignoringOtherApps: true); panel.makeKeyAndOrderFront(nil) }
    else { NSApp.deactivate() }
}
// Con el teleprompter activo (tras pinchar con ⌥): espacio = play/pausa, ↑/↓ = velocidad.
NSEvent.addLocalMonitorForEvents(matching: .keyDown) { e in
    switch e.keyCode {
    case 49: acts.play(); return nil          // espacio
    case 126: acts.faster(); return nil       // ↑
    case 125: acts.slower(); return nil       // ↓
    default: return e
    }
}
Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
    let flags = NSEvent.modifierFlags
    let opt = flags.contains(.option)
    let soloOpt = flags.intersection([.command, .control, .shift]).isEmpty
    if opt && !optDown { optDown = true; optDownAt = Date() }
    if !opt && optDown {
        optDown = false
        let now = Date()
        if soloOpt && now.timeIntervalSince(optDownAt) < 0.3 {
            setFijo(!fijo)
            if now.timeIntervalSince(lastTapAt) < 0.45 { acts.play(); lastTapAt = .distantPast } else { lastTapAt = now }
        } else { lastTapAt = .distantPast }
    }
    let activo = opt || fijo
    if !panel.isVisible { return }
    if panel.ignoresMouseEvents == activo { panel.ignoresMouseEvents = !activo }
    root.layer?.borderWidth = fijo ? 3 : (opt ? 2 : 0)
    if playing {
        var o = scroll.contentView.bounds.origin; o.y += speed
        let maxY = max(0, tv.frame.height - scroll.contentView.bounds.height)
        if o.y >= maxY { o.y = maxY; playing = false; acts.playBtn.title = "▶" }
        scroll.contentView.scroll(to: o); scroll.reflectScrolledClipView(scroll.contentView)
    }
}
// ── Mostrar / esconder ─────────────────────────────────────────────
// Al mostrarlo se relee el .txt: si has cambiado el guion, sale la última versión.
func ocultar() {
    playing = false; acts.playBtn.title = "▶"
    if fijo { setFijo(false) }
    panel.ignoresMouseEvents = true; root.layer?.borderWidth = 0
    panel.orderOut(nil)
}
func mostrar() {
    if let t = try? String(contentsOfFile: CommandLine.arguments[1], encoding: .utf8), t != raw {
        raw = t
        let y = scroll.contentView.bounds.origin.y
        tv.textStorage?.setAttributedString(buildText()); tv.scroll(NSPoint(x: 0, y: y))
    }
    panel.orderFrontRegardless()
}
func alternar() { if panel.isVisible { ocultar() } else { mostrar() } }
// Ctrl+P global con Carbon (RegisterEventHotKey): no pide permisos de macOS.
var hotKeyRef: EventHotKeyRef?
var hkSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
InstallEventHandler(GetApplicationEventTarget(), { (_, _, _) -> OSStatus in
    DispatchQueue.main.async { alternar() }
    return noErr
}, 1, &hkSpec, nil, nil)
RegisterEventHotKey(UInt32(kVK_ANSI_P), UInt32(controlKey), EventHotKeyID(signature: OSType(0x54504C54), id: 1), GetApplicationEventTarget(), 0, &hotKeyRef)

if !arrancaOculto { panel.orderFrontRegardless() }
app.run()
