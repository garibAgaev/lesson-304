//
//  PageInfoCollectionViewControllerDelegate.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

protocol PageInfoCollectionViewControllerDelegate {
    var indexParth: IndexPath? {
        get
    }
}

class PageInfoCollectionViewController: UIPageViewController, SubscribersDelegate {
    
    var customViewControllers: [a] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherData.shared.subscribe(self, to: [])
        
        self.dataSource = self
        self.delegate = self
        
        for _ in 0..<(WeatherData.shared.count(for: self) ?? 1) {
            customViewControllers.append(a())
        }
        
        setViewControllers([customViewControllers[0]], direction: .reverse, animated: false)
    }
}

extension PageInfoCollectionViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = customViewControllers.firstIndex(of: viewController as! a),
                index > 0
        else {
            return nil
        }
        return customViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let index = customViewControllers.firstIndex(of: viewController as! a),
            index + 1 < customViewControllers.endIndex
        else {
            return nil
        }
        return customViewControllers[index + 1]
    }
}

extension PageInfoCollectionViewController: UIPageViewControllerDelegate {
    
}

extension PageInfoCollectionViewController: PageInfoCollectionViewControllerDelegate {
    var indexParth: IndexPath? {
        guard
            let currentViewController = viewControllers?.first,
            let index = customViewControllers.firstIndex(of: currentViewController as! a)
        else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
}

extension PageInfoCollectionViewController {
    func informAboutChange() {
        customViewControllers.append(a())
    }
    
    func informAboutAppend() {
        customViewControllers.append(a())
    }
    
    func informAboutRemove() {
        customViewControllers.append(a())
    }
}

class a: UIViewController {
    override func viewDidLoad() {
        let label = UIView()
        view.addSubview(label)
        label.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 100, width: 200, height: 200)
        label.backgroundColor = .blue
    }
}
