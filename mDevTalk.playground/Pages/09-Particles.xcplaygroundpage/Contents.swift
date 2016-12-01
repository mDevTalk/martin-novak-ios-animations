//: # Particles

//: We know this already
import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
PlaygroundPage.current.liveView = view






//: New stuff

// Helper function that creates CAEmitterCells
func createCell(string: String) -> CAEmitterCell {
    let icon = CATextLayer()
    icon.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    icon.fontSize = 30
    icon.string = string
    
    let renderer = UIGraphicsImageRenderer.init(bounds: icon.frame)
    let image = renderer.image { (context) in
        icon.render(in: context.cgContext)
    }
    let cell = CAEmitterCell()
    cell.contents = image.cgImage
    cell.birthRate = 2
    cell.lifetime = 3
    
    cell.velocity = -150.0
    cell.velocityRange = 250
    cell.yAcceleration = 100.3
    
    cell.scale = 1.0
    cell.scaleRange = 0.5
    
    cell.spin = 1.0
    cell.spinRange = 10.0
    
    
    return cell
}

let emitter = CAEmitterLayer()
emitter.frame = view.frame
view.layer.addSublayer(emitter)

// Single emmiter with two cells
emitter.emitterCells = [createCell(string: "⚽️"), createCell(string: "🏈")]

// EmmitterCell can have subemitters - uncomment and comment above for example
//let cell = createCell(string: "🙀")
//let subCell = createCell(string: "🏈")
//subCell.scale = 0.5
//subCell.scaleRange = 0.2
//cell.emitterCells = [subCell]
//emitter.emitterCells = [cell]

emitter.emitterPosition = CGPoint(x: 420, y: 100)
emitter.emitterShape = kCAEmitterLayerPoint
emitter.emitterSize = CGSize(width: 400, height: 400)
emitter.renderMode = kCAEmitterLayerOldestFirst


//: [Previous](@previous) - [Next](@next)
