//
//  ContainerViewController.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var contentViewController: UIViewController!
    
    var getIndexDelegate: PageInfoCollectionViewControllerDelegate!
    var dismisDelegate: DismisChildViewController!
    
    private let dismisButton = UIButton(type: .system)
    private let scrolButton = UIButton(type: .system)
    private let heightContainer: CGFloat = 65
    private let containerStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func dismisButtonAction() {
        guard let indexParth = getIndexDelegate.indexParth else { return }
        dismisDelegate.dismisView(at: indexParth)
    }
}

// MARK: - Setting View
private extension ContainerViewController {
    func setupView() {
        view.backgroundColor = .systemCyan
        setupStackView()
        setupDismisButton()
        setupBotomViewController()
        setupContentViewController()
    }
}

// MARK: - Setting
private extension ContainerViewController {
    func setupStackView() {
        [scrolButton, dismisButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fillProportionally
        
        containerStackView.layer.borderColor = UIColor.white.cgColor
        containerStackView.layer.borderWidth = 0.5
    }
    
    func setupDismisButton() {
        let image = UIImage(systemName: "line.horizontal.3")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        dismisButton.setImage(image, for: .normal)
        dismisButton.addTarget(self, action: #selector(dismisButtonAction), for: .touchUpInside)
    }
    
    func setupBotomViewController() {
        let containerViewController = UIViewController()
        
        containerViewController.view.frame = CGRect(
            x: 0, y: UIScreen.main.bounds.height - heightContainer,
            width: UIScreen.main.bounds.width, height: heightContainer
        )
        containerStackView.frame = containerViewController.view.bounds
        containerViewController.view.addSubview(containerStackView)
        
        addChild(containerViewController)
        view.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
    }
    
    func setupContentViewController() {
        let contentViewController = contentViewController ?? UIViewController()
        
        contentViewController.view.frame = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - heightContainer
        )
        
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
    }
}
