//
//  ContactTableViewCell.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import SDWebImage

class ContactTableViewCell: UITableViewCell {
    
    var onSelectorToggled: ((ContactTableViewCell) -> Void)?
    
    var avatarView: UIImageView!
    var presenceView: UIView!
    var selectorButton: UIButton!
    var displayNameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier id: String?) {
        super.init(style: style, reuseIdentifier: id)
        self.initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(style: .default, reuseIdentifier: "ContactTableViewCell")
        self.initSetup()
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "ContactTableViewCell")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectorButton.isHidden = true
        onSelectorToggled = nil
    }
    
    override func layoutSubviews() {
        var rect = CGRect.zero
        
        let spacing: CGFloat = 8
        let selectorButtonSize: CGSize = CGSize(width: 32, height: 32)
        
        rect.size = CGSize(width: 40, height: 40)
        rect.origin.x = spacing
        rect.origin.y = (bounds.height - rect.height) / 2
        avatarView.frame = rect
        avatarView.layer.cornerRadius = min(rect.width, rect.height) / 2
        
        rect.size = CGSize(width: 20, height: 20)
        rect.origin.x = avatarView.frame.minX
        rect.origin.y = avatarView.frame.maxY - rect.height
        presenceView.frame = rect
        presenceView.layer.cornerRadius = min(rect.width, rect.height) / 2
        
        rect.origin.x = avatarView.frame.maxX + spacing
        rect.size.width = bounds.width - rect.minX - (selectorButton.isHidden ? spacing : selectorButtonSize.width + spacing * 2)
        rect.size.height = displayNameLabel.sizeThatFits(rect.size).height
        rect.origin.y = (bounds.height - rect.height) / 2
        displayNameLabel.frame = rect
        
        if !selectorButton.isHidden {
            rect.size = selectorButtonSize
            rect.origin.x = bounds.width - rect.width - spacing
            rect.origin.y = (bounds.height - rect.height) / 2
            selectorButton.frame = rect
            selectorButton.layer.cornerRadius = min(rect.width, rect.height) / 2
        }
    }
    
    @discardableResult
    func layout(withItem item: ContactTableViewCellItem?, isSelectionEnabled: Bool, isSelected: Bool, isPrototype: Bool = false) -> Bool {
        guard let item = item else {
            return false
        }
        
        if !isPrototype {
            avatarView.sd_setImage(
                with: URL(string: item.avatarURL),
                placeholderImage: #imageLiteral(resourceName: "avatar"),
                options: .cacheMemoryOnly,
                progress: nil, completed: nil)
        }
        
        presenceView.isHidden = !item.isActive
        selectorButton.isHidden = !isSelectionEnabled
        displayNameLabel.text = item.displayName
        
        if isSelectionEnabled {
            var bgColor = UIColor.clear
            if isSelected {
                bgColor = .black
                if let color = selectorButton.layer.borderColor {
                    bgColor = UIColor(cgColor: color)
                }
            }
            selectorButton.backgroundColor = bgColor
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        return true
    }
    
    func applyTheme(_ theme: ContactTableViewCellTheme?) {
        if let color = theme?.onlineStatusColor {
            presenceView.backgroundColor = color
        }
        
        if let color = theme?.avatarBGColor {
            avatarView.backgroundColor = color
        }
        
        if let color = theme?.avatarBorderColor {
            avatarView.layer.borderColor = color.cgColor
        }
        
        if let font = theme?.displayNameFont {
            displayNameLabel.font = font
        }
        
        if let color = theme?.displayNameTextColor {
            displayNameLabel.textColor = color
        }
        
        if let color = theme?.selectorBorderColor {
            selectorButton.layer.borderColor = color.cgColor
        }
        
        if let color = theme?.selectorTintColor {
            selectorButton.tintColor = color
        }
    }
    
    func initSetup() {
        selectionStyle = .none
        
        avatarView = UIImageView()
        avatarView.layer.borderWidth = 1
        avatarView.layer.masksToBounds = true
        
        presenceView = UIView()
        presenceView.layer.masksToBounds = true
        
        selectorButton = UIButton()
        selectorButton.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
        selectorButton.setImage(#imageLiteral(resourceName: "check_icon"), for: .highlighted)
        selectorButton.addTarget(self, action: #selector(self.toggleSelector), for: .touchUpInside)
        selectorButton.layer.borderWidth = 1
        selectorButton.layer.masksToBounds = true
            
        displayNameLabel = UILabel()
        displayNameLabel.numberOfLines = 0
        
        applyTheme(ContactTableViewCellTheme())
        
        addSubview(avatarView)
        addSubview(presenceView)
        addSubview(selectorButton)
        addSubview(displayNameLabel)
    }
    
    @objc func toggleSelector() {
        onSelectorToggled?(self)
    }
    
}
