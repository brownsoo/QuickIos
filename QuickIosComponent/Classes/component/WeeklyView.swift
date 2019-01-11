//
//  WeeklyView.swift
//

import UIKit

/// 주단위 달력
/// TODO: 컴포넌트로 분리
open class WeeklyView: UICollectionView {
    
    public private(set) var isTouching: Bool = false
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        super.touchesCancelled(touches, with: event)
    }
}
