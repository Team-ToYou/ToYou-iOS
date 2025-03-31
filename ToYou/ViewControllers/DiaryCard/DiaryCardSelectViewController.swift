//
//  DiaryCardSelectViewController.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit
import Alamofire

class DiaryCardSelectViewController: UIViewController {
    let diaryCardSelectView = DiaryCardSelectView()
    
    private var selectedItemsCount: Int = 0
    
    private var longQuestionList: [Question] = []
    private var shortQuestionList: [Question] = []
    private var selectQuestionList: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardSelectView
        
        diaryCardSelectView.longOptionCollectionView.dataSource = self
        diaryCardSelectView.longOptionCollectionView.delegate = self
        diaryCardSelectView.shortOptionCollectionView.dataSource = self
        diaryCardSelectView.shortOptionCollectionView.delegate = self
        diaryCardSelectView.selectOptionCollectionView.dataSource = self
        diaryCardSelectView.selectOptionCollectionView.delegate = self
        
        setAction()
        setAPI()
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
        answerVC.hidesBottomBarWhenPushed = true
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
        
        // 임시 accessToken
        let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NDI4MTA1MTIsImV4cCI6MTc0NDAyMDExMiwic3ViIjoiMiIsImlkIjoyLCJjYXRlZ29yeSI6ImFjY2VzcyJ9.P07B0Yl4RZk0TGuIYOrw2LQndsFY3XysjbliOoX7IxE"
        
        let headers: HTTPHeaders = [
            "Authorization": token
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
                    print("questions api fail")
                }
            }
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
            cell.optionTableView.isUserInteractionEnabled = false
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? NonSelectQuestionCell else { return }
            
            cell.checkboxButton.toggle()
            
            if cell.checkboxButton.isChecked {
                selectedItemsCount += 1
            } else {
                selectedItemsCount -= 1
            }
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? NonSelectQuestionCell else { return }
            
            cell.checkboxButton.toggle()
            
            if cell.checkboxButton.isChecked {
                selectedItemsCount += 1
            } else {
                selectedItemsCount -= 1
            }
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? SelectQuestionCell else { return }
            
            cell.checkboxButton.toggle()
            
            if cell.checkboxButton.isChecked {
                selectedItemsCount += 1
            } else {
                selectedItemsCount -= 1
            }
        }
        
        updateNextButtonState()

    }
    
}

extension DiaryCardSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            return CGSize(width: 170, height: 100)
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            return CGSize(width: 170, height: 100)
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            return CGSize(width: 172, height: 190)
        }
        return CGSize(width: 100, height: 100)
    }
}
