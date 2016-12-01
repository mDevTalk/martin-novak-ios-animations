//: # Simple animation


//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .green
PlaygroundPage.current.liveView = view

let textLayer = CATextLayer()
textLayer.frame = view.frame
textLayer.string = "🏈"
textLayer.fontSize = 300
textLayer.alignmentMode = kCAAlignmentCenter

view.layer.addSublayer(textLayer)






//: New stuff
let animation = CABasicAnimation(keyPath: "transform.rotation.z")
animation.duration = 1
animation.byValue = NSNumber(value: Float(CGFloat.pi))
animation.isCumulative = true
animation.repeatCount = HUGE

textLayer.add(animation, forKey: nil)

// Key paths: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html#//apple_ref/doc/uid/TP40004514-CH12-SW8

//: There are other types of animation classes like CAKeyframeAnimation or CASpringAnimation

//: [Previous](@previous) - [Next](@next)
