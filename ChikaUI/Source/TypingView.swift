//
//  TypingView.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/9/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class TypingView: UIView {
    
    var circles: [UIView] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    public override func layoutSubviews() {
        let width: CGFloat = 12
        let height: CGFloat = width
        let spacing: CGFloat = 4
        let totalWidth: CGFloat = (width * CGFloat(circles.count)) + (spacing * (CGFloat(circles.count - 1)))
        
        var rect = CGRect.zero
        rect.size = CGSize(width: width, height: height)
        rect.origin.x = (bounds.width - totalWidth) / 2
        rect.origin.y = (bounds.height - height) / 2
        
        circles.forEach { circle in
            circle.layer.cornerRadius = width / 2
            circle.frame = rect
            rect.origin.x += (width + spacing)
        }
    }
    
    @discardableResult
    public func startAnimating() -> Bool {
        guard isHidden else {
            return false
        }
        
        isHidden = false
        
        let delay: TimeInterval = 0.2;
        let duration: TimeInterval = 0.8;
        
        circles.enumerated().forEach { index, circle in
            let relativeDelay = TimeInterval(index) * delay
            let anim = createAnim(withDuration: duration, delay: relativeDelay)
            circle.layer.add(anim, forKey: "scale")
        }
        
        return true
    }
    
    @discardableResult
    public func stopAnimating() -> Bool {
        guard !isHidden else {
            return false
        }

        circles.forEach { circle in
            circle.layer.removeAnimation(forKey: "scale")
        }

        isHidden = true
        return true
    }
    
    private func createAnim(withDuration duration: TimeInterval, delay: TimeInterval) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.autoreverses = true
        anim.duration = duration
        anim.isRemovedOnCompletion = false
        anim.beginTime = CACurrentMediaTime() + delay
        anim.repeatCount = Float(CGFloat.infinity)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return anim
    }
    
    private func initSetup() {
        isHidden = true
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        for _ in 0..<3 {
            let circle = UIView()
            circle.backgroundColor = .gray
            circle.layer.masksToBounds = true
            circles.append(circle)
            addSubview(circle)
        }
    }
    
}
