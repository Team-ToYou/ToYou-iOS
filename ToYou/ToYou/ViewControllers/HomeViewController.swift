//
//  HomeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeVeiw = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeVeiw
    }
    
}

import SwiftUI
#Preview(body: {
    HomeViewController()
})
