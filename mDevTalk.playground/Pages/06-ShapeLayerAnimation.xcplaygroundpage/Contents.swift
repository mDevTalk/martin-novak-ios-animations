//: # Shape Layer Animation

//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .green
PlaygroundPage.current.liveView = view






//: New stuff

// Create shape layer
let shapeLayer = CAShapeLayer()
shapeLayer.frame = view.frame
view.layer.addSublayer(shapeLayer)

// First path - Rect
let path = CGPath(rect: shapeLayer.frame.insetBy(dx: 30, dy: 30), transform: nil)
shapeLayer.path = path
shapeLayer.fillColor = UIColor.white.cgColor
shapeLayer.strokeColor = UIColor.black.cgColor

// Second path - Ellipse
let path2 = CGPath(ellipseIn: shapeLayer.frame.insetBy(dx: 30, dy: 30), transform: nil)

// Shape animation
let shapeAnimation = CABasicAnimation(keyPath: "path")
shapeAnimation.duration = 1.5
shapeAnimation.repeatCount = Float.infinity
shapeAnimation.fromValue = path
shapeAnimation.toValue = path2
shapeAnimation.autoreverses = true
shapeAnimation.repeatCount = HUGE
shapeLayer.add(shapeAnimation, forKey: nil)

// Opacity animation
let opacityAnimation = CABasicAnimation(keyPath: "opacity")
opacityAnimation.duration = 2.0
opacityAnimation.repeatCount = Float.infinity
opacityAnimation.fromValue = 1.0
opacityAnimation.toValue = 0.3
opacityAnimation.autoreverses = true
opacityAnimation.repeatCount = HUGE
shapeLayer.add(opacityAnimation, forKey: "opacity")

//: [Previous](@previous) - [Next](@next)
