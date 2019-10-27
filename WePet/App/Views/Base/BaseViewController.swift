//
//  BaseViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setupSubviews() {}
    func setupConstraints() {}
}
