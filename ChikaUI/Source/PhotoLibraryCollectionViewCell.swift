//
//  PhotoLibraryCollectionViewCell.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/2/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    var onToggleSelection: ((PhotoLibraryCollectionViewCell) -> Void)?
    
    var imageView: UIImageView!
    var selectButton: UIButton!
    
    var checkLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkLayer.isHidden = true
        onToggleSelection = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        rect = bounds
        imageView.frame = rect
        
        rect.size.width = 32
        rect.size.height = rect.width
        rect.origin.x = bounds.width - rect.width - 8
        rect.origin.y = 8
        selectButton.frame = rect
        selectButton.layer.cornerRadius = rect.width / 2
        
        rect = selectButton.bounds
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: rect.width * 0.25, y: rect.height * 0.56))
        checkPath.addLine(to: CGPoint(x: rect.width * 0.44, y: rect.height * 0.69))
        checkPath.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height * 0.25))
        checkLayer.path = checkPath.cgPath
        checkLayer.frame = rect
    }
    
    func isSelected(_ isSelected: Bool) {
        checkLayer.isHidden = !isSelected
    }
    
    private func initSetup() {
        imageView = UIImageView()
        
        selectButton = UIButton()
        selectButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        selectButton.layer.borderWidth = 1
        selectButton.layer.borderColor = UIColor.white.cgColor
        selectButton.layer.masksToBounds = true
        selectButton.addTarget(self, action: #selector(self.didTapSelect), for: .touchUpInside)
        
        checkLayer = CAShapeLayer()
        checkLayer.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.lineWidth = 2
        checkLayer.isHidden = true
        selectButton.layer.addSublayer(checkLayer)
        
        addSubview(imageView)
        addSubview(selectButton)
    }
    
    @objc
    private func didTapSelect() {
        onToggleSelection?(self)
    }
    
}
