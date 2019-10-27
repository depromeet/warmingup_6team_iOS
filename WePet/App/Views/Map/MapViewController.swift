//
//  MapViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

protocol MapViewControllerType: AnyObject {
    func reload()
}

class MapViewController: BaseViewController {

    var presenter: MapPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MapViewController: MapViewControllerType {
    func reload() {
        
    }
}
