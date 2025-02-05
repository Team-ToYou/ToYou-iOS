//
//  LetterComposeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class LetterComposeViewController: UIViewController {
    
    let letterCompose = LetterComposeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = letterCompose
    }
    
}
