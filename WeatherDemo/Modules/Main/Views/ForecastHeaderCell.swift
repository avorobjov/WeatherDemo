//
//  ForecastHeaderCell.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

class ForecastHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "ForecastHeaderCell"

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: Bundle(for: self))
    }

    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .systemGray4

        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        titleLabel.textColor = .label

        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight).isActive = true
    }

    func configure(title: String, alignment: NSTextAlignment) {
        titleLabel.text = title
        titleLabel.textAlignment = alignment
    }
}
