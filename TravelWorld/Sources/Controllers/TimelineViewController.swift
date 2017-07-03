//
//  TimelineViewController.swift
//  TravelWorld
//
//  Created by Henry Tran on 6/30/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit
import Alamofire

class TimelineInfo: TLInfoDisplayable, TLStatusDisplayable {

    var name: String?
    var status: String?
    var size: CGSize?

    func getInfo() -> String? {
        return name
    }

    func getStatus() -> String? {
        return status
    }

    func updateData() {
        self.size = BaseTimelineCell.getSize(self)
    }
}

class TimelineViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var collectionView: TLCollectionView!

    // MARK: - Varialbes
    fileprivate var listTimelines: [TLDisplayable] = []
    fileprivate var requestTimeline: Request?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 1...100 {
            let timeline = TimelineInfo()

            if index % 4 == 0 {
                timeline.status = "The UILabel gets a fixed width and the .numberOfLines is set to 0. By adding the text and calling .sizeToFit() it automatically adjusts to the correct height.Code is written in Swift 3" + "_\(index)"
                timeline.name = "Tran Hai Linh" + "_\(index)"
            } else if index % 4 == 1 {
                timeline.status = "(Video trận đấu, Kết quả trận đấu, Bồ Đào Nha - Mexico, tranh giải Ba Confederations Cup) Một trận đấu quá nhiều cảm xúc và xoay chiều chóng mặt đã diễn ra và cuối cùng chủ nhân của tấm HCĐ cúp vô địch Liên đoàn các châu lục năm nay cũng đã được xác định.(Video trận đấu, Kết quả trận đấu, Bồ Đào Nha - Mexico, tranh giải Ba Confederations Cup) Một trận đấu quá nhiều cảm xúc và xoay chiều chóng mặt đã diễn ra và cuối cùng chủ nhân của tấm HCĐ cúp vô địch Liên đoàn các châu lục năm nay cũng đã được xác định." + "_\(index)"
                timeline.name = "Tran Hai Linh, Tran Hai LinhTran Hai LinhTran Hai LinhTran Hai LinhTran Hai Linh" + "_\(index)"

            } else {
                timeline.status = "status" + "_\(index)"
                timeline.name = "Linh" + "_\(index)"
            }
            timeline.updateData()
            self.listTimelines.append(timeline)
        }
        // setup views
        self.setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // call request
        self.doGetTimeline()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Setup View
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(BaseTimelineCell.self, forCellWithReuseIdentifier: "BaseTimelineCell")
    }

    // MARK: - Call Api
    private func doGetTimeline() {

        self.requestTimeline = ApiClient.request(urlRequest: TimelineRouter.getList) { (responseObject) in
            if responseObject?.result == .success {

            } else {

            }
        }
    }

    // MARK: - Actions

    // MARK: - Functions

}

extension TimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listTimelines.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let timelineInfo = self.listTimelines[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseTimelineCell", for: indexPath) as? BaseTimelineCell {
            cell.updateData(timelineInfo)
            // Configure the cell
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let timelineInfo = self.listTimelines[indexPath.row]
        if let size = timelineInfo.size {
            return size
        }

        return BaseTimelineCell.getSize(timelineInfo) ?? CGSize.zero
    }
}
