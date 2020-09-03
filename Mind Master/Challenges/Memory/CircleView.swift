//
//  CircleView.swift
//  Mind Master
//
//  Created by Jia Rui Shan on 2020/9/3.
//  Copyright © 2020 Calpha Dev. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    /// The radius of the circle.
    dynamic var radius: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    /// The color of the circle.
    var color: UIColor = AppColors.label {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// How much additional space to pad the sides of the circle from the edge of the view.
    var padding: CGFloat = 5.0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: (radius + padding) * 2, height: (radius + padding) * 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        isUserInteractionEnabled = false
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: CGRect(x: padding,
                                                     y: padding,
                                                     width: radius * 2,
                                                     height: radius * 2))
        color.setFill()
        circlePath.fill()
        
    }
}
