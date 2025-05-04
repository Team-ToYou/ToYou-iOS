//
//  DiaryCardAnswerViewController.swift
//  ToYou
//
//  Created by 김미주 on 18/03/2025.
//

import UIKit

class DiaryCardAnswerViewController: UIViewController {
    let diaryCardAnswerView = DiaryCardAnswerView()
    
    var selectedQuestions: [Question] = []
    
    private var longQuestions: [Question] = []
    private var shortQuestions: [Question] = []
    private var selectQuestions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardAnswerView

        setCollectionView()
        setAction()
        classifyQuestions()
    }
    
    // MARK: - function
    private func setCollectionView() {
        diaryCardAnswerView.longOptionCollectionView.dataSource = self
        diaryCardAnswerView.longOptionCollectionView.delegate = self
        diaryCardAnswerView.shortOptionCollectionView.dataSource = self
        diaryCardAnswerView.shortOptionCollectionView.delegate = self
        diaryCardAnswerView.selectOptionCollectionView.dataSource = self
        diaryCardAnswerView.selectOptionCollectionView.delegate = self
    }
    
    private func classifyQuestions() {
        longQuestions = selectedQuestions.filter { $0.questionType == .long }
        shortQuestions = selectedQuestions.filter { $0.questionType == .short }
        selectQuestions = selectedQuestions.filter { $0.questionType == .optional }
        
        diaryCardAnswerView.longStack.isHidden = longQuestions.isEmpty
        diaryCardAnswerView.shortStack.isHidden = shortQuestions.isEmpty
        diaryCardAnswerView.selectStack.isHidden = selectQuestions.isEmpty
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardAnswerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        diaryCardAnswerView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        let previewVC = DiaryCardPreviewController()
        previewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

// MARK: - extension
extension DiaryCardAnswerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == diaryCardAnswerView.longOptionCollectionView {
            return longQuestions.count
        } else if collectionView == diaryCardAnswerView.shortOptionCollectionView {
            return shortQuestions.count
        } else if collectionView == diaryCardAnswerView.selectOptionCollectionView {
            return selectQuestions.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == diaryCardAnswerView.longOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongAnswerCell.identifier, for: indexPath) as? LongAnswerCell else {
                return UICollectionViewCell()
            }
            let question = longQuestions[indexPath.item]
            cell.setQuestion(content: question.content, questioner: question.questioner)
            return cell
        } else if collectionView == diaryCardAnswerView.shortOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortAnswerCell.identifier, for: indexPath) as? ShortAnswerCell else {
                return UICollectionViewCell()
            }
            let question = shortQuestions[indexPath.item]
            cell.setQuestion(content: question.content, questioner: question.questioner)
            return cell
        } else if collectionView == diaryCardAnswerView.selectOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAnswerCell.identifier, for: indexPath) as? SelectAnswerCell else {
                return UICollectionViewCell()
            }
            let question = selectQuestions[indexPath.item]
            cell.setQuestion(content: question.content, options: question.answerOption ?? [], questioner: question.questioner)
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension DiaryCardAnswerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == diaryCardAnswerView.longOptionCollectionView {
            return CGSize(width: 171, height: 230)
        } else if collectionView == diaryCardAnswerView.shortOptionCollectionView {
            return CGSize(width: 171, height: 125)
        } else if collectionView == diaryCardAnswerView.selectOptionCollectionView {
            return CGSize(width: 171, height: 160)
        }
        return CGSize(width: 100, height: 100)
    }
}
