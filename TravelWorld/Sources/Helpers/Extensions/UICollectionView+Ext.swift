//
//  UICollectionView+Ext.swift
//  TravelWorld
//
//  Created by Henry Tran on 6/30/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

extension UICollectionView {

    func registerNibCellBy(indentifier: String) {
        self.register(UINib(nibName: indentifier, bundle: nil), forCellWithReuseIdentifier: indentifier)
    }
}
