//
//  LoginFormView.swift
//  TravelWorld
//
//  Created by Henry Tran on 6/26/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit
import SnapKit

class LoginFormView: UIView {

    @IBOutlet weak var btnLogin: UIButton!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    // MARK: - Function
    func addToViewWithAnimation(superView: UIView?, animate: Bool = false, action: Selector? = nil) {
        self.removeFromSuperview()
        guard let _superView = superView else { return  }
        _superView.addSubview(self)
        self.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(_superView).offset(-40)
            make.left.equalTo(_superView).offset(30)
            make.right.equalTo(_superView).offset(-30)
        }

        if let _action = action {
            self.btnLogin.addTarget(nil, action: _action, for: UIControlEvents.touchUpInside)
        }

        if animate == true {
            self.alpha = 0
            UIView.animate(withDuration: 0.33) {
                self.alpha = 1
            }
        }
    }

    func hideWithAnimation(animate: Bool = false, completion: ((Bool) -> Void)? = nil) {

        self.alpha = 1
        if animate == true {
            UIView.animate(withDuration: 0.33, animations: {
                self.alpha = 0
            }, completion: { (finished) in
                completion?(finished)
            })

        } else {
            completion?(true)
        }
    }
}
