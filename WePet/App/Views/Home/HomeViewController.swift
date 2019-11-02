//
//  HomeViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
import Scope

protocol HomeViewControllerType: AnyObject {
    func reloadTable()
    func setupCategories(_ categories: [Category])
    func configureCategory(_ category: Category)
    func configureWeather(_ weather: Weather)
}

final class HomeViewController: BaseViewController {

    // MARK: - Constants

    private struct Metric {
        static let stackLeading = 32.f
        static let stackTop = 80.f
        static let stackSpacing = 11.f
        static let logoHeight = 23.f
        static let categoryLeadingTrailing = 30.f
        static let categoryTableHeight = 270.f
        static let categorySpacing = 16.f
        static let categoryBottom = 89.f
        static let goMapWidth = 126.f
        static let goMapHeight = 40.f
    }

    private struct Font {
        static let intro = UIFont.systemFont(ofSize: 23, weight: .light)
        static let gotoMap = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }

    // MARK: - Subviews

    private var topStackView: UIStackView!
    private var logoImageView: UIImageView!
    private var spaceView: UIView!
    private var introTextLabel: UILabel!
    private var weatherView: WeatherView!
    private var categoryContainerView: UIStackView!
    private var categoryView: CategoryTabView!
    private var tableView: UITableView!
    private var mapButton: UIButton!

    // MARK: - Properties

    var presenter: HomePresenterType?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        requestLocationAuthorization()
    }

    override func setupSubviews() {
        topStackView = UIStackView().also {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = Metric.stackSpacing
            view.addSubview($0)
        }
        logoImageView = UIImageView().also {
            $0.image = UIImage(named: "ic_logo")
            topStackView.addArrangedSubview($0)
        }
        spaceView = UIView().also {
            topStackView.addArrangedSubview($0)
        }
        introTextLabel = UILabel().also {
            $0.alpha = 0
            $0.textColor = UIColor(named: "black_#242424")
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.font = Font.intro
            $0.transform = CGAffineTransform(translationX: 0, y: 20)
            topStackView.addArrangedSubview($0)
        }
        weatherView = WeatherView().also {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 40)
            topStackView.addArrangedSubview($0)
        }
        categoryContainerView = UIStackView().also {
            $0.alpha = 0
            $0.axis = .vertical
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = Metric.categorySpacing
            view.addSubview($0)
        }
        categoryView = CategoryTabView().also {
            $0.delegate = self
            categoryContainerView.addArrangedSubview($0)
        }
        tableView = UITableView().also {
            $0.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.layer.borderColor = UIColor(named: "white_#EFEFEF")?.cgColor
            $0.layer.borderWidth = 1.5
            $0.layer.cornerRadius = 10
            categoryContainerView.addArrangedSubview($0)
        }
        mapButton = UIButton().also {
            $0.alpha = 0
            $0.backgroundColor = UIColor(named: "blue_#4B93FF")
            $0.titleLabel?.font = Font.gotoMap
            $0.setTitle("지도로 보기", for: .normal)
            $0.setTitleColor(UIColor(named: "white_#EFEFEF"), for: .normal)
            $0.addTarget(self, action: #selector(gotoMap), for: .touchUpInside)
            view.addSubview($0)
        }
    }

    override func setupConstraints() {
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.stackTop)
            $0.leading.equalToSuperview().offset(Metric.stackLeading)
        }
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(Metric.logoHeight)
        }
        spaceView.snp.makeConstraints {
            $0.height.equalTo(17)
        }
        categoryContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metric.categoryLeadingTrailing)
            $0.trailing.equalToSuperview().offset(-Metric.categoryLeadingTrailing)
            $0.bottom.equalToSuperview().offset(-Metric.categoryBottom)
        }
        categoryView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(30)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Metric.categoryTableHeight)
        }
        mapButton.snp.makeConstraints {
            $0.height.equalTo(Metric.goMapHeight)
            $0.width.equalTo(Metric.goMapWidth)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(categoryContainerView.snp.bottom)
        }
        mapButton.layer.cornerRadius = Metric.goMapHeight / 2
    }
}

extension HomeViewController: HomeViewControllerType {
    func reloadTable() {
        tableView.reloadData()
        showCategoryContainer()
    }

    func setupCategories(_ categories: [Category]) {
        categoryView.setupButtons(categories: categories)
    }

    func configureCategory(_ category: Category) {
        categoryView.configure(category: category)
    }

    func configureWeather(_ weather: Weather) {
        introTextLabel.text = weather.type?.introText
        weatherView.configure(weather: weather)
        showWeatherView()
    }
}

extension HomeViewController: CategoryTabDelegate {
    func categoryTab(_ categoryTab: CategoryTabView, didSelect category: Category) {
        presenter?.didSelectCategory(category)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.spots.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        let isLast = presenter?.spots.count == indexPath.row + 1
        cell.configure(spot: presenter?.spots[indexPath.row], isLast: isLast)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let spot = presenter?.spots[indexPath.row] else { return }
        let mapService = MapService(networking: MapNetworking())
        let view = SpotDetailViewController.controllerFromStoryboard("SpotDetail")
        let presenter = SpotDetailPresenter(
            view: view,
            mapService: mapService,
            spot: spot
        )
        view.presenter = presenter
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startMonitoringLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let location = Location(
            latitude: visit.coordinate.latitude,
            longitude: visit.coordinate.longitude
        )
        presenter?.didVisit(location)
    }
}

extension HomeViewController {
    func requestLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied, .restricted:
            log.error("Authorization Status Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            startMonitoringLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    func startMonitoringLocation() {
        #if DEBUG
            presenter?.didVisit(Location.startupHub)
        #else
            locationManager.startMonitoringVisits()
        #endif
    }

    @objc func gotoMap() {
        let mapService = MapService(networking: MapNetworking())
        let view = MapViewController()
        let presenter = MapPresenter(
            view: view,
            mapService: mapService,
            categories: []
        )
        view.presenter = presenter
        self.navigationController?.pushViewController(view, animated: true)
    }

    func showCategoryContainer() {
        UIView.animate(withDuration: 0.2) {
            self.categoryContainerView.alpha = 1
            self.mapButton.alpha = 1
        }
    }

    func showWeatherView() {
        UIView.animate(
            withDuration: 1.5,
            delay: 0.1,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.introTextLabel.transform = .identity
                self.introTextLabel.alpha = 1
                self.weatherView.transform = .identity
                self.weatherView.alpha = 1
            }
        )
    }
}
