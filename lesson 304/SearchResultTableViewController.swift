//
//  SearchResultTableViewController.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    private var locations: [Location] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        let myText = "\(locations[indexPath.row].name), \(locations[indexPath.row].country)"
        let attributedText = NSMutableAttributedString(string: myText)
        
        let subWhiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        
        
        let regex = try? NSRegularExpression(pattern: navigationItem.searchController?.searchBar.text ?? "")
        let nsRange = NSRange(myText.startIndex..<myText.endIndex, in: myText)
        let matches = regex?.matches(in: myText, range: nsRange)
        matches?.forEach {
            attributedText.addAttributes(subWhiteTextAttributes, range: $0.range)
        }
        
        cell.backgroundColor = .clear
        var configuration = cell.defaultContentConfiguration()
        configuration.attributedText = attributedText
        configuration.textProperties.color = UIColor(white: 0.8, alpha: 0.3)
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate.addLocation(locations[indexPath.row])
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let a = FullInfoCollectionViewController(collectionViewLayout: layout)
        a.delegate = self
        a.location = locations[indexPath.row]
        let vlc = UINavigationController(rootViewController: a)
        
        present(vlc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - Setting View
private extension SearchResultTableViewController {
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.backgroundColor = .black
    }
}

//MARK: - UISearchResultsUpdating
extension SearchResultTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            print("Ошибка обработки текст в \(UISearchController.self)")
            return
        }
        guard text.count > 2 else { return }
        NetworkManager.shared.fetchLocations(q: text) { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations = locations
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
