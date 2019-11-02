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

protocol MapViewControllerType: AnyObject {
    func reload()
}

class MapViewController: BaseViewController {
    
    var presenter: MapPresenterType?
    
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    // MARK: MapView
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.mapType = .normal
        mapView.setMinZoom(5.0, maxZoom: 20.0)
        mapView.settings.zoomGestures = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.settings.compassButton = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        mapView.delegate = self
        view.addSubview(mapView)
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        configurationConstarint()
//        addBottomSheetView()
        addBottomInfoView()
    }
    
    func configurationConstarint() {
//        mapView.snp.makeConstraints {
//            $0.centerX.centerY.width.height.equalToSuperview()
//        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26.0)
            $0.top.equalToSuperview().offset(50.0)
        }
    }
    
    func addBottomInfoView() {
//        guard let spot = presenter?.spots.first else {
//            return
//        }
        let spot: Spot = Spot()
        let mapDetailViewController = MapDetailViewController()
        
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
    }
    func addBottomSheetView() {
        let mapService = MapService(networking: MapNetworking())
        // 1- Init bottomSheetVC
        let bottomSheetVC = BottomSheetViewController()
        let presenter = BottomSheetPresenter(
            view: bottomSheetVC,
            mapService: mapService,
            categories: []
        )
        bottomSheetVC.presenter = presenter
        // 2- Add bottomSheetVC as a child view
        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    @objc func pressedBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    }
}

extension MapViewController: MapViewControllerType {
    func reload() {
        
    }
}
