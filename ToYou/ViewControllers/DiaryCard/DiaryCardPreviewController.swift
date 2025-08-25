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
    private var isLocked: Bool = false
    public var isEditMode: Bool = false
    public var isPreviewMode: Bool = false
    private var cardId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryCardPreview = DiaryCardPreview(emotion: emotion)
        self.view = diaryCardPreview
        
        diaryCardPreview.isSaved = isPreviewMode
        
        let buttonTitle = isEditMode ? "수정하기" : "저장하기"
        diaryCardPreview.saveEditButton.setTitle(buttonTitle, for: .normal)
        
        setAction()
        setDelegate()
        
        if !questionsAndAnswers.isEmpty {
            let name = UsersAPIService.myPageInfo?.nickname ?? "000"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateString = dateFormatter.string(from: Date())
            
            // questionsAndAnswers -> qaPairs
            let qaPairs = questionsAndAnswers.map {
                (
                    question: $0.question,
                    answers: $0.answers,
                    selectedIndex: $0.selectedIndex
                )
            }

            diaryCardPreview.previewCard.configurePreview(
                nickname: name,
                date: dateString,
                emotion: emotion,
                qaPairs: qaPairs
            )
            return
        }
        
        if let id = cardId {
            fetchDiaryCardDetail(id: id)
        }
    }
    
    // MARK: - function
    public func setCardId(_ id: Int) {
        self.cardId = id
    }
    
    private func fetchDiaryCardDetail(id: Int) {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let url = "\(K.URLString.baseURL)/diarycards/\(id)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: DiaryCardDetailResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        self.updateViewWithDetail(result.result)
                    } else {
                        print("API 실패: \(result.message)")
                    }
                case .failure(let error):
                    print("네트워크 에러: \(error.localizedDescription)")
                }
            }
    }

    private func updateViewWithDetail(_ detail: DiaryCardDetailResult) {
        isLocked = !detail.exposure
        let icon = isLocked ? UIImage.lockIcon : UIImage.unlockIcon
        diaryCardPreview.previewCard.lockButton.setImage(icon, for: .normal)

        let qaPairs = detail.questionList.map { question in
            (
                question: question.content,
                answers: question.questionType == "OPTIONAL" ? question.answerOption : [question.answer],
                selectedIndex: question.questionType == "OPTIONAL" ? question.answerOption.firstIndex(of: question.answer) : nil
            )
        }

        // configurePreview 호출
        let nickname = detail.receiver
        let dateString = formatDate(detail.date)
        diaryCardPreview.previewCard.configurePreview(
            nickname: nickname,
            date: dateString,
            emotion: emotion,
            qaPairs: qaPairs
        )

        // 서버 저장용 questionsAndAnswers에 데이터 넣기
        self.questionsAndAnswers = detail.questionList.map { question in
            DiaryCardAnswerModel(
                questionId: question.questionId,
                question: question.content,
                answers: question.questionType == "OPTIONAL" ? question.answerOption : [question.answer],
                selectedIndex: question.questionType == "OPTIONAL" ? question.answerOption.firstIndex(of: question.answer) : nil
            )
        }
    }

    
    private func formatDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyyMMdd"

        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return input
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
        
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        let url = K.URLString.baseURL + "/diarycards/\(cardId!)/exposure"
        
        AF.request(url, method: .patch, headers: headers)
            .validate()
            .responseDecodable(of: ExposureResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        print("공개 상태 변경 성공: \(result.result?.exposure == true ? "공개" : "비공개")")
                    } else {
                        print("공개 상태 변경 실패: \(result.message)")
                    }
                case .failure(let error):
                    print("공개 상태 변경 네트워크 오류: \(error.localizedDescription)")
                }
            }
    }
    
    @objc private func saveButtonTapped() {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer " + accessToken]
        
        var questionList: [[String: Any]] = []
        for item in questionsAndAnswers {
            let answer: String
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
        
        let currentTitle = diaryCardPreview.saveEditButton.title(for: .normal)
        
        if isEditMode && currentTitle == "수정하기" {
            let selectVC = DiaryCardSelectViewController()
            selectVC.emotion = self.emotion
            selectVC.hidesBottomBarWhenPushed = true
            selectVC.cardId = self.cardId
            self.navigationController?.pushViewController(selectVC, animated: true)
            return
        }
        
        let url = K.URLString.baseURL + (cardId != nil ? "/diarycards/\(cardId!)" : "/diarycards")
        let method: HTTPMethod = cardId != nil ? .patch : .post
        
        AF.request(url, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: CreateDiaryCardResponse.self) { response in
                switch response.result {
                case .success(let result):
                    print("일기카드 \(method == .post ? "생성" : "수정") 성공: \(String(describing: result.result?.cardId))")
                    DispatchQueue.main.async {
                        self.cardId = result.result?.cardId
                        self.diaryCardPreview.isSaved = true
                        
                        let homeVC = HomeViewController()
                        self.navigationController?.setViewControllers([homeVC], animated: true)
                    }
                case .failure(let error):
                    print("일기카드 저장 실패: \(error)")
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
        cell.configure(question: item.question, answers: item.answers, selectedIndex: item.selectedIndex, emotion: emotion)
        
        return cell
    }
}

import SwiftUI

#Preview {
    DiaryCardPreviewController()
}
