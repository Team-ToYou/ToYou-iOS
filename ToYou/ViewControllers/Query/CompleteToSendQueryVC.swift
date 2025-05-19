//
//  CompleteToSendVC.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class CompleteToSendQueryVC: UIViewController {
    
    private let backgroundImage = UIImageView().then {
        $0.image = .paperTexture
    }
    
    private let mailImage = UIImageView().then {
        $0.image = .mail
        $0.contentMode = .scaleAspectFit
    }
    
    private let completionLabel = UILabel().then {
        $0.text = "질문을 보냈습니다"
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 30)
        $0.textColor = .black04
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    private func setConstraints() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(backgroundImage)
        self.view.addSubview(mailImage)
        self.view.addSubview(completionLabel)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mailImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(100)
        }
        
        completionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mailImage.snp.bottom).offset(30)
        }
    }
    
    
}

import SwiftUI
#Preview {
    CompleteToSendQueryVC()
}
