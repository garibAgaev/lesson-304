//
//  MainCollectionViewController.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

protocol DismisChildViewController {
    func dismisView(at indexPath: IndexPath)
}

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, SubscribersDelegate {
    
    var currentIndexPath: IndexPath!
    var weatherData: WeatherData!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        //func collectionView(_ collectionView:, numberOfItemsInSection section:) -> Int
        WeatherData.shared.count(for: self) ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        
        guard let data: Location =  WeatherData.shared[self, indexPath.item] else { return cell }
        
        Task {
            do {
                let current: RealtimeAPI = try await NetworkManager.shared.fetchData(.currentWeather, q: data.name, days: nil)
                let regex = /(?:0?[0-9]|1[0-9]|2[0-3]):(?:0?[0-9]|[1-5][0-9])$/
                let reg = current.location.localtime?.firstMatch(of: regex)
                cell.seTexts(
                    county: current.location.name,
                    hour: reg?.description,
                    status: current.current.condition.text,
                    temp: current.current.tempC
                )
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let containerVC = ContainerViewController()
        let contentViewController = PageInfoCollectionViewController()
        containerVC.dismisDelegate = self
        containerVC.contentViewController = contentViewController
        containerVC.getIndexDelegate = contentViewController
        
        containerVC.view.frame = collectionView.convert(cell.frame, to: navigationController?.view)
        
        navigationController?.addChild(containerVC)
        navigationController?.view.addSubview(containerVC.view)
        containerVC.didMove(toParent: navigationController?.navigationController)
        
        UIView.animate(withDuration: 0.5, animations: {
            containerVC.view.frame = self.view.bounds
        })
    }
}

// MARK: - setting View
extension MainCollectionViewController {
    func setupView() {
        WeatherData.shared.subscribe(self, to: [.currentWeather])
        setupSearchController()
        setupNavigationController()
        setupCollectionView()
    }
}

// MARK: - setting
extension MainCollectionViewController {
    func setupSearchController() {
        let searchViewController = SearchResultTableViewController()
        let searchController = UISearchController(searchResultsController: searchViewController)
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Search for a city or airport"
        
        [self, searchViewController].forEach {
            $0.navigationItem.searchController = searchController
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = searchViewController
        
        let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .white
        
        let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton
        cancelButton?.setTitleColor(.white, for: .normal)
    }
    
    func setupNavigationController() {
        title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.alwaysBounceVertical = true
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension MainCollectionViewController: DismisChildViewController {
    func dismisView(at indexPath: IndexPath) {
        guard let a = navigationController?.children.last else { return }
        a.willMove(toParent: nil)
        a.removeFromParent()
        guard
            let cell = collectionView.cellForItem(at: indexPath)
        else {
            a.view.removeFromSuperview()
            return
        }

        UIView.animate(withDuration: 0.5, animations: {
            a.view.frame = self.collectionView.convert(cell.frame, to: self.view)
        }) { _ in
            a.view.removeFromSuperview()
        }
    }
}

extension MainCollectionViewController {
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
