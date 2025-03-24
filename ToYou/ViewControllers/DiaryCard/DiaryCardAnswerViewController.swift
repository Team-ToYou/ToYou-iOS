//
//  DiaryCardAnswerViewController.swift
//  ToYou
//
//  Created by 김미주 on 18/03/2025.
//

import UIKit

class DiaryCardAnswerViewController: UIViewController {
    let diaryCardAnswerView = DiaryCardAnswerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardAnswerView
        
        diaryCardAnswerView.longOptionCollectionView.dataSource = self
        diaryCardAnswerView.longOptionCollectionView.delegate = self
        diaryCardAnswerView.shortOptionCollectionView.dataSource = self
        diaryCardAnswerView.shortOptionCollectionView.delegate = self
        diaryCardAnswerView.selectOptionCollectionView.dataSource = self
        diaryCardAnswerView.selectOptionCollectionView.delegate = self
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardAnswerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - extension
extension DiaryCardAnswerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == diaryCardAnswerView.longOptionCollectionView {
            return 2
        } else if collectionView == diaryCardAnswerView.shortOptionCollectionView {
            return 3
        } else if collectionView == diaryCardAnswerView.selectOptionCollectionView {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == diaryCardAnswerView.longOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongAnswerCell.identifier, for: indexPath) as? LongAnswerCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else if collectionView == diaryCardAnswerView.shortOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortAnswerCell.identifier, for: indexPath) as? ShortAnswerCell else {
                return UICollectionViewCell()
            }
            
            return cell
        } else if collectionView == diaryCardAnswerView.selectOptionCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAnswerCell.identifier, for: indexPath) as? SelectAnswerCell else {
                return UICollectionViewCell()
            }
            
            cell.optionTableView.dataSource = self
            
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

extension DiaryCardAnswerViewController: UITableViewDataSource {
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
