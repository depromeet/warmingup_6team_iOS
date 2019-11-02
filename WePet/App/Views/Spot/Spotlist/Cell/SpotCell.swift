//
//  SpotCell.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import Alamofire

final class SpotCell: BaseTableViewCell {

    // MARK: - Constants

    private struct Metric {
        static let thumbnailSize = 56.f
        static let thumbnailLeading = 20.f
        static let thumbnailTop = 12.f
        static let textStackViewSpacing = 3.f
        static let textStackViewLeading = 18.f
        static let nameStackViewSpacing = 5.f
        static let favoriteTop = 9.f
        static let favoriteTrailing = 13.f
        static let separatorHeight = 1.f
        static let separatorLeadingTrailing = 18.f
    }

    private struct Font {
        static let name = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let distance = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let address = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    // MARK: - Subviews

    private var thumbnailView: UIImageView!
    private var textStackView: UIStackView!
    private var favortieButton: UIButton!
    private var separatorView: UIView!

    // MARK: - Subviews(textStackView)

    private var nameStackView: UIStackView!
    private var addressLabel: UILabel!

    // MARK: - Subviews(nameStackView)

    private var nameLabel: UILabel!
    private var distanceLabel: UILabel!

    override func setupSubviews() {
        self.clipsToBounds = true
        thumbnailView = UIImageView().also {
            $0.layer.borderWidth = 0
            $0.clipsToBounds = true
            $0.image = UIImage(named: "sample")
            contentView.addSubview($0)
        }
        textStackView = UIStackView().also {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = Metric.textStackViewSpacing
            contentView.addSubview($0)
        }
        favortieButton = UIButton().also {
            $0.setImage(UIImage(named: "ic_favorite_inactive"), for: .normal)
            contentView.addSubview($0)
        }
        nameStackView = UIStackView().also {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = Metric.nameStackViewSpacing
            textStackView.addArrangedSubview($0)
        }
        nameLabel = UILabel().also {
            $0.numberOfLines = 1
            $0.textColor = UIColor(named: "black_#242424")
            $0.font = Font.name
            nameStackView.addArrangedSubview($0)
        }
        distanceLabel = UILabel().also {
            $0.numberOfLines = 1
            $0.textColor = UIColor(named: "blue_#4B93FF")
            $0.font = Font.distance
            $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            nameStackView.addArrangedSubview($0)
        }
        nameStackView.addArrangedSubview(UIView())
        addressLabel = UILabel().also {
            $0.numberOfLines = 2
            $0.textColor = UIColor(named: "gray_#ACACAC")
            $0.font = Font.address
            textStackView.addArrangedSubview($0)
        }
        separatorView = UIView().also {
            $0.backgroundColor = UIColor(named: "separator_bg")
            contentView.addSubview($0)
        }
    }

    override func setupConstraints() {
        thumbnailView.snp.makeConstraints {
            $0.width.height.equalTo(Metric.thumbnailSize)
            $0.top.equalToSuperview().offset(Metric.thumbnailTop)
            $0.bottom.equalToSuperview().offset(-Metric.thumbnailTop)
            $0.leading.equalToSuperview().offset(Metric.thumbnailLeading)
        }
        textStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(Metric.textStackViewLeading)
            $0.centerY.equalTo(thumbnailView)
            $0.trailing.lessThanOrEqualTo(favortieButton.snp.leading).offset(-Metric.favoriteTrailing)
        }
        favortieButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.favoriteTop)
            $0.trailing.equalToSuperview().offset(-Metric.favoriteTrailing)
        }
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Metric.separatorHeight)
            $0.leading.equalToSuperview().offset(Metric.separatorLeadingTrailing)
            $0.trailing.equalToSuperview().offset(-Metric.separatorLeadingTrailing)
        }
    }
}

extension SpotCell {
    func configure(spot: Spot?, isLast: Bool = false) {
        ImageLoader.image(for: spot?.photoUrl) { [weak self] image in
            self?.thumbnailView.image = image ?? UIImage(named: "sample")
        }
        thumbnailView.layer.cornerRadius = Metric.thumbnailSize / 2
        nameLabel.text = spot?.name
        distanceLabel.text = "125m"
        addressLabel.text = "서울 종로구 대학로8길 45-2"
        separatorView.isHidden = isLast
    }
}
