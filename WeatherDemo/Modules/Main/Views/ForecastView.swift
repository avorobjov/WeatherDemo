//
//  ForecastView.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

struct ForecastViewModel {
    let items: [[Cell]]

    enum Cell {
        case header(title: String, alignment: NSTextAlignment)
        case value(temp: String, image: UIImage?)
    }

//    let days: [Day]
//    let forecatsTimeHeaders: [String]
//
//    struct Day {
//        let date: String
//
//        let items: [Item]
//    }
//
//    struct Item {
//        let temperature: String?
//        let icon: UIImage?
//    }
}

final class ForecastView: UIView {
    var viewModel: ForecastViewModel? {
        didSet {
            updateUI()
        }
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    private var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
}

extension ForecastView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionItems(at: section).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = sectionItem(at: indexPath) else {
            return UICollectionViewCell()
        }

        switch item {
        case let .header(title, alignment):
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastHeaderCell.reuseIdentifier, for: indexPath) as! ForecastHeaderCell
            cell.configure(title: title, alignment: alignment)
            return cell

        case let .value(temp, image):
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastValueCell.reuseIdentifier, for: indexPath) as! ForecastValueCell
            cell.configure(temp: temp, image: image)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = indexPath.section == 0 ? 30 : 70
        let w = indexPath.item == 0 ? 100 : 50

        return CGSize(width: w, height: h)
    }
}

private extension ForecastView {
    func prepareUI() {
        backgroundColor = .systemBackground

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: ForecastViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ForecastHeaderCell.nib(), forCellWithReuseIdentifier: ForecastHeaderCell.reuseIdentifier)
        collectionView.register(ForecastValueCell.nib(), forCellWithReuseIdentifier: ForecastValueCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func updateUI() {
        collectionView.reloadData()
    }

    func sectionItems(at sectionIndex: Int) -> [ForecastViewModel.Cell] {
        let items = viewModel?.items ?? []
        guard sectionIndex < items.count else {
            print("ForecastView: bad indexPath.section")
            return []
        }

        return items[sectionIndex]
    }

    func sectionItem(at indexPath: IndexPath) -> ForecastViewModel.Cell? {
        let items = sectionItems(at: indexPath.section)
        guard indexPath.item < items.count else {
            print("ForecastView: bad indexPath.item")
            return nil
        }

        return items[indexPath.item]
    }
}
