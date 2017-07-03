//
//  TLCollectionView.swift
//  TravelWorld
//
//  Created by Henry Tran on 7/2/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

protocol TLDisplayable {
    var size: CGSize? { get set }
}

protocol TLResizeable {
  func size() -> CGRect
}

class TLCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
