//
//  TLViews.swift
//  TravelWorld
//
//  Created by Henry Tran on 7/2/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit

protocol TLStatusDisplayable: TLDisplayable {
    func getStatus() -> String?
}

class TimelineActionView: UIView {

    private var btnLike: UIButton?
    private var btnComment: UIButton?
    private var btnShare: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        // create view
        self.createButtonLike(frame: frame)
        self.createButtonComment(frame: frame)
        self.createButtonShare(frame: frame)

        let viewLine = UIView(frame: CGRect(x: 12, y: 0, width: frame.width - 12 * 2, height: 1))
        viewLine.backgroundColor = UIColor(hex: "EEEEEE")
        self.addSubview(viewLine)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Create View
    func createButtonLike(frame: CGRect) {
        self.btnLike = UIButton(frame: CGRect(x: 5, y: 5, width: frame.width / 3, height: 40))
        self.btnLike?.setTitle("Like", for: UIControlState.normal)
        self.btnLike?.titleLabel?.font = UIFont.helveticaNeueBold(size: 12)
        self.btnLike?.setTitleColor(UIColor(hex: "9197A3"), for: UIControlState.normal)
        self.btnLike?.setImage(#imageLiteral(resourceName: "ic_like"), for: UIControlState.normal)
        self.btnLike?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 0)
        self.addSubview(self.btnLike!)
    }

    func createButtonComment(frame: CGRect) {
        self.btnComment = UIButton(frame: CGRect(x: frame.width / 3, y: 5, width: frame.width / 3, height: 40))
        self.btnComment?.setTitle("Comment", for: UIControlState.normal)
        self.btnComment?.titleLabel?.font = UIFont.helveticaNeueBold(size: 12)
        self.btnComment?.setTitleColor(UIColor(hex: "9197A3"), for: UIControlState.normal)
        self.btnComment?.setImage(#imageLiteral(resourceName: "ic_comment"), for: UIControlState.normal)
        self.btnComment?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 0)
        self.addSubview(self.btnComment!)
    }

    func createButtonShare(frame: CGRect) {
        self.btnShare = UIButton(frame: CGRect(x: 2 * frame.width / 3, y: 5, width: frame.width / 3, height: 40))
        self.btnShare?.setTitle("Share", for: UIControlState.normal)
        self.btnShare?.titleLabel?.font = UIFont.helveticaNeueBold(size: 12)
        self.btnShare?.setTitleColor(UIColor(hex: "9197A3"), for: UIControlState.normal)
        self.btnShare?.setImage(#imageLiteral(resourceName: "ic_share"), for: UIControlState.normal)
        self.btnShare?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 0)
        self.addSubview(self.btnShare!)
    }

}

protocol BaseTimelineProtocol {

}

class BaseTimelineCell: UICollectionViewCell {

    var size: CGSize?

    private var timelineInfoView: TLInfoView?
    private var timelineActionView: TimelineActionView?
    private var statusLabel: UILabel?
    private var data: TLDisplayable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        // create view
        self.createInfosView(frame: frame)
        self.createActionsView(frame: frame)

        self.statusLabel = UILabel(frame: CGRect(x: 12, y: 0, width: frame.width - 12 * 2, height: 80))
        self.addSubview(self.statusLabel!)
        self.statusLabel?.backgroundColor = UIColor.white
        self.statusLabel?.numberOfLines = 0
        self.statusLabel?.font = UIFont.helveticaNeue(size: 14)
        self.statusLabel?.textColor = UIColor(hex: "141823")
        self.reLayoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Create View
    func createInfosView(frame: CGRect) {
        self.timelineInfoView = TLInfoView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 80))

        self.addSubview(self.timelineInfoView!)
    }

    func createActionsView(frame: CGRect) {
        self.timelineActionView = TimelineActionView(frame: CGRect(x: 0, y: frame.height - 50, width: frame.width, height: 50))
        self.addSubview(self.timelineActionView!)
    }

    // MARK: - Set data
    func updateData(_ object: TLDisplayable) {
        self.data = object
        self.timelineInfoView?.updateData(object: object)

        if let statusObject = object as? TLStatusDisplayable {
            self.statusLabel?.text = statusObject.getStatus()
        }

        self.reLayoutView()
    }

    private func reLayoutView() {
        if let frameInfo = self.timelineInfoView?.frame,
            var frameStatus = self.statusLabel?.frame ,
            var frameAction = self.timelineActionView?.frame {

            // status view
            if let statusSize = self.statusLabel?.text?.sizeToFitWidth(frameStatus.size.width, font: self.statusLabel?.font) {
                frameStatus.size.width = ceil(frameStatus.size.width)
                frameStatus.size.height = ceil(statusSize.height)
                self.statusLabel?.frame = frameStatus
            }

            let topY = frameInfo.origin.y + frameInfo.height
            frameStatus.origin.y = topY
            frameStatus.size.height += 10
            self.statusLabel?.frame = frameStatus

            // actions views
            frameAction.origin.y = frameStatus.origin.y + frameStatus.height
            self.timelineActionView?.frame = frameAction

            // cell frame
            var frameView = self.frame
            frameView.size.height = frameAction.origin.y + frameAction.height
            self.frame = frameView
        }
    }

    static func getSize(_ object: TLDisplayable) -> CGSize? {

        let screenWidth = UIScreen.main.bounds.width
        let baseTimelineCell = BaseTimelineCell(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        baseTimelineCell.updateData(object)
        return CGSize(width: screenWidth, height: baseTimelineCell.frame.size.height)
    }
}

//class StatusTimelineCell: BaseTimelineCell {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
