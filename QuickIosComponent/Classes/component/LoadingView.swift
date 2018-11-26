//
//  LoadingView.swift
//  StudioUser
//
//  Created by brownsoo han on 2017. 11. 29..
//  Copyright © 2017년 TLX. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    
    private var container: UIView!
    private var indicator: UIActivityIndicatorView!
    private var label: UILabel!
    
    var loading: Bool {
        get {
            return indicator.isAnimating
        }
        
        set {
            if newValue {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 400)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    var indicatorColor: UIColor = UIColor.white {
        didSet {
            indicator.color = indicatorColor
        }
    }
    
    var boxColor: UIColor = UIColor.black {
        didSet {
            container.backgroundColor = boxColor
        }
    }
    
    private func onInit() {
        container = UIView()
        container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        container.clipsToBounds = true
        container.layer.cornerRadius = 10.0
        self.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 170).isActive = true
        container.heightAnchor.constraint(equalToConstant: 170).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        indicator = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: indicator.superview!.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: indicator.superview!.centerYAnchor, constant: -8).isActive = true
        
        label = UILabel()
        self.addSubview(label)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Loading..."
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 12).isActive = true
    }
}

