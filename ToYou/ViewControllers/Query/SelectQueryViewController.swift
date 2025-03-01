//
//  SendQueryViewController.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class SelectQueryViewController: UIViewController {
    
    private let selectQueryTypeView = SelectQueryTypeView()
    private let makeQueryVC = MakeQueryViewController()
    private var friendInfo: FriendInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = selectQueryTypeView
        setButtonAction()
    }
    
    private func setButtonAction() {
        selectQueryTypeView.selectionQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        selectQueryTypeView.shortQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        selectQueryTypeView.longQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        selectQueryTypeView.confirmButton.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
        selectQueryTypeView.popUpViewButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    @objc
    private func selectQueryType(_ sender: QueryTypeButton) {
        let buttons = [selectQueryTypeView.selectionQueryTypeButton,
                       selectQueryTypeView.shortQueryTypeButton,
                       selectQueryTypeView.longQueryTypeButton]
        for button in buttons {
            if sender == button {
                button.selected()
            } else {
                button.unselected()
            }
        }
        makeQueryVC.setQueryType(as: sender.queryType!)
        selectQueryTypeView.confirmButton.available()
    }
    
    @objc
    private func goToNextVC() {
        makeQueryVC.modalPresentationStyle = .overFullScreen
        present(makeQueryVC, animated: false)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: true, completion: nil)
    }
    
    public func configure(by friend: FriendInfo?) {
        selectQueryTypeView.configure(as: friend?.emotion)
        makeQueryVC.configure(by: friend)
    }
}

import SwiftUI
#Preview{
    SelectQueryViewController()
}
