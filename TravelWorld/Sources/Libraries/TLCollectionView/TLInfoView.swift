//
//  TLInfoView.swift
//  TravelWorld
//
//  Created by Henry Tran on 7/4/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

protocol TLInfoDisplayable: TLDisplayable {

    func getInfo() -> String?
}

class TLInfoView: UIView, TLResizeable {

    private var imgvAvatar: UIImageView?
    private var lblFullName: UILabel?
    private var lblTime: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        // create view
        self.createAvatarImageView(frame: frame)
        self.createFullNameLabel(frame: frame)
        self.createTimeLabel(frame: frame)
        self.reLayoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Create View
    private func createAvatarImageView(frame: CGRect) {
        self.imgvAvatar = UIImageView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        self.imgvAvatar?.image = #imageLiteral(resourceName: "ic_avatar")
        self.addSubview(self.imgvAvatar!)
    }

    private func createFullNameLabel(frame: CGRect) {
        self.lblFullName = UILabel(frame: CGRect(x: 60, y: 10, width: frame.width - 60 - 10, height: 40))
        self.lblFullName?.numberOfLines = 0
        self.lblFullName?.font = UIFont.helveticaNeue(size: 14)
        self.lblFullName?.textColor = UIColor(hex: "404243")
        self.addSubview(self.lblFullName!)
    }

    private func createTimeLabel(frame: CGRect) {
        if let frameFullName = self.lblFullName?.frame {
            let topY = frameFullName.origin.y + frameFullName.height

            self.lblTime = UILabel(frame: CGRect(x: 60, y: topY, width: frame.width - 60 - 10, height: 15))
            self.lblTime?.font = UIFont.helveticaNeue(size: 12)
            self.lblTime?.textColor = UIColor(hex: "9197A3")
            self.addSubview(self.lblTime!)
        }
    }

    private func reLayoutView() {

        if var frameFullName = self.lblFullName?.frame,
            var frameTime = self.lblTime?.frame {

            if let fullNameSize = self.lblFullName?.text?.sizeToFitWidth(frameFullName.size.width, font: self.lblFullName?.font) {
                frameFullName.size.width = ceil(frameFullName.size.width)
                frameFullName.size.height = ceil(fullNameSize.height)
                self.lblFullName?.frame = frameFullName
            }

            var topY = frameFullName.origin.y + frameFullName.height
            topY = topY < 35 ? 35 : topY
            frameTime.origin.y = topY
            self.lblTime?.frame = frameTime

            var frameView = self.frame
            frameView.size.height = topY + frameTime.height + 10
            self.frame = frameView
        }
    }

    // MARK: - Set data
    func updateData(object: TLDisplayable?) {
        if let _object = object as? TLInfoDisplayable {
            self.lblFullName?.text = _object.getInfo()

            DispatchQueue.global(qos: .background).async {
                // Validate user input
                let dateTime = Date.convertDateToString(fromDate: Date(), format: DateFormat.yyyyMMddDash)
                // Go back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.lblTime?.text = dateTime
                }
            }
        }

        self.reLayoutView()
    }

    func size() -> CGRect {

        return CGRect.zero
    }
}
