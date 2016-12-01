//: # Real Life 2

import UIKit
import PlaygroundSupport

//: ## PulseView

@IBDesignable open class PulseView: UIView {
    
    // MARK: Colors
    
    @IBInspectable var gradientStartColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = UIColor.yellow {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Line
    
    @IBInspectable var lineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Gradient
    
    var gradientStart: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var gradientEnd: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Animation settings
    
    var animationSpeed: CFTimeInterval = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Adding pulse
    
    /// Height of the pulse 0 means no pulse, 1 means max pulse
    open func addPulse(_ height: CGFloat, stopPulse: Bool = false) {
        
        let normalizedHeight: CGFloat = height
        
        let floatPulseCount = CGFloat(currentPulseCount)
        let points = [CGPoint(x: floatPulseCount + 0.375   , y: 0.5),
                      CGPoint(x: floatPulseCount + 0.4     , y: 0.5 + 0.25*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.425   , y: 0.5 + 0.1*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.45    , y: 0.5 + 0.5*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.5     , y: 0.5 + -0.5*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.525   , y: 0.5 + -0.1*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.55    , y: 0.5 + -0.25*normalizedHeight),
                      CGPoint(x: floatPulseCount + 0.575   , y: 0.5)]
        currentPulseCount += 0.6
        addPulse(points, stopPulse: stopPulse)
    }
    
    fileprivate func addPulse(_ points: [CGPoint], stopPulse: Bool) {
        
        let path = lineLayer.path
        let linePath = UIBezierPath(cgPath: path!)
        
        let rect = layer.frame
        points.forEach { (point) in
            let absolutePoint = CGPoint(x: point.x*rect.width, y: point.y*rect.height)
            linePath.addLine(to: absolutePoint)
        }
        
        lineLayer.path = linePath.cgPath
        
        let offset: CGFloat
        let duration: CFTimeInterval
        if stopPulse {
            offset = layer.frame.size.width * (CGFloat(currentPulseCount)-1)
            duration = 3
        } else {
            offset = layer.frame.size.width * CGFloat(currentPulseCount)
            duration = 6
        }
        
        animateXPosition(lineLayer, offset: offset, duration: duration)
    }
    
    // MARK: Private Variables
    
    /// Gradient layer
    fileprivate var gradientLayer = CAGradientLayer()
    
    /// Mask over the gradient layer
    fileprivate var lineLayer = CAShapeLayer()
    
    fileprivate var currentPulseCount: CGFloat = 1
    
    // MARK: Drawing
    
    override open func draw(_ rect: CGRect) {
        
        if gradientLayer.superlayer == nil {
            /// Create the gradient
            gradientLayer.frame = rect
            layer.addSublayer(gradientLayer)
            
            // Create and add the mask
            let linePath = drawLine(rect, points: [CGPoint(x: 0, y: 0.5),
                                                   CGPoint(x: 1, y: 0.5)])
            lineLayer.path = linePath.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = UIColor.black.cgColor
            lineLayer.lineWidth = lineWidth
            
            gradientLayer.mask = lineLayer
            
            animateAppear(layer)
        }
        
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientLayer.startPoint = gradientStart
        gradientLayer.endPoint = gradientEnd
    }
    
    // MARK: Animation
    
    fileprivate func animateAppear(_ layer: CALayer) {
        
        layer.transform = CATransform3DMakeScale(0.6, 0, 1);
        
        let animationY = CABasicAnimation(keyPath: "transform.scale.y")
        animationY.duration = 2
        animationY.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationY.fromValue = 0
        animationY.toValue = 1
        animationY.isRemovedOnCompletion = true
        animationY.repeatCount = 1
        
        layer.transform = CATransform3DMakeScale(0.6, 1, 1);
        layer.add(animationY, forKey: "scale.y")
        
        
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            let animation = CABasicAnimation(keyPath: "transform.scale.x")
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = 0.6
            animation.toValue = 1
            animation.isRemovedOnCompletion = false
            animation.repeatCount = 1
            
            layer.transform = CATransform3DMakeScale(1, 1, 1);
            layer.add(animation, forKey: "scale.x")
        }
    }
    
    fileprivate func animateXPosition(_ layer: CAShapeLayer, offset: CGFloat, duration: CFTimeInterval) {
        if let _ = layer.animation(forKey: "animatePosition") {
            layer.removeAnimation(forKey: "animatePosition")
        }
        
        let targetPosition = layer.frame.size.width/2-offset
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = (layer.presentation() as! CALayer).value(forKeyPath: "position.x")
        animation.fillMode = kCAFillModeForwards
        animation.toValue = targetPosition
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        
        layer.position = CGPoint(x: targetPosition, y: layer.position.y)
        layer.add(animation, forKey: "animatePosition")
    }
    
    // MARK: Helper methods
    
    /**
     * Draw the line in given rect with given points
     * - parameter rect: The rect to draw in
     * - parameter points: Points (0-1) with relative position in the rect
     */
    fileprivate func drawLine(_ rect: CGRect, points: [CGPoint], offset: CGPoint = CGPoint.zero) -> UIBezierPath {
        
        let linePath = UIBezierPath()
        
        if points.count == 0 {
            return linePath
        }
        
        // Take relative points and rect size and create absolute positions
        var absolutePoints = [CGPoint]()
        points.forEach { (point) in
            absolutePoints.append(CGPoint(x: (point.x+offset.x)*rect.width, y: (point.y+offset.y)*rect.height))
        }
        
        linePath.move(to: absolutePoints[0])
        
        for point in absolutePoints {
            linePath.addLine(to: point)
        }
        
        return linePath
    }
    
    /**
     * Draw the square in given rect with given corner radius
     * - parameter rect: The rect to draw
     * - parameter cornerRadius: corner radius of given rect
     */
    fileprivate func drawSquare(_ rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        
        let sizeRect: CGRect
        if cornerRadius <= rect.size.width {
            sizeRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        } else {
            sizeRect = CGRect(x: 0, y: rect.size.height/2, width: 1, height: 1)
        }
        
        let borderPath = UIBezierPath(roundedRect: sizeRect, cornerRadius: cornerRadius)
        
        return borderPath
    }
}

//: ## Test Code

func addPulse(_ addition: UInt32, pulseView: PulseView) {
    let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        
        let height = CGFloat(drand48())
        
        if (addition < 4) {
            pulseView.addPulse(height)
            addPulse(addition+1, pulseView: pulseView)
        } else if (addition == 4) {
            pulseView.addPulse(height, stopPulse: true)
            addPulse(addition+1, pulseView: pulseView)
        } else {
            pulseView.gradientStartColor = UIColor.yellow
            pulseView.gradientEndColor = UIColor.orange
        }
    }
}

let pulseView = PulseView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
pulseView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
pulseView.gradientEndColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
pulseView.gradientStartColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
pulseView.lineWidth = 10

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.addSubview(pulseView)
PlaygroundPage.current.liveView = view
addPulse(0, pulseView: pulseView)


//: [Previous](@previous) - [Next](@next)
