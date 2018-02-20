//
//  SelectedContactCarouselCell.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/16/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import SDWebImage

class SelectedContactCarouselCell: UICollectionViewCell {
    
    var avatarView: UIImageView!
    var removeButton: UIButton!
    var displayNameLabel: UILabel!
    
    var minusIconLayer: CAShapeLayer!
    
    var onRemove: ((SelectedContactCarouselCell) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onRemove = nil
    }
    
    override func layoutSubviews() {
        let spacing: CGFloat = 8
        
        var rect = CGRect.zero
        
        rect.size = CGSize(width: 64, height: 64)
        rect.origin.x = (bounds.width - rect.width) / 2
        rect.origin.y = spacing
        avatarView.frame = rect
        avatarView.layer.cornerRadius = min(rect.width, rect.height) / 2
        
        rect.origin.x = spacing
        rect.origin.y = avatarView.frame.maxY + spacing
        rect.size.width = bounds.width - rect.minX * 2
        rect.size.height = displayNameLabel.sizeThatFits(rect.size).height
        displayNameLabel.frame = rect
        
        rect.size = CGSize(width: 20, height: 20)
        rect.origin.y = avatarView.frame.minY
        rect.origin.x = avatarView.frame.maxX - rect.width
        removeButton.frame = rect
        removeButton.layer.cornerRadius = min(rect.width, rect.height) / 2
        
        rect.origin.x = 4
        rect.size.width = removeButton.frame.width - rect.minX * 2
        rect.size.height = 1
        rect.origin.y = (removeButton.frame.height - rect.height) / 2
        let path = UIBezierPath(rect: rect)
        minusIconLayer.path = path.cgPath
    }
    
    func initSetup() {
        avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFit
        avatarView.layer.borderWidth = 1
        avatarView.layer.masksToBounds = true
        
        removeButton = UIButton()
        removeButton.backgroundColor = .clear
        removeButton.addTarget(self, action: #selector(self.didTapRemove), for: .touchUpInside)
        removeButton.layer.masksToBounds = true
        
        displayNameLabel = UILabel()
        displayNameLabel.textAlignment = .center
        displayNameLabel.numberOfLines = 2
        
        minusIconLayer = CAShapeLayer()
        
        removeButton.layer.addSublayer(minusIconLayer)
        
        addSubview(avatarView)
        addSubview(removeButton)
        addSubview(displayNameLabel)
        
        applyTheme(SelectedContactCarouselCellTheme())
    }
    
    @discardableResult
    func applyTheme(_ theme: SelectedContactCarouselCellTheme?) -> Bool {
        guard let theme = theme else {
            return false
        }
        
        var ok = false
        
        if let color = theme.backgroundColor {
            backgroundColor = color
            ok = true
        }
        
        if let color = theme.avatarBGColor {
            avatarView.backgroundColor = color
            ok = true
        }
        
        if let color = theme.avatarBorderColor {
            avatarView.layer.borderColor = color.cgColor
            ok = true
        }
        
        if let font = theme.displayNameFont {
            displayNameLabel.font = font
            ok = true
        }
        
        if let color = theme.displayNameTextColor {
            displayNameLabel.textColor = color
            ok = true
        }
        
        if let color = theme.removeActionBGColor {
            removeButton.backgroundColor = color
            ok = true
        }
        
        if let color = theme.removeActionMinusIconTintColor {
            minusIconLayer.fillColor = color.cgColor
            ok = true
        }
        
        return ok
    }
    
    @discardableResult
    func layout(withItem item: SelectedContactCarouselCellItem?) -> Bool {
        guard let item = item else {
            return false
        }
        
        avatarView.sd_setImage(
            with: URL(string: item.avatarURL),
            placeholderImage: #imageLiteral(resourceName: "avatar"),
            options: .cacheMemoryOnly,
            progress: nil,
            completed: nil)
        
        displayNameLabel.text = item.displayName
        
        setNeedsLayout()
        layoutIfNeeded()
        
        return true
    }
    
    func layout(withPlaceholderText text: String?) {
        avatarView.image = #imageLiteral(resourceName: "avatar")
        removeButton.isHidden = true
        displayNameLabel.text = text
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func didTapRemove() {
        onRemove?(self)
    }
    
}
