//
//  DiaryCardSelectViewController.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit
import Alamofire

protocol QuestionSelectable {
    var checkboxButton: CheckBoxButtonVer02 { get }
}

class DiaryCardSelectViewController: UIViewController {
    var emotion: Emotion = .NORMAL
    let diaryCardSelectView = DiaryCardSelectView()
    var cardId: Int?
    
    private var selectedItemsCount: Int = 0
    private var selectedQuestions: [Question] = []
    
    private var longQuestionList: [Question] = []
    private var shortQuestionList: [Question] = []
    private var selectQuestionList: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardSelectView
        
        setCollectionView()
        setAction()
        setAPI()
    }
    
    // MARK: - function
    private func setCollectionView() {
        diaryCardSelectView.longOptionCollectionView.dataSource = self
        diaryCardSelectView.longOptionCollectionView.delegate = self
        diaryCardSelectView.shortOptionCollectionView.dataSource = self
        diaryCardSelectView.shortOptionCollectionView.delegate = self
        diaryCardSelectView.selectOptionCollectionView.dataSource = self
        diaryCardSelectView.selectOptionCollectionView.delegate = self
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardSelectView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        diaryCardSelectView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        let answerVC = DiaryCardAnswerViewController()
        answerVC.cardId = self.cardId
        answerVC.emotion = self.emotion
        answerVC.hidesBottomBarWhenPushed = true
        answerVC.selectedQuestions = selectedQuestions
        self.navigationController?.pushViewController(answerVC, animated: true)
    }
    
    // MARK: - function
    private func updateNextButtonState() {
        let isActive = selectedItemsCount > 0
        diaryCardSelectView.nextButton.isEnabled = isActive ? true : false
        diaryCardSelectView.nextButton.backgroundColor = isActive ? .black01 : .gray00
        diaryCardSelectView.nextButton.setTitleColor(isActive ? .black04 : .black01, for: .normal)
    }

    private func setAPI() {
        let url = "https://to-you.store/questions"
        
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: QuestionResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("questions api success")
                    
                    // 질문 타입에 따라 분류
                    self.longQuestionList = data.result.questionList.filter { $0.questionType == .long }
                    self.shortQuestionList = data.result.questionList.filter { $0.questionType == .short }
                    self.selectQuestionList = data.result.questionList.filter { $0.questionType == .optional }

                    // UI 업데이트
                    self.diaryCardSelectView.longOptionCollectionView.reloadData()
                    self.diaryCardSelectView.shortOptionCollectionView.reloadData()
                    self.diaryCardSelectView.selectOptionCollectionView.reloadData()
                    
                case .failure(let error):
                    print("questions api fail: \(error)")
                }
            }
    }
    
    private func toggleSelection(for collectionView: UICollectionView, at indexPath: IndexPath) {
        let question: Question
        let cell: (UICollectionViewCell & QuestionSelectable)

        if collectionView == diaryCardSelectView.longOptionCollectionView {
            question = longQuestionList[indexPath.item]
            cell = collectionView.cellForItem(at: indexPath) as! NonSelectQuestionCell
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            question = shortQuestionList[indexPath.item]
            cell = collectionView.cellForItem(at: indexPath) as! NonSelectQuestionCell
        } else {
            question = selectQuestionList[indexPath.item]
            cell = collectionView.cellForItem(at: indexPath) as! SelectQuestionCell
        }

        cell.checkboxButton.toggle()

        if cell.checkboxButton.isChecked {
            selectedItemsCount += 1
            selectedQuestions.append(question)
        } else {
            selectedItemsCount -= 1
            selectedQuestions.removeAll { $0.questionId == question.questionId }
        }

        updateNextButtonState()
    }
}

// MARK: - extension
extension DiaryCardSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            return longQuestionList.count
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            return shortQuestionList.count
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            return selectQuestionList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonSelectQuestionCell.identifier, for: indexPath) as? NonSelectQuestionCell else {
                return UICollectionViewCell()
            }
            let question = longQuestionList[indexPath.item]
            cell.setQuestion(content: question.content, questioner: question.questioner)
            return cell
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonSelectQuestionCell.identifier, for: indexPath) as? NonSelectQuestionCell else {
                return UICollectionViewCell()
            }
            let question = shortQuestionList[indexPath.item]
            cell.setQuestion(content: question.content, questioner: question.questioner)
            return cell
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectQuestionCell.identifier, for: indexPath) as? SelectQuestionCell else {
                return UICollectionViewCell()
            }
            let question = selectQuestionList[indexPath.item]
            cell.setQuestion(content: question.content, options: question.answerOption ?? [], questioner: question.questioner)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleSelection(for: collectionView, at: indexPath)
    }
    
}

extension DiaryCardSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == diaryCardSelectView.selectOptionCollectionView {
            return CGSize(width: 172, height: 190)
        } else {
            return CGSize(width: 170, height: 100)
        }
    }
}
