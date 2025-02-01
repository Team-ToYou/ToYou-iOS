//
//  ViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import SnapKit
import Then

class FontcheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.conigure()
        self.checkFontName()
        self.view.backgroundColor = .systemBackground
    }
    
    let scdLabel01: UILabel = {
        let label = UILabel()
        label.text = "S-CoreDream-2ExtraLight 11"
        label.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
        return label
    }()
    
    let scdLabel02: UILabel = {
        let label = UILabel()
        label.text = "S-CoreDream-3Light 11"
        label.font = UIFont(name: "S-CoreDream-3Light", size: 10)
        return label
    }()
    
    let scdLabel03: UILabel = {
        let label = UILabel()
        label.text = "S-CoreDream-2ExtraLight 11"
        label.font = UIFont(name: "S-CoreDream-3Light", size: 12)
        return label
    }()
    
    let kangLabel01: UILabel = {
        let label = UILabel()
        label.text = "GangwonEduHyeonokT_OTFMedium 24"
        
        label.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 24)
        return label
    }()
    
    func conigure() {
        self.view.addSubview(scdLabel01)
        self.view.addSubview(scdLabel02)
        self.view.addSubview(scdLabel03)
        self.view.addSubview(kangLabel01)
        
        scdLabel01.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        scdLabel02.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scdLabel01.snp.bottom).offset(10)
        }
        
        scdLabel03.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scdLabel02.snp.bottom).offset(10)
        }
        
        kangLabel01.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scdLabel03.snp.bottom).offset(10)
        }
        
    }
    
    func checkFontName() {
            UIFont.familyNames.sorted().forEach { familyName in
                print("*** \(familyName) ***")
                UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                    print("\(fontName)")
                }
          print("---------------------")
            }
    }
}
