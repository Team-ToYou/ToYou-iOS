//
//  ProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = profileView
    }
    
}

