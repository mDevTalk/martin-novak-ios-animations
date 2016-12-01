//: # Introduction to Playground

import UIKit
import PlaygroundSupport

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

// Insert Color Literal - Editor -> Insert Color Literal
view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)



// Sets the view to be the live view
PlaygroundPage.current.liveView = view


let label = UILabel(frame: view.frame)
label.font = UIFont.systemFont(ofSize: 50)
label.textAlignment = .center
// Insert Emoji - command + control + space
label.text = "🏈"
view.addSubview(label)




let imageView = UIImageView(frame: view.frame)
imageView.contentMode = .scaleAspectFit
// Drag and drop images - show here!
imageView.image = UIImage()
view.insertSubview(imageView, at: 0)

//: [Next](@next)
