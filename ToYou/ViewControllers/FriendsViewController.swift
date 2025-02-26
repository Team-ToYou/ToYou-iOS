//
//  LetterComposeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class FriendsViewController: UIViewController {
    
    let friendsView = FriendsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = friendsView
    }
    
}
