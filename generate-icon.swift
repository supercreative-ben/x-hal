#!/usr/bin/env swift
import AppKit

let sizes: [(Int, String)] = [
    (16,   "icon_16x16"),
    (32,   "icon_16x16@2x"),
    (32,   "icon_32x32"),
    (64,   "icon_32x32@2x"),
    (128,  "icon_128x128"),
    (256,  "icon_128x128@2x"),
    (256,  "icon_256x256"),
    (512,  "icon_256x256@2x"),
    (512,  "icon_512x512"),
    (1024, "icon_512x512@2x"),
]

let iconsetPath = "build/AppIcon.iconset"
let fm = FileManager.default
try? fm.removeItem(atPath: iconsetPath)
try fm.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)

for (size, name) in sizes {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let ctx = NSGraphicsContext.current!.cgContext
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    let s = CGFloat(size)

    let bgColor = NSColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.0)
    ctx.setFillColor(bgColor.cgColor)
    let bgPath = CGPath(roundedRect: rect, cornerWidth: s * 0.22, cornerHeight: s * 0.22, transform: nil)
    ctx.addPath(bgPath)
    ctx.fillPath()

    let orbRadius = s * 0.28
    let center = CGPoint(x: s * 0.5, y: s * 0.52)
    let colors = [
        NSColor.white.cgColor,
        NSColor(red: 0.31, green: 0.76, blue: 0.97, alpha: 0.9).cgColor,
        NSColor(red: 0.31, green: 0.76, blue: 0.97, alpha: 0.3).cgColor,
        NSColor(red: 0.31, green: 0.76, blue: 0.97, alpha: 0.0).cgColor,
    ] as CFArray
    let locations: [CGFloat] = [0, 0.3, 0.7, 1.0]

    if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: locations) {
        ctx.drawRadialGradient(
            gradient,
            startCenter: center, startRadius: 0,
            endCenter: center, endRadius: orbRadius,
            options: []
        )
    }

    image.unlockFocus()

    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let png = bitmap.representation(using: .png, properties: [:]) else {
        continue
    }
    try png.write(to: URL(fileURLWithPath: "\(iconsetPath)/\(name).png"))
}

print("Iconset generated at \(iconsetPath)")
