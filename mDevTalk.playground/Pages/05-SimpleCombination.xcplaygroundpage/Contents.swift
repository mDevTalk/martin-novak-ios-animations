//: # Simple Combination

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

// Example of Measurement class
let rotationInDegrees = Measurement(value: -180, unit: UnitAngle.degrees)
let rotationInRadians = Float(rotationInDegrees.converted(to: .radians).value)

// Rotation
let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
rotationAnimation.duration = 1
rotationAnimation.byValue = NSNumber(value: rotationInRadians)
rotationAnimation.isCumulative = true
rotationAnimation.repeatCount = HUGE
textLayer.add(rotationAnimation, forKey: nil)

// Position
let positionAnimation = CABasicAnimation(keyPath: "position.x")
positionAnimation.fromValue = view.frame.width
positionAnimation.toValue = 0
positionAnimation.duration = 10.0
positionAnimation.repeatCount = HUGE
positionAnimation.autoreverses = true
textLayer.add(positionAnimation, forKey: nil)

// Another position, bounce
let bounceAnimation = CABasicAnimation(keyPath: "position.y")
bounceAnimation.fromValue = 0
bounceAnimation.toValue = view.frame.size.height
bounceAnimation.duration = 1
bounceAnimation.autoreverses = true
bounceAnimation.repeatCount = HUGE
textLayer.add(bounceAnimation, forKey: nil)

//: Animations can be grouped into group using CAAnimationGroup

//: [Previous](@previous) - [Next](@next)
