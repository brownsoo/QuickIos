//
//  ViewController.swift
//  QuickIosExample-iOS
//
//  Created by brownsoo han on 27/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import QuickIosComponent

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let stack = UIStackView()
        view.addSubview(stack)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true

        let lb = UILabel()
        lb.text = "QuickButton"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stack.addArrangedSubview(lb)

        var bt = QuickButton()
        bt.setTitle("Default", for: .normal)
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: disabled", for: .normal)
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: gradient", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.setTitleColor(UIColor.lightGray, for: .highlighted)
        bt.useGradient = true
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("Default: gradient, disabled", for: .normal)
        bt.useGradient = true
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

    }


}

