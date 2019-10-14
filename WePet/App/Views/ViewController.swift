//
//  ViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/12.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapService = MapService(networking: MapNetworking())
        mapService.getSpots { result in
            switch result {
            case .success(let spots):
                print(spots)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
