//
//  ForecastViewLayout.swift
//  WeatherDemo
//
//  Created by Alexander Vorobjov on 1/17/21.
//

import UIKit

class ForecastViewLayout: UICollectionViewLayout {
    private static let headerHeight: CGFloat = 30
    private static let headerWidth: CGFloat = 100
    private static let valueHeight: CGFloat = 70
    private static let valueWidth: CGFloat = 80

    override var collectionViewContentSize: CGSize {
        guard
            let sectionsCount = collectionView?.numberOfSections,
            sectionsCount > 1,
            let itemsCount = collectionView?.numberOfItems(inSection: 0),
            itemsCount > 1
        else {
            return .zero
        }

        let h = Self.headerHeight + (Self.valueHeight + 1) * CGFloat(sectionsCount - 1)
        let w = Self.headerWidth + (Self.valueWidth + 1) * CGFloat(itemsCount - 1)

        return CGSize(width: w, height: h)
    }

    // swiftlint:disable:next discouraged_optional_collection
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return []
        }

        var result = [UICollectionViewLayoutAttributes]()

        var top: CGFloat = 0
        for section in 0..<collectionView.numberOfSections {
            var left: CGFloat = 0
            let h = section == 0 ? Self.headerHeight : Self.valueHeight

            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let w = item == 0 ? Self.headerWidth : Self.valueWidth

                let x = max(0, item == 0 ? collectionView.contentOffset.x : left)
                let y = max(0, section == 0 ? collectionView.contentOffset.y : top)
                let z = (item == 0) ? 3 : (section == 0) ? 2 : 1

                let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
                attrs.frame = CGRect(x: x, y: y, width: w, height: h)
                attrs.zIndex = z
                result.append(attrs)

                left += w + 1
            }

            top += h + 1
        }

        return result
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
