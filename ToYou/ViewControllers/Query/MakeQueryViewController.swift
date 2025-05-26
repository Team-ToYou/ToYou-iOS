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
    private var queryType: QueryType?
    private let vc = MaxLengthWarningPopUpVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = makeQueryView
        self.makeQueryView.choicesCollection.delegate = self
        self.makeQueryView.choicesCollection.dataSource = self
        self.makeQueryView.textView.delegate = self
        setButtonAction()
        setQueryChoiceButtonActions()
        hideKeyboardWhenTappedAround()
        if QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0 == 3 {
            makeQueryView.addQueryChoiceButton.isHidden = true
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
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
        switch type {
        case .OPTIONAL:
            makeQueryView.selectionMode()
        case .SHORT_ANSWER:
            makeQueryView.shortQueryMode()
        case .LONG_ANSWER:
            makeQueryView.longQueryMode()
        }
        self.queryType = type
    }
    
}

extension MakeQueryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setQueryChoiceButtonActions() {
        makeQueryView.addQueryChoiceButton.addTarget(self, action: #selector(addQuery), for: .touchUpInside)
    }
    
    @objc
    private func addQuery() {
        let count = QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0
        if  count < 3 {
            QueryAPIService.addQueryOption("")
            makeQueryView.choicesCollection.reloadData()
            updateCollectionViewHeight()
            isAllFilled()
            if count == 2 {
                makeQueryView.addQueryChoiceButton.isHidden = true
            }
        }
    }
    
    private func updateCollectionViewHeight() {
        let count = QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0
        makeQueryView.choicesCollection.snp.updateConstraints { make in
            let newHeight = count * 36 + (count - 1) * 10
            make.height.equalTo(newHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = QueryAPIService.shared.queryParamter.answerOptionList?[indexPath.row] ?? ""
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
        // 컨텐츠 텍스트 길이 검사
        makeQueryView.confirmButton.available()
        if makeQueryView.textView.text.count < 0 ||
            makeQueryView.textView.text.count > makeQueryView.maxLength {
            makeQueryView.confirmButton.unavailable()
            // 경고
            self.present(vc, animated: false)
            // 마지막 문자열 제거
            makeQueryView.textView.text.removeLast()
            makeQueryView.textCount.text = "\(makeQueryView.textView.text.count)/\(makeQueryView.maxLength)"
            // 마지막 문자열을 제거하여 유효한 텍스트 길이를 유지
            return
        }
        
        if self.queryType == .OPTIONAL {
            isAllQuestionFilled()
        }
    }
    
    func isAllQuestionFilled() {
        // 질문 개수 검사
        if QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0 > 3 ||
            QueryAPIService.shared.queryParamter.answerOptionList?.count ?? 0 < 2 {
            makeQueryView.confirmButton.unavailable()
            return
        }
        
        // 각 질문의 문자 길이 검사
        for (index, text) in QueryAPIService.shared.queryParamter.answerOptionList!.enumerated() {
            if text.count > 31 {
                // 경고
                self.present(vc, animated: false)
                //마지막 문자열 제거
                QueryAPIService.shared.queryParamter.answerOptionList![index].removeLast()
                return
            }
            
            if text.count == 0 {
                makeQueryView.confirmButton.unavailable()
                return
            }
        }
    }
    
}

extension MakeQueryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let count = text.count
            makeQueryView.textCount.text = "\(count)/\(makeQueryView.maxLength)"
            QueryApiService.shared.queryParamter.content = text
            isAllFilled()
        }
    }
    
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
