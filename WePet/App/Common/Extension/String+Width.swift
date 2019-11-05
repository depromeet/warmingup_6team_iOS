//
//  String+Width.swift
//  WePet
//
//  Created by 양혜리 on 06/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

extension String {
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .semibold)], context: nil)
        return ceil(boundingBox.width)
    }
}

