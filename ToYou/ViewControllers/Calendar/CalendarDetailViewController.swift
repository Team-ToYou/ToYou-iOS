//
//  CalendarDetailViewController.swift
//  ToYou
//
//  Created by 김미주 on 6/23/25.
//

import Foundation
import UIKit
import Alamofire

class CalendarDetailViewController: UIViewController {
    private var calendarDetailView: CalendarDetailView!
    private let deletePopupVC = DiaryCardDeletePopupViewController()
    
    public var emotion: Emotion = .NORMAL
    public var cardId: Int!
    
    private var questionsAndAnswers: [DiaryCardAnswerModel] = []
    private var isLocked: Bool = false
    public var isFriend: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarDetailView = CalendarDetailView(emotion: emotion)
        self.view = calendarDetailView
        deletePopupVC.modalPresentationStyle = .overFullScreen
        
        calendarDetailView.diaryCard.answerTableView.dataSource = self
        
        setAction()
        fetchDiaryCardDetail(id: cardId)
        
        if isFriend {
            calendarDetailView.deleteButton.isHidden = true
        }
    }
    
    // MARK: - function
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
        calendarDetailView.diaryCard.configure(detail: detail)

        isLocked = !detail.exposure
        let icon = isLocked ? UIImage.lockIcon : UIImage.unlockIcon
        calendarDetailView.diaryCard.lockButton.setImage(icon, for: .normal)

        questionsAndAnswers = detail.questionList.map { question in
            let selectedIndex = question.questionType == "OPTIONAL"
                ? question.answerOption.firstIndex(of: question.answer)
                : nil

            return DiaryCardAnswerModel(
                questionId: question.questionId,
                question: question.content,
                answers: question.questionType == "OPTIONAL" ? question.answerOption : [question.answer],
                selectedIndex: selectedIndex
            )
        }
        
        calendarDetailView.diaryCard.answerTableView.reloadData()
    }
    
    // MARK: - action
    private func setAction() {
        calendarDetailView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        calendarDetailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    @objc private func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func deleteButtonTapped() {
        deletePopupVC.cardId = cardId
        
        deletePopupVC.completionHandler = { [weak self] isDeleted in
            if isDeleted {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        self.present(deletePopupVC, animated: false, completion: nil)
    }
}

// MARK: - Extension
extension CalendarDetailViewController: UITableViewDataSource {
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
