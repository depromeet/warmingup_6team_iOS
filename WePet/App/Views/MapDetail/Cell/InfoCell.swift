//
//  InfoCell.swift
//  WePet
//
//  Created by 양혜리 on 01/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

class InfoCell: BaseTableViewCell {
    private struct Font {
        static let title = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let content = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let phoneNum = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let list = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }

    
    private lazy var topStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 24.0
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var timeTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "운영시간"
        label.font = Font.title
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var timeContent: UILabel = {
        let label: UILabel = UILabel()
        label.text = "매일 오전 09:00~오후 22:00"
        label.font = Font.content
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 24.0
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var callTitle: UILabel = {
        let label: UILabel = UILabel()
        label.text = "전화번호"
        label.font = Font.title
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var callStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        return stackView
    }()
    
    private lazy var callContent: UILabel = {
        let label: UILabel = UILabel()
        label.text = "관리센터"
        label.font = Font.content
        label.textAlignment = .center
        label.textColor = UIColor(named: "black_#555559")
        label.numberOfLines = 1
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
        return button
    }()
    
    private lazy var listButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setTitleColor(UIColor(named: "gray_#ACACAC"), for: .normal)
        button.setTitleColor(UIColor(named: "gray_#ACACAC"), for: .highlighted)
        button.setTitle("리스트보기", for: .normal)
        button.setTitle("리스트보기", for: .highlighted)
        button.setImage(UIImage(named: "invalidName"), for: .normal)
        button.setImage(UIImage(named: "invalidName"), for: .highlighted)
        button.titleLabel?.font = Font.list
        
        let spacing: CGFloat = 30.0
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0);
        button.contentVerticalAlignment = .top
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        return button
    }()

    override func setupSubviews() {
        topStackView.addArrangedSubview(timeTitle)
        topStackView.addArrangedSubview(timeContent)
        callStackView.addArrangedSubview(callContent)
        callStackView.addArrangedSubview(callNumber)
        bottomStackView.addArrangedSubview(callTitle)
        bottomStackView.addArrangedSubview(callStackView)
    }
    
    override func setupConstraints() {
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(29.0)
            $0.trailing.equalToSuperview().offset(-29.0)
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-12.0)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(29.0)
            $0.trailing.equalToSuperview().offset(-29.0)
            $0.bottom.equalTo(listButton.snp.top).offset(-28.0)
        }

        listButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
}
