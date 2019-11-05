//
//  BottomImageButton.swift
//  WePet
//
//  Created by 양혜리 on 02/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SnapKit

class BottomImageButton: UIControl {
    // MARK: - Public Property
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        configureStyle()
        createLayoutByAnchors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func configureStyle() {
        layer.cornerRadius = 4.0
        backgroundColor = .clear
    }
    
    private let height: CGFloat = 28.0
    
    private lazy var container: UIView = {
        let container = UIView()
        container.isUserInteractionEnabled = false
        addSubview(container)
        return container
    }()
    

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(named: "gray_#ACACAC")
        label.text = "리스트보기"
        label.isUserInteractionEnabled = true
        container.addSubview(label)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "list_bottomArrow"))
        imageView.isUserInteractionEnabled = true
        container.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Animation
    enum AnimationType {
        case whole
        case label
    }
    
    var animationType: AnimationType = .whole
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard self.isTouchInside, target != nil else {
            super.sendAction(action, to: target, for: event)
            return
        }
        
        switch animationType {
        case .label:
            label.layer.add(TapAnimation.animation(delegate: self), forKey: "tap")
        case .whole:
            layer.add(TapAnimation.animation(delegate: self), forKey: "tap")
        }
    }
    
    func createLayoutByAnchors() {
        container.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        label.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.bottom.equalTo(imageView.snp.top)
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
        }
    }
}


extension BottomImageButton: CAAnimationDelegate {

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.removeAnimation(forKey: "tap")
        sendActions(for: .touchUpInside)
    }
    
}
