//
//  InfoCollectionViewController.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class InfoCollectionViewController: UICollectionViewController, SubscribersDelegate {
    // MARK: - Properties
    
    var lokations: WeatherData!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         WeatherData.shared.subscribe(self, to: [.forecast])
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: Required UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: UICollectionViewDataSource
extension FullInfoCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
}

// MARK: UICollectionViewDelegate
extension FullInfoCollectionViewController {
    
}


extension InfoCollectionViewController {
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
