//
//  ForecastValueCell.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

class ForecastValueCell: UICollectionViewCell {
    static let reuseIdentifier = "ForecastValueCell"

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: Bundle(for: self))
    }

    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .systemGray5

        tempLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        tempLabel.textColor = .label
    }

    func configure(temp: String, image: UIImage?) {
        tempLabel.text = temp
        imageView.image = image
    }
}
