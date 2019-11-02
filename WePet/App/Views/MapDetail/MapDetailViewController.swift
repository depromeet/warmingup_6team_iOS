//
//  MapDetailViewController.swift
//  WePet
//
//  Created by 양혜리 on 01/11/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

protocol MapDetailViewControllerType: AnyObject {
    func reload()
}

class MapDetailViewController: BaseViewController {
    
    var presenter: MapDetailPresenterType?
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationConstarint()
    }
    
    func configurationConstarint() {
        tableView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension MapDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
            cell.configure(spot: presenter?.spot, isLast: false)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MapDetailViewController: MapDetailViewControllerType {
    func reload() {
        tableView.reloadData()
    }
}
