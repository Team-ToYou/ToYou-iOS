//
//  EmotionViewController.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

class EmotionViewController: UIViewController {
    let emotionView = EmotionView()
    let homeVC = HomeViewController()
    
//    var selectedEmotion: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emotionView
        
        emotionView.emotionTableView.dataSource = self
        emotionView.emotionTableView.delegate = self
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        emotionView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        emotionView.emotionPaperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewTapped)))
        emotionView.emotionPaperView.isUserInteractionEnabled = true
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func backViewTapped() {
//        homeVC.emotion = selectedEmotion!
        self.navigationController?.popViewController(animated: true)
    }

}

extension EmotionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmotionTableViewCell.identifier, for: indexPath) as? EmotionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        let item = EmotionStamp.dummy()[indexPath.row]
        cell.stampImage.image = item.image
        cell.emotionLabel.text = item.label
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emotionView.emotionPaperView.isHidden = false
        
        let item = EmotionStamp.dummy()[indexPath.row]
//        selectedEmotion = item.emotion
        emotionView.emotionView.backgroundColor = item.color
        emotionView.emotionView.isHidden = false
        emotionView.emotionLabel.text = item.result
        emotionView.emotionLabel.isHidden = false
    }
}
