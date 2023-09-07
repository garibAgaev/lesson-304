//
//  FullInfoCollectionViewController.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "CellView"

class FullInfoCollectionViewController: UICollectionViewController, SubscribersDelegate {
    
    var location: Location!
    
    var delegate: UIViewController!
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherData.shared.subscribe(self, to: [.forecast])
        title = location.name
        
        let cancelButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonItem)
        )
        
        let addButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addButtonItemAction)
        )
        
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = addButtonItem
        
        setupCollectionView()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
    //func collectionView(_ collectionView:, numberOfItemsInSection section:) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //func collectionView(_ collectionView:, cellForItemAt indexPath:) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.contentView.backgroundColor = .systemRed
        return cell
    }
    
    @objc func cancelButtonItem() {
        navigationController?.presentedViewController?.dismiss(animated: true)
        dismiss(animated: true)
    }
    
    @objc func addButtonItemAction() {
         WeatherData.shared.add(for: self, location: location)
        delegate.dismiss(animated: false)
        dismiss(animated: true)
    }
}

// MARK: - Setting CollectionView
private extension FullInfoCollectionViewController {
    func setupCollectionView() {
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemCyan
        settingLocationManager()
    }
}

// MARK: - Setting
private extension FullInfoCollectionViewController {
    func settingLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Layout
private extension FullInfoCollectionViewController {
    
}

// MARK: - UICollectionViewDelegate
extension FullInfoCollectionViewController {
    
}

extension FullInfoCollectionViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("lalal")
//        if let location = locations.last {
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//            NetworkManager.shared.dfs(.searchOrAutocomplete,
//                                      q: "\(latitude),\(longitude)",
//                                      days: nil) { [weak self] (locations: [Location]) in
//                self?.locations = locations
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse, .authorizedAlways:
//            break
//        default:
//
//        }
//    }
}

extension FullInfoCollectionViewController {
    func informAboutChange() {
        UIView.transition(with: collectionView, duration: 0.35, options: .transitionCrossDissolve) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func informAboutAppend() {
        UIView.transition(with: collectionView, duration: 0.35, options: .transitionCrossDissolve) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func informAboutRemove() {
        UIView.transition(with: collectionView, duration: 0.35, options: .transitionCrossDissolve) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension FullInfoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    //func collectionView(_ collectionView:, layout collectionViewLayout:, sizeForItemAt indexPath:) -> CGSize {
        switch indexPath.item {
        case 0:
            return getCollectionViewSizeForItemAt0()
        default:
            return CGSize()
        }
    }
}

extension FullInfoCollectionViewController {
    func getCollectionViewSizeForItemAt0() -> CGSize {
        
        return CGSize()
    }
}
