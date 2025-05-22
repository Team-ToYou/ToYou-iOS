//
//  LetterComposeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Alamofire

class FriendsViewController: UIViewController, UITextFieldDelegate {
    
    let friendsView = FriendsView()
    let disconnectPopupVC = DisconnectFriendPopupVC()
    var searchFriendResult: SearchFriendResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = friendsView
        disconnectPopupVC.modalPresentationStyle = .overFullScreen
        friendsView.friendsCollectionView.delegate = self
        friendsView.friendsCollectionView.dataSource = self
        friendsView.searchTextField.delegate = self
        hideKeyboardWhenTappedAround()
        self.addActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FriendsList.fetchList { code in
            switch code {
            case .COMMON200:
                self.friendsView.friendsCollectionView.reloadData()
            case .JWT400:
                RootViewControllerService.toLoginViewController()
            case .FRIEND401: // 해당 친구 정보가 존재하지 않음
                break
            case .ERROR500:
                break
            }
        }
    }
    
}

// MARK: 친구 추가하기
extension FriendsViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nickname = friendsView.searchTextField.text ?? ""
        searchUserNickname(nickname)
        return true
    }
    // 친구 검색
    private func searchUserNickname(_ nickname: String) {
        if nickname.isEmpty {
            view.endEditing(true)
            return
        } // 빈거면 그냥 내리기
        // API 연동
        guard let accessToken = KeychainService.get(key: K.Key.accessToken),
              let encodedNickname = nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let tail = "/friends/search"
        let url = K.URLString.baseURL + tail + "?keyword=" + encodedNickname
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers,
        )
        .responseDecodable(of: ToYouResponse<SearchFriendResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                print(apiResponse)
                switch apiResponse.result?.friendStatus {
                case .FRIEND: // 친구
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .alreadyFriend)
                case .NOT_FRIEND: // 친구 X
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .canRequest)
                case .REQUEST_SENT: // 친구 요청 보냄
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .cancelRequire)
                case .REQUEST_RECEIVED: // 친구 요청 받음
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .sentRequestToMe)
                case .none:
                    if apiResponse.code == "USER400" {
                        self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .notExist)
                    } else if apiResponse.code == "USER401" {
                        self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .couldNotSendToMe)
                    }
                }
                self.searchFriendResult = apiResponse.result
            case .failure(let error):
                self.friendsView.friendSearchResultView.configure(emotion: .NORMAL, nickname: " ", state: .networkError)
                print("\(url) get 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func addActions() {
        self.friendsView.friendSearchResultView.stateButton.addTarget(self, action: #selector(friendButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func friendButtonTapped() {
        friendsAPI(searchFriendResult?.friendStatus ?? nil)
    }
    
    private func friendsAPI(_ status: FriendStatusEnum?) {
        var method: HTTPMethod?
        var tail: String?
        switch status {
        case .FRIEND, .none: // 함수 종료
            return
        case .NOT_FRIEND: // 요청 하기
            tail = "/friends/requests"
            method = .post
        case .REQUEST_SENT: // 요청 거절/취소하기
            tail = "/friends"
            method = .delete
        case .REQUEST_RECEIVED: // 요청 수락하기
            tail = "/friends/requests/approve"
            method = .patch
        }
        guard let accessToken = KeychainService.get(key: K.Key.accessToken),
              let userId = searchFriendResult?.userId else { return }
        let url = K.URLString.baseURL + tail!
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "userId": userId
        ]
        AF.request(
            url,
            method: method!,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
        ).responseDecodable(of: ToYouResponse<RequestFriendResult>.self) { response in
            switch response.result {
            case .success(_):
                print("\(String(describing: method)) 요청 완료")
                switch status {
                case .FRIEND: // 이미 친구인 상태
                    break
                case .NOT_FRIEND: // 요청하기가 완료
                    self.searchFriendResult?.friendStatus = .REQUEST_SENT
                    self.friendsView.friendSearchResultView.afterRequestSucceeded()
                case .REQUEST_SENT:
                    self.searchFriendResult?.friendStatus = .NOT_FRIEND
                    self.friendsView.friendSearchResultView.afterRequestCanceledOrDenied()
                case .REQUEST_RECEIVED: // 요청 수락
                    FriendsList.fetchList { code in // 리스트 업데이트
                        switch code {
                        case .COMMON200:
                            self.friendsView.friendSearchResultView.afterAcceptRequest()
                            self.friendsView.friendsCollectionView.reloadData()
                        case .JWT400:
                            RootViewControllerService.toLoginViewController()
                        case .ERROR500, .FRIEND401:
                            break
                        }
                    }
                case .none:
                    break
                }
                return
            case .failure(let error):
                print("\(url) \(String(describing: method)) 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
}

struct RequestFriendResult: Codable {
    let myName: String
}
    
struct SearchFriendResult: Codable {
    let userId: Int
    let nickname: String
    var friendStatus: FriendStatusEnum
}

enum FriendStatusEnum: String, Codable {
    case FRIEND, NOT_FRIEND, REQUEST_SENT, REQUEST_RECEIVED
}

extension FriendsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendsList.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = FriendsList.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCollectionViewCell.identifier, for: indexPath) as! FriendsCollectionViewCell
        cell.configure(friend: data, delegate: self)
        return cell
    }
}

extension FriendsViewController: FriendCollectionViewCellDelegate {
    
    func sendQuery(to friend: FriendInfo) {
        let selectQueryVC = QueryTypeViewController()
        selectQueryVC.modalPresentationStyle = .overFullScreen
        selectQueryVC.configure(by: friend)
        QueryAPIService.setTargetId(friend.userId)
        present(selectQueryVC, animated: true)
    }
    
    func disconnect(with friend: FriendInfo) {
        present(disconnectPopupVC, animated: true)
        
        disconnectPopupVC.completionHandler = { data in
            if data {
                FriendsList.deleteFriend(friendId: friend.userId) { code in
                    switch code {
                    case .COMMON200:
                        FriendsList.fetchList { code in
                            if code == .COMMON200 {
                                self.friendsView.friendsCollectionView.reloadData()
                            }
                        }
                    case .JWT400:
                        RootViewControllerService.toLoginViewController()
                    case .ERROR500:
                        break
                    case .FRIEND401:
                        break
                    }
                }
            } else {
                print("\(friend.nickname)을 삭제를 취소합니다.")
            }
        }
    }
    
}

// 레이아웃 델리게이트 추가
extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

import SwiftUI
#Preview {
    FriendsViewController()
}
