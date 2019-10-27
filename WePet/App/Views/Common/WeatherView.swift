//
//  WeatherView.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SnapKit

final class WeatherView: BaseView {

    // MARK: - Constants
    
    private struct Metric {
        static let padding = 8.f
    }

    private var weatherLabel: UILabel!

    override func setupSubviews() {
        backgroundColor =  UIColor(named: "weather_bg")
        weatherLabel = UILabel().also {
            $0.text = "21º 구름약간"
            addSubview($0)
        }
    }

    override func setupConstraints() {
        weatherLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(Metric.padding)
            $0.trailing.bottom.equalToSuperview().offset(-Metric.padding)
        }
    }
}
