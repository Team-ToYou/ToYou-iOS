//
//  SendQueryViewController.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class QueryTypeViewController: UIViewController {
    
    private let queryTypeView = QueryTypeView()
    private let makeQueryVC = MakeQueryViewController()
    private var friendInfo: FriendInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = queryTypeView
        setButtonAction()
    }
    
    private func setButtonAction() {
        queryTypeView.selectionQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        queryTypeView.shortQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        queryTypeView.longQueryTypeButton.addTarget(self, action: #selector(selectQueryType(_ :)), for: .touchUpInside)
        queryTypeView.confirmButton.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
        queryTypeView.popUpViewButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
    }
    
    @objc
    private func selectQueryType(_ sender: QueryTypeButton) {
        let buttons = [queryTypeView.selectionQueryTypeButton,
                       queryTypeView.shortQueryTypeButton,
                       queryTypeView.longQueryTypeButton]
        for button in buttons {
            if sender == button {
                button.selected()
            } else {
                button.unselected()
            }
        }
        makeQueryVC.setQueryType(as: sender.queryType!)
        queryTypeView.confirmButton.available()
    }
    
    @objc
    private func goToNextVC() {
        let buttons = [queryTypeView.selectionQueryTypeButton,
                       queryTypeView.shortQueryTypeButton,
                       queryTypeView.longQueryTypeButton]
        for button in buttons {
            if button.isSelected() {
                makeQueryVC.setQueryType(as: button.queryType!)
                QueryAPIService.setQuestionType(button.queryType!)
            }
        }
        makeQueryVC.modalPresentationStyle = .overFullScreen
        present(makeQueryVC, animated: false)
    }
    
    @objc
    private func popVC() {
        dismiss(animated: true, completion: nil)
    }
    
    public func configure(by friend: FriendInfo?) {
        queryTypeView.configure(as: friend?.emotion)
        makeQueryVC.configure(by: friend)
    }
}

import SwiftUI
#Preview{
    QueryTypeViewController()
}
