//
//  CategoryCell.swift
//  WePet
//
//  Created by 양혜리 on 04/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SnapKit

struct CellData {
    let isSelect: Bool
    let content: String
    
    init(content: String, isSelect: Bool) {
        self.content = content
        self.isSelect = isSelect
    }
}

class CategoryCell: UICollectionViewCell {

    var cellData: CellData? {
        didSet {
            guard let data = cellData else {
                return
            }
            if data.isSelect {
                contentView.backgroundColor = UIColor(named: "blue_#4B93FF")
                contentLabel.textColor = .white
            } else {
                contentView.backgroundColor = .white
                contentLabel.textColor = UIColor(named: "black_#555559")
            }
            contentLabel.text = data.content
        }
    }
    
    private lazy var contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        label.numberOfLines = 1
        label.backgroundColor = .clear
        contentView.addSubview(label)
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.layer.cornerRadius = 17.0
        createLayoutByAnchors()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
        contentLabel.text = ""
    }
    
    private func createLayoutByAnchors() {
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15.0)
            $0.trailing.equalToSuperview().offset(-15.0)
            $0.top.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }
    }
}
