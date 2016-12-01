//: # Animation types

import UIKit

//: * Springboard
let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
UIView.animate(withDuration: 0.3) { 
    view.alpha = 0.4
    // Animate position (constraints), alpha, color
}

//: * CoreAnimations
// Covered later in this talk

//: * SpriteKit (SceneKit)
// 2D (3D) Games framework, not recommended to use together with UIKit

//: * OpenGL / Metal
// If you are hardcore enough

//: * Other

//: [Previous](@previous) - [Next](@next)
