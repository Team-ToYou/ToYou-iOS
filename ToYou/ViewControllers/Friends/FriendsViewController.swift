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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = friendsView
        disconnectPopupVC.modalPresentationStyle = .overFullScreen
        friendsView.friendsCollectionView.delegate = self
        friendsView.friendsCollectionView.dataSource = self
        friendsView.searchTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
}

// MARK: 친구요청 보내기
extension FriendsViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nickname = friendsView.searchTextField.text ?? ""
        searchUserNickname(nickname)
        return true
    }
    
    private func searchUserNickname(_ nickname: String) {
        if nickname.isEmpty {
            view.endEditing(true)
            return
        } // 빈거면 그냥 내리기
        // API 연동
        guard let accessToken = KeychainService.get(key: K.Key.accessToken),
              let encodedNickname = nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        print(encodedNickname)
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
        .responseDecodable(of: ToYouResponse<SearchFriendRecord>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                print(apiResponse)
                switch apiResponse.result?.friendStatus {
                case "FRIEND": // 친구
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .alreadyFriend)
                case "NOT_FRIEND": // 친구 X
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .canRequest)
                case "REQUEST_SENT": // 친구 요청 보냄
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .cancelRequire)
                case "REQUEST_RECEIVED": // 친구 요청 받음
                    self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .sentRequestToMe)
                case .none:
                    if apiResponse.code == "USER400" {
                        self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .notExist)
                    } else if apiResponse.code == "USER401" {
                        self.friendsView.friendSearchResultView.configure(emotion: .none, nickname: nickname, state: .couldNotSendToMe)
                    }
                default:
                    break
                }
            case .failure(let error):
                print("\(url) get 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    struct SearchFriendRecord: Codable {
        let userId: Int
        let nickname: String
        let friendStatus: String
    }
    
    enum RequestStatus: Codable {
        case FRIEND, NOT_FRIEND, REQUEST_SENT, REQUEST_RECEIVED
    }
    
}

extension FriendsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendsModel.dummies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = FriendsModel.dummies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCollectionViewCell.identifier, for: indexPath) as! FriendsCollectionViewCell
        cell.configure(friend: data, delegate: self)
        return cell
    }
}

extension FriendsViewController: FriendCollectionViewCellDelegate {
    
    func sendQuery(to friend: FriendInfo) {
        let selectQueryVC = SelectQueryViewController()
        selectQueryVC.modalPresentationStyle = .overFullScreen
        selectQueryVC.configure(by: friend)
        present(selectQueryVC, animated: true)
    }
    
    func disconnect(with friend: FriendInfo) {
        present(disconnectPopupVC, animated: false)
        
        disconnectPopupVC.completionHandler = { data in
            if data {
                // 친구 삭제 진행
                print("\(friend.nickname)을 삭제합니다.")
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
