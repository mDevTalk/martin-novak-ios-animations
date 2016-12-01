//: # Y Axis
//: ### and example of CASpringAnimation

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
let animation = CASpringAnimation(keyPath: "transform.rotation.y")
animation.duration = 1
animation.byValue = NSNumber(value: Float(CGFloat.pi))
animation.autoreverses = true
animation.repeatCount = HUGE

textLayer.add(animation, forKey: nil)

//: [Previous](@previous) - [Next](@next)
