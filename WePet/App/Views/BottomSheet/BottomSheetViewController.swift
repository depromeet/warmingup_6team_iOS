//
//  BottomSheetViewController.swift
//  WePet
//
//  Created by 양혜리 on 30/10/2019.
//  Copyright © 2019 depromeet. All rights reserved.
//

import UIKit
import SnapKit

protocol BottomSheetViewControllerType: AnyObject {
    func reload()
}


class BottomSheetViewController: BaseViewController {

    var presenter: BottomSheetPresenterType? {
        didSet {
            tableView.reloadData()
            configurationIntialHeight()
            bottomView.alpha = 0
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(SpotCell.self, forCellReuseIdentifier: "SpotCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        return tableView
    }()
    
    private lazy var line: UIImageView = {
        let line: UIImageView = UIImageView()
        line.image = UIImage(named: "rectangle")
        view.addSubview(line)
        return line
    }()
    
    private lazy var bottomView: UIView = {
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = .white
        bottomView.alpha = 0
        view.addSubview(bottomView)
        return bottomView
    }()
    
    var partialView: CGFloat {
        guard let count = presenter?.spots.count else {
            return 54.0
        }
        if count >= 3 {
            return 50.0 + 21.0 + (80.0 * 3)
        } else {
            return 50.0 + 21.0 + CGFloat(80 * count)
        }
    }
    
    var fullView: CGFloat {
        return UIScreen.main.bounds.height - 114
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        bluredView.layer.cornerRadius = 10.0
        view.insertSubview(bluredView, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationConstarint()
        presenter?.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurationIntialHeight()
    }
    
    private func configurationIntialHeight() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            let frame = self?.view.frame
            self?.view.frame = CGRect(x: 0, y: frame!.height - (self?.partialView ?? 0) , width: frame!.width, height: frame!.height)
        }
    }
    
    private func configurationConstarint() {
        tableView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(21.0)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(21.0)
        }
        
        line.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(12.0)
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.height - 54.0, width: self.view.frame.width, height: self.view.frame.height)
                    self.bottomView.alpha = 1
                } else {
                    self.view.frame = CGRect(x: 0, y: 114, width: self.view.frame.width, height: self.view.frame.height)
                    self.bottomView.alpha = 0
                }
                
            }, completion: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
         let direction = gesture.velocity(in: view).y

         let y = view.frame.minY
//         if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
//             tableView.isScrollEnabled = false
//         } else {
//           tableView.isScrollEnabled = true
//         }

         return false
     }
}

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.spots.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        cell.configure(spot: presenter?.spots[indexPath.row], isLast: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BottomSheetViewController: BottomSheetViewControllerType {
    func reload() {
        tableView.reloadData()
    }
}
