//: # Glyph
//: ### Credits: Russell Mirabelli

//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
PlaygroundPage.current.liveView = view

let layer = CAShapeLayer()
layer.frame = view.layer.frame.insetBy(dx: 50, dy: 50)
view.layer.addSublayer(layer)





//: New stuff
func path(from: String) -> UIBezierPath? {
    var unichars = [UniChar](from.utf16)
    var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
    let font = UIFont.systemFont(ofSize: 100)
    let success = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
    if success {
        return UIBezierPath(cgPath: CTFontCreatePathForGlyph(font, glyphs.first!, nil)!)
    }
    
    return nil
}

let bPath = path(from: "E")?.cgPath

layer.path = bPath
layer.isGeometryFlipped = true

let rPath = path(from: "F")?.cgPath
let glyphAnimation = CABasicAnimation(keyPath: "path")
glyphAnimation.duration = 3.0
glyphAnimation.fromValue = bPath
glyphAnimation.toValue = rPath
glyphAnimation.autoreverses = true
glyphAnimation.repeatCount = HUGE
layer.add(glyphAnimation, forKey: nil)

//: [Previous](@previous) - [Next](@next)
