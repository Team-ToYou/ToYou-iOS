//
//  EmotionViewController.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit
import Alamofire

class EmotionViewController: UIViewController {
    let emotionView = EmotionView()
    let homeVC = HomeViewController()
    
//    var selectedEmotion: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emotionView
        
        emotionView.emotionTableView.dataSource = self
        emotionView.emotionTableView.delegate = self
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        emotionView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        emotionView.emotionPaperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewTapped)))
        emotionView.emotionPaperView.isUserInteractionEnabled = true
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func backViewTapped() {
//        homeVC.emotion = selectedEmotion!
        self.navigationController?.popViewController(animated: true)
    }

}

extension EmotionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmotionTableViewCell.identifier, for: indexPath) as? EmotionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        let item = EmotionStamp.dummy()[indexPath.row]
        cell.stampImage.image = item.image
        cell.emotionLabel.text = item.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emotionView.emotionPaperView.isHidden = false
        let item = EmotionStamp.dummy()[indexPath.row]
        
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        let param = ["emotion": item.emotion]

        AF.request("https://to-you.store/users/emotions",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: EmotionResponse.self) { response in
            debugPrint(response)

            switch response.result {
            case .success(let value):
                // 이미 감정 선택한 경우
                if !value.isSuccess && value.code == "USER402" {
                    print("오늘 감정 이미 선택됨")
                    return
                }

                // 성공한 경우: 감정 UI 보여주기
                self.emotionView.emotionView.backgroundColor = item.color
                self.emotionView.emotionView.isHidden = false
                self.emotionView.emotionLabel.text = item.result
                self.emotionView.emotionLabel.isHidden = false

            case .failure(let error):
                print("요청 실패: \(error)")
            }
        }


    }
}
