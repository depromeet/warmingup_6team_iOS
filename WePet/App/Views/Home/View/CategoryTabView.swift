//
//  CategoryTabView.swift
//  WePet
//
//  Created by hb1love on 2019/10/27.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import Scope
import SnapKit

final class CategoryTabView: BaseView {

    // MARK: - Constants

    private struct Metric {
        static let spacing = 16.f
    }

    private struct Font {
        static let title = UIFont.systemFont(ofSize: 15, weight: .light)
    }

    // MARK: - Subviews

    private var contentStackView: UIStackView!
    private var buttons: [UIButton]!

    override func setupSubviews() {
        contentStackView = UIStackView().also {
            $0.axis = .horizontal
            $0.alignment = .top
            $0.distribution = .fill
            $0.spacing = Metric.spacing
            addSubview($0)
        }
        buttons = Category.allCases.map { category in
            return UIButton().also {
                $0.setTitle(category.title, for: .normal)
                $0.setTitleColor(UIColor(named: "gray_#BEBEBE"), for: .normal)
                $0.titleLabel?.font = Font.title
                $0.contentEdgeInsets = .zero
                contentStackView.addArrangedSubview($0)
            }
        }
        contentStackView.addArrangedSubview(UIView())
    }

    override func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.trailing.equalToSuperview()
        }
    }
}
