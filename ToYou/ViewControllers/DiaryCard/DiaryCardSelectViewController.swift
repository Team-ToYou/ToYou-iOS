//
//  DiaryCardSelectViewController.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class DiaryCardSelectViewController: UIViewController {
    let diaryCardSelectView = DiaryCardSelectView()
    
    private var selectedItemsCount: Int = 0

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

}

// MARK: - extension
extension DiaryCardSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            return 2
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            return 3
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == diaryCardSelectView.longOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonSelectQuestionCell.identifier, for: indexPath) as? NonSelectQuestionCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else if collectionView == diaryCardSelectView.shortOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonSelectQuestionCell.identifier, for: indexPath) as? NonSelectQuestionCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else if collectionView == diaryCardSelectView.selectOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectQuestionCell.identifier, for: indexPath) as? SelectQuestionCell else {
                return UICollectionViewCell()
            }
            
            cell.optionTableView.dataSource = self
            
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

extension DiaryCardSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectQuestionOptionCell.identifier, for: indexPath) as? SelectQuestionOptionCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        return cell
    }
}
