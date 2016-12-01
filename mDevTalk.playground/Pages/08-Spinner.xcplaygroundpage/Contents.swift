//: # Spinner
//: ### CAReplicatorLayer usage example

//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
PlaygroundPage.current.liveView = view

let imageLayer = CATextLayer()
imageLayer.string = "🏈"
imageLayer.fontSize = 35
imageLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
imageLayer.position = CGPoint(x: 75, y: 75)
imageLayer.cornerRadius = 25






//: New stuff

// Fade of single layer
let fadeAnimation = CABasicAnimation(keyPath: "opacity")
fadeAnimation.fromValue = 1.0
fadeAnimation.toValue = 0.0
fadeAnimation.repeatCount = HUGE
fadeAnimation.duration = 1.0
imageLayer.add(fadeAnimation, forKey: "opacity")

let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
scaleAnimation.fromValue = 1.0
scaleAnimation.toValue = 0.3
scaleAnimation.repeatCount = HUGE
scaleAnimation.duration = 1.0
imageLayer.add(scaleAnimation, forKey: "transform.scale")

// The magic - ReplicatorLayer
let replication = CAReplicatorLayer()
replication.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
replication.position = view.center
replication.instanceCount = 10
replication.instanceDelay = 0.1
replication.instanceTransform = CATransform3DMakeRotation(CGFloat(M_PI/5), 0, 0, 1)
replication.addSublayer(imageLayer)

view.layer.addSublayer(replication)


//: [Previous](@previous) - [Next](@next)
