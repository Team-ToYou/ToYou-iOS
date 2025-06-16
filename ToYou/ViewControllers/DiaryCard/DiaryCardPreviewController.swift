//
//  DiaryCardPreviewController.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit
import Alamofire

class DiaryCardPreviewController: UIViewController {
    var emotion: Emotion = .NORMAL
    private var diaryCardPreview: DiaryCardPreview!

    var questionsAndAnswers: [DiaryCardAnswerModel] = []
    private var isLocked = false
    private var cardId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryCardPreview = DiaryCardPreview(emotion: emotion)
        self.view = diaryCardPreview
        
        if let name = UsersAPIService.myPageInfo?.nickname {
            diaryCardPreview.previewCard.updateToLabel(name: name)
        }
        
        setAction()
        setDelegate()
    }
    
    // MARK: - function
    private func getTodayCardId(year: Int, month: Int, completion: @escaping (Int?) -> Void) {
        let url = "\(K.URLString.baseURL)/diarycards/mine?year=\(year)&month=\(month)"

        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }

        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MyDiaryCardResponse.self) { response in
                switch response.result {
                case .success(let data):
                    let todayString = formatter.string(from: Date())
                    if let todayCard = data.result.cardList.first(where: { $0.date == todayString }) {
                        print("오늘 카드 ID: \(todayCard.cardId)")
                        self.cardId = todayCard.cardId
                        completion(todayCard.cardId)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print("오늘 카드 ID 조회 실패: \(error)")
                }
            }
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
        isLocked.toggle()
        let image = isLocked ? UIImage.lockIcon : UIImage.unlockIcon
        diaryCardPreview.previewCard.lockButton.setImage(image, for: .normal)
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
        
        if diaryCardPreview.isSaved {
            if let nav = self.navigationController {
                for vc in nav.viewControllers {
                    if vc is DiaryCardSelectViewController {
                        nav.popToViewController(vc, animated: true)
                        return
                    }
                }
            }
        }
        
        let url = K.URLString.baseURL + "/diarycards"
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: CreateDiaryCardResponse.self) { response in
                switch response.result {
                case .success(let result):
                    print("일기카드 생성 성공: \(result.result.cardId)")
                    
                    DispatchQueue.main.async {
                        self.cardId = result.result.cardId
                        self.diaryCardPreview.isSaved = true
                    }
                    
                case .failure(let error):
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let code = json["code"] as? String, code == "CARD400" {
                        let today = Date()
                        let calendar = Calendar.current
                        let year = calendar.component(.year, from: today)
                        let month = calendar.component(.month, from: today)
                        
                        self.getTodayCardId(year: year, month: month) { fetchedCardId in
                            guard let cardId = fetchedCardId else {
                                print("cardId 없음 (completion)")
                                return
                            }

                            let patchURL = K.URLString.baseURL + "/diarycards/\(cardId)"

                            AF.request(patchURL, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: headers)
                                .validate()
                                .response { patchResponse in
                                    switch patchResponse.result {
                                    case .success:
                                        print("일기카드 수정 성공")
                                        DispatchQueue.main.async {
                                            self.cardId = cardId
                                            self.diaryCardPreview.isSaved = true
                                        }
                                    case .failure(let patchError):
                                        print("일기카드 수정 실패: \(patchError)")
                                    }
                                }
                        }
                    } else {
                        print("일기카드 생성 실패: \(error)")
                        if let data = response.data,
                           let message = String(data: data, encoding: .utf8) {
                            print("서버 메시지: \(message)")
                        }
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
        cell.configure(question: item.question, answers: item.answers, selectedIndex: item.selectedIndex, emotion: emotion)

        return cell
    }
}
