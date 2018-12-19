//
//  LoadingIndicatable.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 2..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

public protocol LoadingIndicatable {
    var loadingView: LoadingView { get }
    func showLoading(_ container: UIView)
    func showLoading(_ container: UIView, indicatorColor: UIColor)
    func showLoading(_ container: UIView, indicatorColor: UIColor?, boxColor: UIColor?)
    func hideLoading()
}

public extension LoadingIndicatable {
    
    func showLoading(_ container: UIView) {
        self.showLoading(container, indicatorColor: nil, boxColor: nil)
    }
    
    func showLoading(_ container: UIView,
                     indicatorColor: UIColor) {
        self.showLoading(container, indicatorColor: indicatorColor, boxColor: nil)
    }
    
    func showLoading(_ container: UIView,
                     indicatorColor: UIColor?,
                     boxColor: UIColor?) {
        
        DispatchQueue.main.async {
            self.loadingView.indicatorColor = indicatorColor ?? UIColor.white
            self.loadingView.boxColor = boxColor ?? UIColor.black.withAlphaComponent(0.5)
            container.addSubview(self.loadingView)
            container.bringSubviewToFront(self.loadingView)
            self.loadingView.translatesAutoresizingMaskIntoConstraints = false
            self.loadingView.widthAnchor.constraint(equalToConstant: 170).isActive = true
            self.loadingView.heightAnchor.constraint(equalToConstant: 170).isActive = true
            self.loadingView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
            self.loadingView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            self.loadingView.loading = true
        }
    }
    
    func hideLoading() {
        if self.loadingView.superview == nil {
            return
        }
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
    }
}
