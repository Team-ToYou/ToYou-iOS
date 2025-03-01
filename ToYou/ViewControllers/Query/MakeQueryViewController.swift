//
//  MakeQueryViewController.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class MakeQueryViewController: UIViewController {
    
    private let makeQueryView = MakeQueryView()
    private let sendQueryVC = SendQueryViewController()
    private var setQueryType: QueryType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = makeQueryView
        self.makeQueryView.choicesCollection.delegate = self
        self.makeQueryView.choicesCollection.dataSource = self
        self.makeQueryView.textView.delegate = self
        setButtonAction()
        setQueryChoiceButtonActions()
        hideKeyboardWhenTappedAround()
    }
    
    private func setButtonAction() {
        makeQueryView.popUpViewButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        makeQueryView.confirmButton.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
    }
    
    @objc
    private func goToNextVC() {
        sendQueryVC.modalPresentationStyle = .overFullScreen
        present(sendQueryVC, animated: false)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: false, completion: nil)
    }
    
    public func configure(by friend: FriendInfo?) {
        makeQueryView.configure(as: friend?.emotion)
    }
    
    public func setQueryType(as type: QueryType) {
        makeQueryView.setQueryType(queryType: type)
        self.setQueryType = type
    }
    
}

extension MakeQueryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setQueryChoiceButtonActions() {
        makeQueryView.addQueryChoiceButton.addTarget(self, action: #selector(addQuery), for: .touchUpInside)
    }
    
    @objc
    private func addQuery() {
        let count = QueryChoiceModel.shared.count
        if  count < 3 {
            QueryChoiceModel.shared.append("")
            makeQueryView.choicesCollection.reloadData()
            updateCollectionViewHeight()
            isAllFilled()
            if count == 2 {
                makeQueryView.addQueryChoiceButton.isHidden = true
            }
        }
    }
    
    private func updateCollectionViewHeight() {
        let count = QueryChoiceModel.shared.count
        makeQueryView.choicesCollection.snp.updateConstraints { make in
            let newHeight = count * 36 + (count - 1) * 10
            make.height.equalTo(newHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QueryChoiceModel.shared.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = QueryChoiceModel.shared[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QueryChoiceCollectionViewCell.identifier,
            for: indexPath) as! QueryChoiceCollectionViewCell
        cell.configure(index: indexPath.row , text: data, delegate: self)
        return cell
    }
    
}

extension MakeQueryViewController: QueryChoiceCollectionViewCellDelegate {
    
    func deleteChoice() {
        updateCollectionViewHeight()
        makeQueryView.choicesCollection.reloadData()
        makeQueryView.addQueryChoiceButton.isHidden = false
        isAllFilled()
    }
    
    func editTextField() {
        isAllFilled()
    }
    
    func isAllFilled() {
        if makeQueryView.textView.text.count > 0 &&
            makeQueryView.textView.text.count < 51 {
            for text in QueryChoiceModel.shared {
                if text == "" {
                    makeQueryView.confirmButton.unavailable()
                    return
                }
            }
            makeQueryView.confirmButton.available()
        } else {
            makeQueryView.confirmButton.unavailable()
        }
    }
    
}

extension MakeQueryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let count = text.count
            makeQueryView.textCount.text = "\(count)/50"
            isAllFilled()
        }
    }
    
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
