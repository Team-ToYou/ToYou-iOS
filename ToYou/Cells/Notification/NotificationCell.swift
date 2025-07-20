//
//  NotificationCell.swift
//  ToYou
//
//  Created by 이승준 on 5/30/25.
//

import UIKit
import SnapKit

class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"
    public var data: NotificationData?
    private var titleTrailingConstraint: Constraint?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 12)
        $0.textColor = .black
    }
    
    private lazy var detailImage = UIImageView().then {
        $0.image = .goDetail
        $0.contentMode = .scaleAspectFit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5.5, left: 0, bottom: 5.5, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .yellow01
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ data: NotificationData) {
        self.contentView.addSubview(titleLabel)
        self.backgroundColor = .clear
        if data.alarmType == .NEW_QUESTION {
            setNewQuestionConstraints()
        } else {
            setFriendAcceptConstraints()
        }
        
        self.data = data
        
        guard let _ = data.nickname, let content = data.content else {
            titleLabel.text = "알림 내용을 불러오는 데에 실패했습니다."
            return
        }
        
        titleLabel.text = content
        // shortenUserNameInContent(userName: userNmae, content: content)
    }
    
    func setNewQuestionConstraints() {
        self.contentView.addSubview(titleLabel)
        setupViews()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        self.contentView.addSubview(detailImage)
        detailImage.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.height.width.equalTo(25)
        }
    }
    
    func setFriendAcceptConstraints() {
        self.contentView.addSubview(titleLabel)
        detailImage.removeFromSuperview()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
            make.trailing.equalToSuperview().offset(-17)
        }
    }
    
    private func setupViews() {
        if titleLabel.superview == nil {
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(17)
                titleTrailingConstraint = make.trailing.equalToSuperview().offset(-17).constraint
            }
        }
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 서브뷰와 제약조건 초기화
        detailImage.removeFromSuperview()
        titleLabel.text = nil
        
        // 제약조건 초기화
        titleLabel.snp.removeConstraints()
        detailImage.snp.removeConstraints()
    }
    
    func shortenUserNameInContent( userName: String, content: String) -> String {
        let userNameLength = userName.count
        if userNameLength > 3 {
            let shortenUserName = String(Array(userName)[0...2]) + "..."
            return content.replacingOccurrences(of: userName, with: shortenUserName)
        } else {
            return content
        }
    }
    
}


import SwiftUI
#Preview {
    NotificationViewController()
}
