//
//  MainHeaderTableViewCell.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 2.12.2024.
//

import UIKit

class MainHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var summarCountLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var summarTitle: UILabel! {
        didSet {
            summarTitle.text = Text.summaryTitle
        }
    }
    @IBOutlet weak var wordTitle: UILabel! {
        didSet {
            wordTitle.text = Text.wordTitle
        }
    }
    @IBOutlet weak var timeTitle: UILabel! {
        didSet {
            timeTitle.text = Text.timeTitle
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func refreshCell(summarCount: Int, wordCount: Int, timeCount: Int) {
        summarCountLabel.text = "\(summarCount)"
        wordCountLabel.text = "\(wordCount)"
        timeCountLabel.text = "\(timeCount) \(Text.min)"
    }
}
