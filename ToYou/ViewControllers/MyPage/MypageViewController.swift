//
//  ProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {
    
    var myPageInfo: MyPageResult?
    
    let myPageView = MyPageView()
    
    let sendFeedbackWebVC = SendFeedbackWebVC()
    let sendQueryWebVC = SendQueryWebVC()
    let policyLinkWebVC = PrivacyPolicyWebVC()
    let editProfileViewController = EditProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
        self.myPageView.scrollView.delegate = self
        addButtonActions()
        
        sendFeedbackWebVC.modalPresentationStyle = .popover
        sendQueryWebVC.modalPresentationStyle = .popover
        policyLinkWebVC.modalPresentationStyle = .popover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myPageView.setConstraints()
    }
    
}

extension MyPageViewController {
    
    private func fetchUserInfo() {
        let url = K.URLString.baseURL + "/users/mypage"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseDecodable(of: ToYouResponse<MyPageResult>.self) { response in
            switch response.result {
            case .success(let APIResponse):
                guard let result = APIResponse.result else { return }
                self.myPageInfo = result
                self.myPageView.configure(myPageInfo: result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension MyPageViewController {
    
    private func addButtonActions() {
        myPageView.editProfileDetailButton.addTarget(self, action: #selector(goToEditProfile), for: .touchUpInside)
        myPageView.notificationSetButton.addTarget(self, action: #selector(goToNotification), for: .touchUpInside)
        myPageView.sendFeedbackButton.addTarget(self, action: #selector(openSendFeedbackWebVC), for: .touchUpInside)
        myPageView.sendQueryButton.addTarget(self, action: #selector(openSendQueryWebVC), for: .touchUpInside)
        myPageView.policyButton.addTarget(self, action: #selector(openPrivacyPolicyWebVC), for: .touchUpInside)
        myPageView.revokeButton.addTarget(self, action: #selector(revokeButtonPressed), for: .touchUpInside)
        myPageView.logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func goToEditProfile() {
        self.editProfileViewController.configure(myPageInfo: self.myPageInfo!)
        editProfileViewController.refreshMyPage = { [weak self] data in
            self?.myPageView.nicknameLabel.text = data
        }
        editProfileViewController.modalPresentationStyle = .overFullScreen
        present(editProfileViewController, animated: false)
    }
    
    @objc
    private func goToNotification() {
        let setNotificationViewController = SetNotificationViewController()
        setNotificationViewController.modalPresentationStyle = .overFullScreen
        present(setNotificationViewController, animated: false)
    }
    
    @objc
    private func openSendFeedbackWebVC() {
        present(sendFeedbackWebVC, animated: true)
    }
    
    @objc
    private func openSendQueryWebVC() {
        present(sendQueryWebVC, animated: true)
    }
    
    @objc
    private func openPrivacyPolicyWebVC() {
        present(policyLinkWebVC, animated: true)
    }
    
    @objc
    private func revokeButtonPressed() {
        let revokeVC = RevokePopupVC()
        revokeVC.modalPresentationStyle = .overFullScreen
        revokeVC.modalTransitionStyle = .crossDissolve
        present(revokeVC, animated: false, completion: nil)
    }
    
    @objc
    private func logoutButtonPressed() {
        let logoutVC = LogoutPopupVC()
        logoutVC.modalPresentationStyle = .overFullScreen
        logoutVC.modalTransitionStyle = .crossDissolve
        present(logoutVC, animated: false, completion: nil)
    }
    
}

extension MyPageViewController: UIScrollViewDelegate {
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
