//: # Prototyping View Controller

import UIKit
import PlaygroundSupport

//: Mock data and View Controller

struct Response {
    var data: String = "Hello there!"
}

class Server {
    func getData(_ completion: @escaping (Response)->(Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            completion(Response())
        })
    }
}

class ExampleController: UIViewController {
    
    let server = Server()
    private weak var label: UILabel?
    private weak var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        button.setTitle("Load data now!", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.addSubview(button)
        self.button = button
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        label.text = "Loading..."
        label.isHidden = true
        label.textAlignment = .center
        view.addSubview(label)
        self.label = label
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        
        label?.isHidden = false
        button?.isHidden = true
        
        server.getData { (response) -> (Void) in
            self.label?.text = response.data
        }
    }
}



//: Test code

var controller = ExampleController()
controller.view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)


PlaygroundPage.current.liveView = controller

//: [Previous](@previous) - [Next](@next)
