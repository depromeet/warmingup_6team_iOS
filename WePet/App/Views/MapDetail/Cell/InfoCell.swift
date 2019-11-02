//
//  InfoCell.swift
//  WePet
//
//  Created by 양혜리 on 01/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

class InfoCell: BaseTableViewCell {
    typealias listClosure = () -> Void
    var sendEventToParent: listClosure?
    private struct Font {
        static let title = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let content = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let phoneNum = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let list = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    private lazy var timeTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "운영시간"
        label.font = Font.title
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var timeContent: UILabel = {
        let label: UILabel = UILabel()
        label.text = "매일 오전 09:00~오후 22:00"
        label.font = Font.content
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var callTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "전화번호"
        label.font = Font.title
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var callContent: UILabel = {
        let label: UILabel = UILabel()
        label.text = "관리센터"
        label.font = Font.content
        label.textAlignment = .center
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var callNumber: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(UIColor(named: "blue_#4B93FF"), for: .normal)
        button.setTitleColor(UIColor(named: "blue_#4B93FF"), for: .highlighted)
        button.setTitle("02-123-6235", for: .normal)
        button.setTitle("02-123-6235", for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        button.titleLabel?.font = Font.title
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var listButton: BottomImageButton = {
        let button: BottomImageButton = BottomImageButton()
        button.addTarget(self, action: #selector(pressedListButton), for: .touchUpInside)
        contentView.addSubview(button)
        return button
    }()

    override func setupConstraints() {
        
        timeTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(29.0)
            $0.trailing.equalTo(timeContent.snp.leading).offset(-24.0).priority(.high)
            $0.bottom.equalTo(callTitle.snp.top).offset(-12.0)
        }
        
        timeContent.snp.makeConstraints {
            $0.trailing.lessThanOrEqualToSuperview().offset(-28.0)
            $0.centerY.equalTo(timeTitle)
        }
        
        callTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29.0)
            $0.trailing.equalTo(callContent.snp.leading).offset(-24.0).priority(.high)
            $0.bottom.equalTo(listButton.snp.top).offset(-28.0)
        }
        
        callContent.snp.makeConstraints {
            $0.trailing.equalTo(callNumber.snp.leading).offset(-12.0)
            $0.centerY.equalTo(callTitle)
        }
        
        callNumber.snp.makeConstraints {
            $0.trailing.lessThanOrEqualToSuperview().offset(-24.0)
            $0.centerY.equalTo(callTitle)
        }

        listButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80.0)
            $0.bottom.equalToSuperview().offset(-11.0)
        }
    }
    
    @objc func pressedListButton() {
        sendEventToParent?()
    }
}
