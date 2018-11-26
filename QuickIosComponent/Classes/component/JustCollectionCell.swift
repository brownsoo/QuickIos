//
//  BaseCollectionCell.swift
//  StudioBase
//
//  Created by hyonsoo han on 2018. 6. 18..
//  Copyright © 2018년 StudioMate. All rights reserved.
//

import UIKit

open class JustCollectionCell: UICollectionViewCell {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    
    open func onInit() {
    }
    
}
