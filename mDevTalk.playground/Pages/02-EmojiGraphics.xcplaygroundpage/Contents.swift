//: # Emoji as graphics


//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .green
PlaygroundPage.current.liveView = view






//: New stuff
let textLayer = CATextLayer()
textLayer.frame = view.frame
textLayer.string = "🏈"
textLayer.fontSize = 300
textLayer.alignmentMode = kCAAlignmentCenter

view.layer.addSublayer(textLayer)

//: [Previous](@previous) - [Next](@next)
