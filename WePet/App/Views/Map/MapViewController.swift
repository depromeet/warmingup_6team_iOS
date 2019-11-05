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

protocol MapViewControllerType: AnyObject {
    func reload()
}

class MapViewController: BaseViewController {
    
    var presenter: MapPresenterType?
    let bottomSheetViewController = BottomSheetViewController()
    let mapDetailViewController = MapDetailViewController()
    
    private lazy var dropView: UIButton = {
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
        configurationConstarint()
        presenter?.didVisit(Location.startupHub)
//        addBottomSheetView()
//        addBottomInfoView()
    }
    
    func configurationConstarint() {
        mapView.snp.makeConstraints {
            $0.centerX.centerY.width.height.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26.0)
            $0.top.equalToSuperview().offset(50.0)
        }
        
        dropView.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(16.0)
            $0.centerY.equalTo(backButton)
            $0.width.equalTo(79.0)
            $0.height.equalTo(35.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(dropView.snp.trailing).offset(24.0)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(dropView)
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
    
    func addBottomInfoView() {
        let spot: Spot = Spot()
        
        let presenter = MapDetailPresenter(
            view: mapDetailViewController,
            spot: spot,
            categories: []
        )
        mapDetailViewController.presenter = presenter
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
    
    func changeBottomSheet() {
        view.subviews.forEach { view in
            view.removeFromSuperview()
        }
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        let mapService = MapService(networking: MapNetworking())
        // 1- Init bottomSheetVC
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
        // 2- Add bottomSheetVC as a child view
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        bottomSheetViewController.didMove(toParent: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        bottomSheetViewController.view.layer.cornerRadius = 10.0
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressedDropButton() {
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // Move
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = UIImage(named: "active_marker")
        return true
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            startMonitoringLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = Location(
            latitude: manager.location?.coordinate.latitude,
            longitude: manager.location?.coordinate.longitude
        )
        presenter?.didVisit(location)
    }
}

extension MapViewController: MapViewControllerType {
    func reload() {
        addBottomSheetView()
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
    
    
}
