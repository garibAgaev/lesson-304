//
//  CollectionViewCell.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private let labelCounty = UILabel()
    private let labelHour = UILabel()
    private let labelStatus = UILabel()
    private let tempLabel = UILabel()
    
    var textColor: UIColor {
        get {
            labelCounty.textColor
        }
        set {
            [labelCounty, labelHour, labelStatus, tempLabel].forEach {
                $0.textColor = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func seTexts(county: String?, hour: String?, status: String?, temp: Double?) {
        if let county = county {
            labelCounty.text = county
        }
        if let hour = hour {
            labelHour.text = hour
        }
        if let status = status {
            labelStatus.text = status
        }
        if let temp = temp {
            tempLabel.text = "\(String(format: "%.0f", temp))\u{00B0}"
        }
    }
    
    private func setupCell() {
        
        backgroundColor = .systemCyan
        textColor = .white
        layer.cornerRadius = 10
        
        addSublabel()
        setup(lable: labelCounty, .left, fontSize: 20)
        setup(lable: labelHour, .left, fontSize: 10)
        setup(lable: labelStatus, .left, fontSize: 15)
        setup(lable: tempLabel, .center, fontSize: 50)
        setupConstrants()
    }
    
    private func addSublabel() {
        [labelCounty, labelHour, labelStatus, tempLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setup(lable: UILabel, _ alignment: NSTextAlignment, fontSize: CGFloat) {
        lable.textAlignment = alignment
        lable.font = .systemFont(ofSize: fontSize)
    }
    
    private func setupConstrants() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: labelCounty, attribute: .leading,
                relatedBy: .equal,
                toItem: contentView, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: labelCounty, attribute: .top,
                relatedBy: .equal,
                toItem: contentView, attribute: .top,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: labelHour, attribute: .leading,
                relatedBy: .equal,
                toItem: contentView, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: labelHour, attribute: .top,
                relatedBy: .equal,
                toItem: labelCounty, attribute: .bottom,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: labelStatus, attribute: .leading,
                relatedBy: .equal,
                toItem: contentView, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: labelStatus, attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView, attribute: .bottom,
                multiplier: 1, constant: -16
            ),
            NSLayoutConstraint(
                item: tempLabel, attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView, attribute: .trailing,
                multiplier: 1, constant: -16
            ),
            NSLayoutConstraint(
                item: tempLabel, attribute: .top,
                relatedBy: .equal,
                toItem: contentView, attribute: .top,
                multiplier: 1, constant: 16
            )
        ])
    }
}
