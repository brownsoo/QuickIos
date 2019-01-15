//
//  LoadingView.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 29..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    
    private lazy var box = UIView()
    private lazy var indicator = UIActivityIndicatorView(style: .whiteLarge)
    private lazy var label = UILabel()
    
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
            box.backgroundColor = boxColor
        }
    }
    
    private func onInit() {
        self.addSubview(box)
        box.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        box.clipsToBounds = true
        box.layer.cornerRadius = 10.0
        box.translatesAutoresizingMaskIntoConstraints = false
        box.widthAnchor.constraint(equalToConstant: 170).isActive = true
        box.heightAnchor.constraint(equalToConstant: 170).isActive = true
        box.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        box.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: indicator.superview!.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: indicator.superview!.centerYAnchor, constant: -8).isActive = true

        self.addSubview(label)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Loading..."
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 12).isActive = true
    }
}

