//
//  TutorialCell.swift
//  ToYou
//
//  Created by 이승준 on 3/9/25.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
    static let identifier = "TutorialCell"
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func configure(image: UIImage) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
