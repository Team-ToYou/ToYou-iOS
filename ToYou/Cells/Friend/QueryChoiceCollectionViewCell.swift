//
//  QueryChoiceCollectionViewCell.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

protocol QueryChoiceCollectionViewCellDelegate: AnyObject {
    func deleteChoice()
    func editTextField()
}

class QueryChoiceCollectionViewCell: UICollectionViewCell {
    
    var text: String?
    var index: Int?
    static let identifier = "QueryChoiceCollectionViewCell"
    private weak var delegate: QueryChoiceCollectionViewCellDelegate?
    
    public lazy var textField = UITextField().then {
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.textColor = .black04
        $0.backgroundColor = .white
    }
    
    public lazy var deleteButton = UIButton().then {
        $0.setImage(.x, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.31
        addComponents()
        addAction()
    }
    
    private func addComponents() {
        self.addSubview(deleteButton)
        self.addSubview(textField)
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(25)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalTo(deleteButton.snp.leading).inset(8)
        }
    }
    
    public func configure(index: Int, text: String, delegate: QueryChoiceCollectionViewCellDelegate) {
        self.delegate = delegate
        self.textField.text = text
        self.index = index
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QueryChoiceCollectionViewCell {
    
    private func addAction() {
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        textField.addTarget(self, action: #selector(editTextField), for: .editingChanged)
    }
    
    @objc
    private func deleteButtonPressed() {
        QueryAPIService.removeQueryOption(at: self.index!)
        delegate?.deleteChoice()
    }
    
    @objc
    private func editTextField() {
        QueryAPIService.updateQueryOptionList(at: index!, to: textField.text!)
        delegate?.editTextField()
    }
    
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
