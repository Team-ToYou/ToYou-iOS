//
//  DiaryCardPreviewController.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit
import Alamofire

class DiaryCardPreviewController: UIViewController {
    let diaryCardPreview = DiaryCardPreview()
    
    var questionsAndAnswers: [DiaryCardAnswerModel] = []
    private var isLocked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardPreview
        setAction()
        setDelegate()
    }
    
    // MARK: - action
    private func setDelegate() {
        diaryCardPreview.previewCard.answerTableView.dataSource = self
    }
    
    private func setAction() {
        diaryCardPreview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        diaryCardPreview.previewCard.lockButton.addTarget(self, action: #selector(lockButtonTapped), for: .touchUpInside)
        diaryCardPreview.saveEditButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func lockButtonTapped() {
//        guard let cardID = self.cardID else { return }
        isLocked.toggle()
        let image = isLocked ? UIImage.lockIcon : UIImage.unlockIcon
        diaryCardPreview.previewCard.lockButton.setImage(image, for: .normal)
        
//        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer " + accessToken
//        ]
//        
//        let tail = "/diarycards/\(cardID)/exposure"
//        let url = K.URLString.baseURL + tail
//        
//        AF.request(url, method: .patch, headers: headers)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    print("exposure change success")
//                case .failure(let error):
//                    print(error)
//                    
//                    self.isLocked.toggle()
//                    let rollbackIcon = self.isLocked ? UIImage.lockIcon : UIImage.unlockIcon
//                    self.diaryCardPreview.previewCard.lockButton.setImage(rollbackIcon, for: .normal)
//                }
//            }
    }
    
    @objc private func saveButtonTapped() {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        
        var questionList: [[String: Any]] = []

        for item in questionsAndAnswers {
            var answer: String

            if let selectedIndex = item.selectedIndex, selectedIndex < item.answers.count {
                answer = item.answers[selectedIndex]
            } else {
                answer = item.answers.first ?? ""
            }

            questionList.append([
                "questionId": item.questionId,
                "answer": answer
            ])
        }
        
        let body: [String: Any] = [
            "exposure": !isLocked,
            "questionList": questionList
        ]
        
        let url = K.URLString.baseURL + "/diarycards"
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: CreateDiaryCardResponse.self) { response in
                switch response.result {
                case .success(let result):
                    print("일기카드 생성 성공: \(result.result.cardId)")
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                case .failure(let error):
                    print("일기카드 생성 실패: \(error)")
                    if let data = response.data,
                       let message = String(data: data, encoding: .utf8) {
                        print("서버 메시지: \(message)")
                    }
                }
            }
    }
}

extension DiaryCardPreviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsAndAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCardAnswerCell.identifier, for: indexPath) as? DiaryCardAnswerCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let item = questionsAndAnswers[indexPath.row]
        cell.configure(question: item.question, answers: item.answers, selectedIndex: item.selectedIndex)

        return cell
    }
}
