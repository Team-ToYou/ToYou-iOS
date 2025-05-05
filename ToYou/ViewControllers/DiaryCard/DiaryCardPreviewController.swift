//
//  DiaryCardPreviewController.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit

class DiaryCardPreviewController: UIViewController {
    let diaryCardPreview = DiaryCardPreview()
    
    var questionsAndAnswers: [DiaryCardAnswerModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardPreview
        setAction()
        setDelegate()
    }
    
    // MARK: - action
    private func setDelegate() {
        diaryCardPreview.previewCard.answerTableView.dataSource = self
    }
    
    private func setAction() {
        diaryCardPreview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiaryCardPreviewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsAndAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryCardAnswerCell.identifier, for: indexPath) as? DiaryCardAnswerCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        let item = questionsAndAnswers[indexPath.row]
        cell.configure(question: item.question, answers: item.answers, selectedIndex: item.selectedIndex)

        return cell
    }
}
