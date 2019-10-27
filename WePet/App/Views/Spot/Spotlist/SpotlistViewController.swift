//
//  SpotlistViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import Scope
import SnapKit

protocol SpotlistViewControllerType: AnyObject {
    func reload()
}

final class SpotlistViewController: BaseViewController {

    // MARK: - Subviews

    private var tableView: UITableView!

    // MARK: - Properties

    var presenter: SpotlistPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func setupSubviews() {
        tableView = UITableView().also {
            $0.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SpotlistViewController: SpotlistViewControllerType {
    func reload() {
        tableView.reloadData()
    }
}

extension SpotlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.spots.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        cell.configure(spot: presenter?.spots[indexPath.row])
        return cell
    }
}
