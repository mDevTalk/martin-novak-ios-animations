//: # Real Life

import UIKit
import PlaygroundSupport

//: ## MeasurmentView

@IBDesignable open class MeasurmentView: UIView {
    
    // MARK: Size
    
    @IBInspectable var strokeWidth: CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var spaceWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Gradient
    
    @IBInspectable var gradientStartColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var gradientStart: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var gradientEnd: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Strokes
    
    /// Adds new stroke with given height into the view
    open func addStroke(_ height: CGFloat) {
        
        let previousStrokesCount = strokes.count
        let offset: CGFloat = CGFloat(previousStrokesCount)*(spaceWidth+strokeWidth)
        
        // Create new stroke
        let newStrokeLayer = CAGradientLayer()
        newStrokeLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        newStrokeLayer.startPoint = gradientStart
        newStrokeLayer.endPoint = gradientEnd
        newStrokeLayer.frame = CGRect(x: offset, y: holderLayer.frame.size.height, width: strokeWidth, height: 0)
        holderLayer.addSublayer(newStrokeLayer)
        
        // Animate appear
        
        if height > maxValue {
            maxValue = height
            for (index, (layer, value)) in zip(strokeLayers, strokes).enumerated() {
                let offset: CGFloat = CGFloat(index)*(spaceWidth+strokeWidth)
                animateHeightChange(layer, offset: offset, height: value)
            }
        }
        
        animateHeightChange(newStrokeLayer, offset: offset, height: height)
        
        // Add this path to the
        strokes.append(height)
        strokeLayers.append(newStrokeLayer)
        
        // Check (and move if needed) the holder
        
        if (offset + (strokeWidth+spaceWidth)) > holderLayer.frame.width + holderOffset {
            holderOffset += (spaceWidth+strokeWidth)
            animateHolderOffset(holderLayer, offset: holderOffset)
            
            let layerToHide = strokeLayers[lastVisibleIndex]
            animateAlpha(layerToHide, value: 0, duration: 0.4)
            lastVisibleIndex += 1
        }
    }
    
    // MARK: Animation properties
    
    /// Maximum percent of height taken by strokes
    fileprivate var maxHeightPercent: CGFloat = 0.7
    
    open var shapeAnimationDuration: CFTimeInterval = 0.6
    
    // This should be a little bit slower than speed of data comming in
    open var moveAnimationDuration: CFTimeInterval = 0.6
    
    // MARK: Private Variables
    
    /// Values for strokes in strokeLayers array
    fileprivate var strokes = [CGFloat]()
    
    /// List of stroke layers
    fileprivate var strokeLayers = [CAGradientLayer]()
    
    /// Layer that holds strokes
    fileprivate var holderLayer = CAShapeLayer()
    
    /// Current offset of the holder
    fileprivate var holderOffset: CGFloat = 0
    
    /// Value of current max stroke
    fileprivate var maxValue: CGFloat = 0
    
    /// Lowest visible index of a bar
    fileprivate var lastVisibleIndex = 0
    
    // MARK: Drawing
    
    override open func draw(_ rect: CGRect) {
        for layer in strokeLayers {
            layer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        }
        
        if holderLayer.superlayer == nil {
            let holderRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)
            let square = drawSquare(holderRect, cornerRadius: 0)
            
            holderLayer.path = square.cgPath
            holderLayer.fillColor = UIColor.clear.cgColor
            holderLayer.frame = rect
            layer.addSublayer(holderLayer)
        }
    }
    
    // MARK: Animations
    
    fileprivate func animateHeightChange(_ layer: CALayer, offset: CGFloat, height: CGFloat) {
        // Portion of heigh this should take
        let thisPortion = height/maxValue*maxHeightPercent
        
        // Calculated height of this potion
        let calculatedHeight = thisPortion*holderLayer.frame.size.height
        
        // Animate this path
        let targetRect = CGRect(x: offset, y: holderLayer.frame.size.height-calculatedHeight, width: strokeWidth, height: calculatedHeight)
        animatePath(layer, newRect: targetRect, duration: shapeAnimationDuration)
    }
    
    fileprivate func animateHolderOffset(_ layer: CAShapeLayer, offset: CGFloat) {
        animateXPosition(layer, offset: offset, duration: moveAnimationDuration)
    }
    
    fileprivate func animatePath(_ layer: CALayer, newRect: CGRect, duration: CFTimeInterval) {
        
        let animation = CASpringAnimation(keyPath: "position.y")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = layer.value(forKeyPath: "position.y")
        animation.toValue = holderLayer.frame.size.height - newRect.height/2
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        
        layer.position.y = holderLayer.frame.size.height - newRect.height/2
        layer.add(animation, forKey: "animatePosition")
        
        
        let sizeAnimation = CASpringAnimation(keyPath: "bounds.size.height")
        sizeAnimation.duration = duration
        sizeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        sizeAnimation.fromValue = layer.value(forKeyPath: "bounds.size.height")
        sizeAnimation.toValue = newRect.size.height
        sizeAnimation.isRemovedOnCompletion = false
        sizeAnimation.repeatCount = 1
        
        layer.bounds.size.height = newRect.size.height
        layer.add(sizeAnimation, forKey: "animateSize")
    }
    
    fileprivate func animateXPosition(_ layer: CAShapeLayer, offset: CGFloat, duration: CFTimeInterval) {
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
    
    fileprivate func animateAlpha(_ layer: CALayer, value: CGFloat, duration: CFTimeInterval) {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = layer.value(forKeyPath: "opacity")
        animation.toValue = value
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        
        layer.opacity = 0
        layer.add(animation, forKey: "animateOpacity")
    }
    
    // MARK: Helper methods
    
    fileprivate func drawSquare(_ rect: CGRect, cornerRadius: CGFloat) -> UIBezierPath {
        
        let sizeRect: CGRect
        if cornerRadius <= rect.size.width {
            sizeRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)
        } else {
            sizeRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: 1, height: 1)
        }
        
        let borderPath = UIBezierPath(roundedRect: sizeRect, cornerRadius: cornerRadius)
        
        return borderPath
    }
}

//: ## Test Code

func addStroke(_ addition: UInt32, measurmentView: MeasurmentView) {
    if (addition > 60*5) {
        measurmentView.gradientStartColor = UIColor.yellow
        measurmentView.gradientEndColor = UIColor.green
        return
    }
    
    let delayTime = DispatchTime.now() + 0.5
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        
        let number = arc4random_uniform(60+addition) + 5;
        
        measurmentView.addStroke(CGFloat(number))
        addStroke(addition+5, measurmentView: measurmentView)
    }
}

let measurmentView = MeasurmentView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
measurmentView.strokeWidth = 8
measurmentView.spaceWidth = 2
measurmentView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
measurmentView.gradientEndColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
measurmentView.gradientStartColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

PlaygroundPage.current.liveView = measurmentView
addStroke(0, measurmentView: measurmentView)


//: [Previous](@previous) - [Next](@next)
