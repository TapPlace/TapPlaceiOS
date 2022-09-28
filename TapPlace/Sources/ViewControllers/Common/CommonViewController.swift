//
//  CommonViewController.swift
//  TapPlace
//
//  Created by 박상현 on 2022/08/20.
//

import UIKit

class CommonViewController: UIViewController {
    var tabBar: TabBarViewController?
    var storeViewModel = StoreViewModel()
    var storageViewModel = StorageViewModel()
    var bookmarkViewModel = BookmarkViewModel()
    var feedbackViewModel = FeedbackViewModel()
    var userViewModel = UserViewModel()
    let authorization = Authorization.shared
    let fcm = FCM.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customTabBar = tabBarController as? TabBarViewController else { return }
        setupNotification()
        tabBar = customTabBar
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(shareStoreObserver), name: NSNotification.Name.showShare, object: nil)
    }
    
    @objc func shareStoreObserver(_ notification: Notification) {
//        print("노티 수신")
        guard let storeID = notification.object as? String else { return }
//        print("노티로 받은 storeID: \(storeID)")
        // FIXME: MVVM 수정
//        storeViewModel.requestStoreInfo(storeID: storeID, pays: storageViewModel.userFavoritePaymentsString) { result in
//            guard let storeInfo = result as? StoreInfo else { return }
//            var objectToShare = [String]()
//            let shareText = "\(storeInfo.placeName)의 간편결제 정보입니다.\n\n\(Constants.tapplaceBaseUrl)/app/\(storeInfo.storeID)"
//            objectToShare.append(shareText)
//            
//            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
//            self.present(activityVC, animated: true)
//        }
    }
}
