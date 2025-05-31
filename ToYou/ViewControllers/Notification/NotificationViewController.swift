//
//  NotificationViewController.swift
//  ToYou
//
//  Created by 이승준 on 5/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    let notificationView = NotificationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationView.notificationTableView.delegate = self
        notificationView.notificationTableView.dataSource = self
        notificationView.friendTableView.delegate = self
        notificationView.friendTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotificationData()
        notificationView.setConstraints()
        self.view = notificationView
    }
    
    private func fetchNotificationData() {
        NotificationAPIService.getNotificationList { _ in }
        NotificationAPIService.getFriendRequestList { _ in }
    }
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == notificationView.notificationTableView { // CollectionVeiw가 두 개
            let count = NotificationAPIService.shared.notificationData.count
            if count > 0 {
                notificationView.hasNotificationMode()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.notificationView.noNotificationMode()
                }
            }
            return NotificationAPIService.shared.notificationData.count
        } else if tableView == notificationView.friendTableView {
            let count = NotificationAPIService.shared.friendRequestData.count
            if count > 0 {
                notificationView.hasFriendRequestMode()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.notificationView.noFriendRequestMode()
                }
            }
            return NotificationAPIService.shared.friendRequestData.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationView.notificationTableView {
            let data = NotificationAPIService.shared.notificationData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
            cell.configure(data)
            cell.selectionStyle = .none // 선택 시, 회색배경화면 제거
            return cell
        } else if tableView == notificationView.friendTableView {
            let data = NotificationAPIService.shared.friendRequestData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestCell.identifier, for: indexPath) as! FriendRequestCell
            cell.configure(data)
            cell.selectionStyle = .none // 선택 시, 회색배경화면 제거
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == notificationView.notificationTableView {
            return 64 + 11
        } else {
            return 64
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notificationView.notificationTableView {
            // 질문을 받은 뷰컨으로 넘기기
            
        }
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 액션 생성 및 설정
        let transparentAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            // 액션 수행 코드
            if tableView == self.notificationView.notificationTableView {
                // 알림 삭제 API 연동
                NotificationAPIService.removeNotification(index: indexPath.row) { code in
                    switch code {
                    case .COMMON200:
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    default :
                        print("""
                              #NotificationViewController.swift
                              func removeNotification
                              \(code) 발생
                              """)
                        break
                    }
                }
                completionHandler(true)
            } else if tableView == self.notificationView.friendTableView {
                // 친구 요청 거절 API 요청
                guard let id = NotificationAPIService.shared.friendRequestData[indexPath.row].userId else {
                    print("NotificationAPIService.shared.friendRequestData[\(indexPath.row)]에서 nil값이 발견됨")
                    return
                }
                NotificationAPIService.shared.friendRequestData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                FriendsAPIService.deleteFriend(friendId: id) { code in
                    switch code {
                    case .COMMON200:
                        NotificationAPIService.shared.friendRequestData.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    case .FRIEND401:
                        // 요청 정보가 존재하지 않다고 POP-UP
                    default :
                        print("""
                              #NotificationViewController.swift
                              func deleteFriend
                              \(code) 발생
                              """)
                        break
                    }
                }
                completionHandler(true)
            }
            completionHandler(false) // 작업 완료 알림
        }
        
        transparentAction.image = .trashcan35X38
        transparentAction.backgroundColor = UIColor(white: 1, alpha: 0) // 배경색을 투명하게 설정
        return UISwipeActionsConfiguration(actions: [transparentAction])
    }
}

import SwiftUI
#Preview {
    NotificationViewController()
}
