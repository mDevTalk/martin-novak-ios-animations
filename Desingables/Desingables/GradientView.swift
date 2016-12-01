//
//  GradientView.swift
//  
//
//  Created by Novák Martin on 21/11/16.
//
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var gradientStartColor: UIColor = UIColor.green {
        didSet {
            gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = UIColor.blue {
        didSet {
            gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            gradientLayer.cornerRadius = cornerRadius
        }
    }
    
    fileprivate var gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradientLayer.cornerRadius = cornerRadius
    }
}
