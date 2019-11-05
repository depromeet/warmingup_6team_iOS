//
//  TapAnimation.swift
//  WePet
//
//  Created by 양혜리 on 02/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

protocol Animation {
    static func animation(delegate: CAAnimationDelegate?) -> CABasicAnimation
}

class TapAnimation: Animation {
    static func animation(delegate: CAAnimationDelegate? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.delegate = delegate
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.toValue = 0.85
        return animation
    }
}

