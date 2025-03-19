import UIKit

class SelectQuestionOptionCell: UITableViewCell {
    static let identifier = "SelectQuestionOptionCell"

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backView.layer.borderColor = UIColor.black.cgColor
            backView.layer.borderWidth = 1.0
        } else {
            backView.layer.borderColor = UIColor.clear.cgColor
            backView.layer.borderWidth = 0
        }
    }
    
    // MARK: - layout
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5.3
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 0
    }
    
    private let optionLabel = UILabel().then {
        $0.text = "옵션 예시"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 11)
    }
    
    // MARK: - function
    private func setView() {
        [ backView, optionLabel ].forEach { addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8.5)
            $0.height.equalTo(25.6)
        }
        
        optionLabel.snp.makeConstraints {
            $0.centerY.equalTo(backView)
            $0.left.equalToSuperview().offset(7.7)
        }
    }
}
