//
//  ContactTableViewCellPlaceholder.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/14/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class ContactTableViewCellPlaceholder: UITableViewCell {
    
    var nameLayer: CALayer!
    var avatarLayer: CALayer!
    var animatedLayer1: CALayer!
    var animatedLayer2: CALayer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier id: String?) {
        super.init(style: style, reuseIdentifier: id)
        self.initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(style: .default, reuseIdentifier: "ContactTableViewCellPlaceholder")
        self.initSetup()
    }
    
    override func layoutSubviews() {
        animatedLayer1.frame = bounds
        animatedLayer2.frame = bounds
        
        let spacing: CGFloat = 8

        var rect = CGRect.zero

        rect.size = CGSize(width: 40, height: 40)
        rect.origin.x = spacing
        rect.origin.y = (bounds.height - rect.height) / 2
        avatarLayer.frame = rect
        avatarLayer.cornerRadius = min(rect.width, rect.height) / 2

        rect.size.height = 8
        rect.origin.x = avatarLayer.frame.maxX + spacing
        rect.size.width = bounds.width - rect.minX - spacing
        rect.origin.y = (bounds.height - rect.height) / 2
        nameLayer.frame = rect
  
        animatedLayer1.mask = avatarLayer
        animatedLayer2.mask = nameLayer
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatarLayer = CALayer()
        avatarLayer.masksToBounds = true
        avatarLayer.backgroundColor = UIColor.black.cgColor
        
        nameLayer = CALayer()
        nameLayer.masksToBounds = true
        nameLayer.backgroundColor = UIColor.black.cgColor
        
        animatedLayer1 = createAnimatedLayer()
        animatedLayer2 = createAnimatedLayer()
        
        layer.addSublayer(animatedLayer1)
        layer.addSublayer(animatedLayer2)
    }
    
    func createAnimatedLayer() -> CALayer {
        let gradientWidth: CGFloat = 0.17
        let gradientFirstStop: CGFloat = 0.1
        let loaderDuration: TimeInterval = 0.85
        
        let gradient = CAGradientLayer()
        gradient.masksToBounds = true
        gradient.colors = [
            UIColor(red: (246.0/255.0), green: (247.0/255.0), blue: (248.0/255.0), alpha: 1).cgColor,
            UIColor(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0).cgColor,
            UIColor(red: (221.0/255.0), green: (221.0/255.0), blue:(221.0/255.0) , alpha: 1.0).cgColor,
            UIColor(red: (238.0/255.0), green: (238.0/255.0), blue: (238.0/255.0), alpha: 1.0).cgColor,
            UIColor(red: (246.0/255.0), green: (247.0/255.0), blue: (248.0/255.0), alpha: 1).cgColor,
        ]
        gradient.startPoint = CGPoint(x: -1.0 + gradientWidth, y: 0)
        gradient.endPoint = CGPoint(x: 1.0 + gradientWidth, y: 0)
        
        let fromValue = [
            gradient.startPoint.x,
            gradient.startPoint.x,
            0,
            gradientWidth,
            gradientWidth + 1,
            ].map({ Double($0) }).map({ NSNumber(value: $0) })
        
        let toValue = [
            0,
            1,
            1,
            1 + (gradientWidth - gradientFirstStop),
            1 + gradientWidth,
            ].map({ Double($0) }).map({ NSNumber(value: $0) })
        
        gradient.locations = fromValue
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.fromValue = fromValue
        gradientChangeAnimation.toValue = toValue
        gradientChangeAnimation.repeatCount = Float(CGFloat.infinity)
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.duration = loaderDuration
        gradientChangeAnimation.autoreverses = true
        gradient.add(gradientChangeAnimation, forKey: "locations")
        
        return gradient
    }
    
}
