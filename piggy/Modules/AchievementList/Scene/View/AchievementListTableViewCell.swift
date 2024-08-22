//
//  NoteListTableViewCell.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Kevin Abram on 26/07/24.
//

import UIKit

protocol AchievementListTableViewCellDelegate: AnyObject {
    func didTapRewardButton(at indexPath: IndexPath?)
}
class AchievementListTableViewCell: UITableViewCell {
    
    weak var delegate: AchievementListTableViewCellDelegate?
    private var indexPath: IndexPath?
    private var originalText: String = ""

    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var achievementListLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func setText(text: String, indexPath: IndexPath, delegate: AchievementListTableViewCellDelegate?) {
        originalText = text
        achievementListLabel.text = text
        
        self.indexPath = indexPath
        self.delegate = delegate
        setCellSelected(selected: isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setCellSelected(selected: selected)
    }
    
    func setCellSelected(selected: Bool) {
        if selected {
            // Change rewardButton background image when selected
            rewardButton.setImage(UIImage(named: "GiftOpened"), for: .normal)
            checkImageView.image = UIImage(named: "CheckboxFilled")
        } else {
            // Reset rewardButton background image when deselected
            rewardButton.setImage(UIImage(named: "Gift"), for: .normal)
            checkImageView.image = UIImage(named: "Checkbox")
        }
        
        rewardButton.imageView?.contentMode = .scaleAspectFit
//        rewardButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            rewardButton.imageView!.widthAnchor.constraint(equalTo: rewardButton.widthAnchor, multiplier: 1),
//            rewardButton.imageView!.heightAnchor.constraint(equalTo: rewardButton.heightAnchor, multiplier: 1)
//        ])
    }
    
    @IBAction func didTapRewardButton(_ sender: Any) {
        delegate?.didTapRewardButton(at: indexPath)
    }
}
