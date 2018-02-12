//
//  ViewController.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/7/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var indicator: TypingView!
    
    override func loadView() {
        super.loadView()
        
        indicator = TypingView()
        indicator.layer.masksToBounds = true
        view.addSubview(indicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        indicator.startAnimating()
        
        perform(#selector(self.stopAnimating), with: self, afterDelay: 5.0)
    }
    
    @objc func stopAnimating() {
        indicator.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        var rect = CGRect.zero
        
        rect.size = CGSize(width: 64, height: 64)
        rect.origin.x = (view.bounds.width - rect.width) / 2
        rect.origin.y = (view.bounds.height - rect.height) / 2
        indicator.frame = rect
        indicator.layer.cornerRadius = min(rect.width, rect.height) / 2
    }
}

