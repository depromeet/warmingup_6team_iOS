//
//  MapViewController.swift
//  WePet
//
//  Created by hb1love on 2019/10/26.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import CoreLocation
import DropDown

protocol MapViewControllerType: AnyObject {
    func reload()
}

class MapViewController: BaseViewController {
    
    var presenter: MapPresenterType?
    private let bottomSheetViewController = BottomSheetViewController()
    private let mapDetailViewController = MapDetailViewController()
    private var previousMarker: GMSMarker?
    private let locationManager = CLLocationManager()
    
    private lazy var dropButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "bottomArrow"), for: .normal)
        button.setImage(UIImage(named: "bottomArrow"), for: .highlighted)
        button.setTitle("300m", for: .normal)
        button.setTitle("300m", for: .highlighted)
        button.backgroundColor = UIColor(named: "black_#555559")
        button.layer.cornerRadius = 17.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: -6.0)
        button.addTarget(self, action: #selector(pressedDropButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private lazy var dropDown: DropDown = {
        let dropDown: DropDown = DropDown()
        dropDown.anchorView = dropButton
        dropDown.dataSource = ["300m","500m","1km"]
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.presenter?.didSelectDistance(index)
            self?.dropButton.setTitle(item, for: .normal)
            self?.dropButton.setTitle(item, for: .highlighted)
        }
        view.addSubview(dropDown)
        return dropDown
    }()
    
    private var collectionLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 200, height: 35)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        let collectionViewFrame = CGRect(origin: .zero, size: size)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.contentInset = .zero
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        view.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.setImage(UIImage(named: "arrow"), for: .highlighted)
        button.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    private lazy var subtractionButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "subtraction"), for: .normal)
        button.setImage(UIImage(named: "subtraction"), for: .highlighted)
        button.addTarget(self, action: #selector(pressedSubtractionButton), for: .touchUpInside)
        button.backgroundColor = .white
        view.addSubview(button)
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.setImage(UIImage(named: "plus"), for: .highlighted)
        button.addTarget(self, action: #selector(pressedPlusButtonButton), for: .touchUpInside)
        button.backgroundColor = .white
        view.addSubview(button)
        return button
    }()
    
    private lazy var compassButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "compass"), for: .normal)
        button.setImage(UIImage(named: "compass"), for: .highlighted)
        button.addTarget(self, action: #selector(pressedCompassButtonButton), for: .touchUpInside)
        button.backgroundColor = .white
        view.addSubview(button)
        return button
    }()
    
    
    // MARK: MapView
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: Location.startupHub.latitude ?? 0.0, longitude: Location.startupHub.longitude ?? 0.0, zoom: 15.0)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.mapType = .normal
        mapView.setMinZoom(5.0, maxZoom: 20.0)
        mapView.settings.zoomGestures = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true
        mapView.delegate = self
        view.addSubview(mapView)
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        locationManager.delegate = self
        configurationConstarint()
        configurationInitalView()
    }
    
    func configurationConstarint() {
        mapView.snp.makeConstraints {
            $0.centerX.centerY.width.height.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26.0)
            $0.top.equalToSuperview().offset(50.0)
        }
        
        dropButton.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(16.0)
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(79.0)
            $0.height.equalTo(35.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(dropButton.snp.trailing).offset(24.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(dropButton)
            $0.height.equalTo(35.0)
        }
        
        subtractionButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.centerY)
            $0.trailing.equalToSuperview().offset(-21.0)
            $0.width.height.equalTo(35.0)
        }
        
        plusButton.snp.makeConstraints {
            $0.bottom.equalTo(subtractionButton.snp.top)
            $0.trailing.equalToSuperview().offset(-21.0)
            $0.width.height.equalTo(35.0)
        }
        
        compassButton.snp.makeConstraints {
            $0.top.equalTo(subtractionButton.snp.bottom).offset(8.0)
            $0.trailing.equalToSuperview().offset(-21.0)
            $0.width.height.equalTo(35.0)
        }
    }
    
    // MARK: - Create BottomSheet && Info
    private func configurationInitalView() {
        bottomSheetViewController.view.alpha = 0.0
        mapDetailViewController.view.alpha = 0.0
        createInfoView()
        createBottoSheet()
    }
    
    private func createBottoSheet() {
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        bottomSheetViewController.view.layer.cornerRadius = 10.0
    }
    
    private func createInfoView() {
        addChild(mapDetailViewController)
        view.addSubview(mapDetailViewController.view)
        mapDetailViewController.didMove(toParent: self)
        let width  = view.frame.width
        mapDetailViewController.view.frame = CGRect(x: 0, y: 0, width: width - 28, height: 221.0)
        mapDetailViewController.view.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-44.0)
            $0.height.equalTo(221.0)
            $0.leading.equalToSuperview().offset(14.0)
            $0.trailing.equalToSuperview().offset(-14.0)
        }
        mapDetailViewController.view.layer.cornerRadius = 10.0
        mapDetailViewController.sendEventToParent = { [weak self] in
            self?.changeBottomSheet()
        }
    }
    
    func changeInfoViewData(spot: Spot) {
        bottomSheetViewController.view.alpha = 0.0
        mapDetailViewController.view.alpha = 1.0
        
        let presenter = MapDetailPresenter(
            view: mapDetailViewController,
            spot: spot,
            categories: []
        )
        mapDetailViewController.presenter = presenter
    }
    
    func changeBottomSheet() {
        mapDetailViewController.view.alpha = 0.0
        bottomSheetViewController.view.alpha = 1.0
        let mapService = MapService(networking: MapNetworking())
         
        guard
            let spots = presenter?.spots,
            let categories = presenter?.categories
            else {
                return
            }
        let bottomPresenter = BottomSheetPresenter(
            view: bottomSheetViewController,
            mapService: mapService,
            categories: categories,
            spots: spots
        )
        bottomSheetViewController.presenter = bottomPresenter
    }
    
    @objc func pressedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressedSubtractionButton() {
        let currentZoom = mapView.camera.zoom
        let camera = GMSCameraPosition(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude, zoom: currentZoom - 0.1)
        mapView.camera = camera
    }
    
    @objc func pressedPlusButtonButton() {
        let currentZoom = mapView.camera.zoom
        let camera = GMSCameraPosition(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude, zoom: currentZoom + 0.1)
        mapView.camera = camera
    }
    
    @objc func pressedCompassButtonButton() {
        startMonitoringLocation()
    }
    
    @objc func pressedDropButton() {
        dropDown.show()
    }
    
    func startMonitoringLocation() {
        #if targetEnvironment(simulator)
            presenter?.didVisit(Location.startupHub)
        #else
            locationManager.startUpdatingLocation()
        #endif
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // Move
        if previousMarker != nil {
            previousMarker?.icon =  UIImage(named: "marker")
            previousMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: mapView.camera.zoom)
        marker.icon = UIImage(named: "active_marker")
        if previousMarker != nil {
            previousMarker?.icon =  UIImage(named: "marker")
        }
        previousMarker = marker
        guard let spots = presenter?.spots else {
            return true
        }
        
        for spot in spots {
            if spot.latitude == marker.position.latitude && spot.longitude == marker.position.longitude {
                changeInfoViewData(spot: spot)
                break
            }
        }
        return true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startMonitoringLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = Location(
            latitude: manager.location?.coordinate.latitude,
            longitude: manager.location?.coordinate.longitude
        )
        let currentZoom = mapView.camera.zoom
        let camera = GMSCameraPosition(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0, zoom: currentZoom)
        mapView.camera = camera
        presenter?.didVisit(location)
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: MapViewControllerType {
    func reload() {
        collectionView.reloadData()
        changeBottomSheet()
        configurationMapmarker()
    }
    
    func configurationMapmarker() {
        guard let spots = presenter?.spots else {
            return
        }
        spots.forEach({ spot in
            guard
                let latitude = spot.latitude,
                let longitude = spot.longitude else {
                    return
            }

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = spot.name
            marker.icon = UIImage(named: "marker")
            marker.map = mapView
        })
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let categories = presenter?.categories,
            let selectedCategory = presenter?.selectedCategory,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        if selectedCategory.id == categories[indexPath.row].id {
            cell.cellData = CellData(content: categories[indexPath.row].displayName ?? "", isSelect: true)
        } else {
            cell.cellData = CellData(content: categories[indexPath.row].displayName ?? "", isSelect: false)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categories = presenter?.categories else {
            return
        }
        presenter?.didSelectCategory(categories[indexPath.row])
    }
}
