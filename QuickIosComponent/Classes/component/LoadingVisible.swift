//
//  LoadingVisible.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 2..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

public protocol LoadingVisible {
    var loadingView: LoadingView { get }
    func showLoading(_ container: UIView)
    func showLoading(_ container: UIView, text: String?)
    func showLoading(_ container: UIView, text: String?, indicatorColor: UIColor?)
    func showLoading(_ container: UIView, text: String?, indicatorColor: UIColor?, boxColor: UIColor?)
    func hideLoading()
}

public extension LoadingVisible {
    
    func showLoading(_ container: UIView) {
        self.showLoading(container, text: "Loading...", indicatorColor: nil, boxColor: nil)
    }

    func showLoading(_ container: UIView, text: String?) {
        self.showLoading(container, text: text, indicatorColor: nil, boxColor: nil)
    }

    func showLoading(_ container: UIView, text: String?, indicatorColor: UIColor?) {
        self.showLoading(container, text: text, indicatorColor: indicatorColor, boxColor: nil)
    }
    
    func showLoading(_ container: UIView,
                     text: String?,
                     indicatorColor: UIColor?,
                     boxColor: UIColor?) {
        
        DispatchQueue.main.async {
            self.loadingView.text = text
            self.loadingView.indicatorColor = indicatorColor ?? UIColor.white
            self.loadingView.boxColor = boxColor ?? UIColor.black.withAlphaComponent(0.5)
            self.loadingView.loading = true
            self.loadingView.frame = container.bounds

            container.addSubview(self.loadingView)
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
