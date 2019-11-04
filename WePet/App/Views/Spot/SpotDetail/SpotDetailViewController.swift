//
//  SpotDetailViewController.swift
//  WePet
//
//  Created by NHNEnt on 2019/11/02.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit

protocol SpotDetailViewControllerType: AnyObject {
    func configureSpot(_ spot: Spot)
    func configureFavoriteImage(_ favorite: Bool)
}

final class SpotDetailViewController: BaseViewController, SpotDetailViewControllerType {

    // MARK: - Subviews

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var operatingHoursLabel: UILabel!
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var homePageStackView: UIStackView!
    @IBOutlet weak var homePageLabel: UILabel!

    // MARK: - Properties

    var presenter: SpotDetailPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    func configureSpot(_ spot: Spot) {
        ImageLoader.image(for: spot.photoUrl) { [weak self] image in
            self?.thumbnailView.image = image ?? UIImage(named: "sample")
        }
        nameLabel.text = spot.name
        distanceLabel.text = "\(spot.distance ?? 100)m"
        addressLabel.text = spot.address
        phoneNumberLabel.text = spot.phoneNumber
        homePageLabel.text = spot.homePage
        UIView.animate(withDuration: 0.2) {
            self.addressStackView.isHidden = spot.address == nil
            self.phoneNumberStackView.isHidden = spot.phoneNumber == nil
            self.homePageStackView.isHidden = spot.homePage == nil
        }
        configureFavoriteImage(spot.wishList == true)
    }

    func configureFavoriteImage(_ favorite: Bool) {
        let image = favorite ? UIImage(named: "ic_favorite_active") : UIImage(named: "ic_favorite_inactive")
        favoriteButton.setImage(image, for: .normal)
    }

    @IBAction func didTapFavorite(_ sender: Any) {
        presenter?.didTapFavorite()
    }

    @IBAction func didTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapPhoneNumber(_ sender: Any) {
        guard let phoneNumber = presenter?.spot.phoneNumber else { return }
        guard let url = URL(string: "tel://".appending(phoneNumber)) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func didTapHomePage(_ sender: Any) {
        guard let homePage = presenter?.spot.homePage else { return }
        guard let url = URL(string: homePage) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
