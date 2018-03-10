//
//  AvatarSelectorHeaderView.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/10/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class AvatarSelectorHeaderView: UIView {

    var circlePadding: CGFloat = 20
    var circleView: UIView!
    var circleMaskLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        subviews.forEach { subview in
            subview.frame = bounds
        }
        
        let radius = (min(bounds.width, bounds.height) / 2) - circlePadding
        let rect = CGRect(x: bounds.midX - radius, y: bounds.midY - radius, width: radius * 2, height: radius * 2)
        let path = UIBezierPath(rect: bounds)
        path.append(UIBezierPath(ovalIn: rect))
        circleMaskLayer.path = path.cgPath
        circleMaskLayer.frame = bounds
        circleView.layer.mask = circleMaskLayer
        
        bringSubview(toFront: circleView)
    }
    
    func initSetup() {
        circleView = UIView()
        circleView.isUserInteractionEnabled = false
        circleView.backgroundColor = .white
        
        circleMaskLayer = CAShapeLayer()
        circleMaskLayer.fillRule = kCAFillRuleEvenOdd
        circleMaskLayer.fillColor = UIColor.black.cgColor
        
        circleView.layer.addSublayer(circleMaskLayer)
        
        addSubview(circleView)
    }
    
}
