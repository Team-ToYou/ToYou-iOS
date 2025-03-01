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
        self.makeQueryView.textView.delegate = self
        setButtonAction()
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

extension MakeQueryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let count = text.count
            makeQueryView.textCount.text = "\(count)/50"
            if count > 51 {
                makeQueryView.confirmButton.unavailable()
            } else {
                makeQueryView.confirmButton.available()
            }
        }
    }
    
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
