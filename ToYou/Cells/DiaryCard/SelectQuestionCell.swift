//
//  SelectQuestionCell.swift
//  ToYou
//
//  Created by 김미주 on 14/03/2025.
//

import UIKit

class SelectQuestionCell: UICollectionViewCell {
    static let identifier = "SelectQuestionCell"
    public var optionList: [String] = [] {
        didSet {
            optionTableView.reloadData()
        }
    }
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        optionTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    public let checkboxButton = CheckBoxButtonVer02()
    
    private let questionLabel = UILabel().then {
        $0.text = "요즘 어떻게 지내?"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    public let optionTableView = UITableView().then {
        $0.register(SelectQuestionOptionCell.self, forCellReuseIdentifier: SelectQuestionOptionCell.identifier)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    private let fromLabel = UILabel().then {
        $0.text = "From. 미주"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
    }
    
    // MARK: - function
    private func setView() {
        [
            checkboxButton, questionLabel, optionTableView, fromLabel
        ].forEach {
            addSubview($0)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(22.4)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(checkboxButton.snp.bottom).offset(12)
            $0.left.equalToSuperview()
            $0.width.equalTo(172)
        }
        
        optionTableView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(6.3)
            $0.left.equalTo(questionLabel.snp.left).offset(2)
            $0.right.equalToSuperview()
            $0.height.equalTo(94)
        }
        
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(optionTableView.snp.bottom).offset(7.5)
            $0.right.equalToSuperview()
        }
    }
    
    func setQuestion(content: String, options: [String], questioner: String) {
        self.questionLabel.text = content
        self.optionList = options
        self.fromLabel.text = "From. \(questioner)"
    }
}

extension SelectQuestionCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectQuestionOptionCell.identifier, for: indexPath) as? SelectQuestionOptionCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setOptionText(optionList[indexPath.row])
        return cell
    }
}
