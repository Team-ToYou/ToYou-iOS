//
//  EmotionTableViewCell.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

class EmotionTableViewCell: UITableViewCell {
    static let identifier = "EmotionTableViewCell"
    
    // MARK: - layout
    public let stampImage = UIImageView()
    
    public let emotionLabel = UILabel().then {
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 20)
        $0.textAlignment = .center
    }

    // MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - function
    private func setView() {
        self.addSubview(stampImage)
        self.addSubview(emotionLabel)
        
        stampImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(42.5)
            $0.height.equalTo(47)
        }
        
        emotionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stampImage.snp.bottom).offset(6.7)
            $0.height.equalTo(23)
        }
    }

}
