//
//  DiaryCardSelectViewController.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class DiaryCardSelectViewController: UIViewController {
    let diaryCardSelectView = DiaryCardSelectView()

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
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
