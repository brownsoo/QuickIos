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


        var bt = QuickButton()
        bt.setTitle("TITLE", for: .normal)
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("TITLE", for: .normal)
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("TITLE", for: .normal)
        bt.useGradient = true
        stack.addArrangedSubview(bt)

        bt = QuickButton()
        bt.setTitle("TITLE", for: .normal)
        bt.useGradient = true
        bt.isEnabled = false
        stack.addArrangedSubview(bt)

    }


}

