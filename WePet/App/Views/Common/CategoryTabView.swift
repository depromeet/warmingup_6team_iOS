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

protocol CategoryTabDelegate: AnyObject {
    func categoryTab(_ categoryTab: CategoryTabView, didSelect category: Category)
}

final class CategoryTabView: BaseView {

    // MARK: - Constants

    private struct Metric {
        static let spacing = 14.f
        static let underlineHeight = 2.f
    }

    private struct Font {
        static let selected = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let deselected = UIFont.systemFont(ofSize: 15, weight: .light)
    }

    // MARK: - Subviews

    private var contentStackView: UIStackView!
    private var buttons: [UIButton]!
    private var underlineView: UIView!

    var delegate: CategoryTabDelegate?

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
                $0.tag = category.rawValue
                $0.setTitle(category.title, for: .normal)
                $0.addTarget(self, action: #selector(didTapCategory(_:)), for: .touchUpInside)
                $0.titleLabel?.font = Font.deselected
                $0.contentEdgeInsets = .zero
                contentStackView.addArrangedSubview($0)
            }
        }
        contentStackView.addArrangedSubview(UIView())
        underlineView = UIView().also {
            addSubview($0)
        }
    }

    override func setupConstraints() {
        contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.trailing.equalToSuperview()
        }
        underlineView.snp.makeConstraints {
            $0.height.equalTo(Metric.underlineHeight)
            $0.bottom.equalToSuperview()
        }
    }

    func configure(category: Category) {
        guard let button = buttons.first(where: { $0.tag == category.rawValue }) else { return }
        updateTabState(target: button)
        setupUnderline(target: button)
    }
}

private extension CategoryTabView {
    @objc func didTapCategory(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let category = Category(rawValue: button.tag) else { return }
        updateTabState(target: button)
        updateUnderline(target: button)
        delegate?.categoryTab(self, didSelect: category)
    }

    func updateTabState(target: UIButton) {
        buttons.forEach {
            $0.setTitleColor(UIColor(named: "gray_#BEBEBE"), for: .normal)
            $0.titleLabel?.font = Font.deselected
        }
        let selected = buttons.first(where: { $0 == target })
        selected?.setTitleColor(UIColor(named: "blue_#4B93FF"), for: .normal)
        selected?.titleLabel?.font = Font.selected
    }

    func setupUnderline(target: UIButton) {
        underlineView.backgroundColor = UIColor(named: "blue_#4B93FF")
        underlineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(target)
        }
        layoutIfNeeded()
    }

    func updateUnderline(target: UIButton) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.underlineView.snp.remakeConstraints {
                    $0.leading.trailing.equalTo(target)
                    $0.height.equalTo(Metric.underlineHeight)
                    $0.bottom.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
        )
    }
}
