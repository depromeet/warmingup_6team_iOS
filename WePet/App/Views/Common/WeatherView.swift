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
        static let topBottom = 6.f
        static let leadingTrailing = 12.f
    }

    private struct Font {
        static let temperature = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let displayName = UIFont.systemFont(ofSize: 13, weight: .ultraLight)
    }

    // MARK: - Subviews

    private var weatherLabel: UILabel!

    override func setupSubviews() {
        backgroundColor = UIColor(named: "weather_bg")
        weatherLabel = UILabel().also {
            addSubview($0)
        }
    }

    override func setupConstraints() {
        weatherLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.topBottom)
            $0.bottom.equalToSuperview().offset(-Metric.topBottom)
            $0.leading.equalToSuperview().offset(Metric.leadingTrailing)
            $0.trailing.equalToSuperview().offset(-Metric.leadingTrailing)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

    func configure(weather: Weather) {
        let weatherAttributedString = NSMutableAttributedString(string: "")

        let attachment = NSTextAttachment()
        attachment.image = weather.type?.icon
        let weatherIconString = NSAttributedString(attachment: attachment)
        weatherAttributedString.append(weatherIconString)

        let temperature = " " + (weather.temperature?.appending("º ") ?? "")
        weatherAttributedString.append(
            makeAttributedString(
                text: temperature,
                font: Font.temperature,
                color: UIColor(named: "black_#383740")!
            )
        )
        let displayName = " " + (weather.type?.displayName ?? "")
        weatherAttributedString.append(
            makeAttributedString(
                text: displayName,
                font: Font.displayName,
                color: UIColor(named: "black_#242424")!
            )
        )

        weatherLabel.attributedText = weatherAttributedString
    }

    func makeAttributedString(text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color
            ]
        )
    }
}
