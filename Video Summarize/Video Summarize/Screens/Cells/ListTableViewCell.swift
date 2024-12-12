//
//  ListTableViewCell.swift
//  Video Summarize
//
//  Created by Ahmet Muhammet VURAL on 26.11.2024.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var videoProcess: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshCell(title: String, isLoading: Bool) {
        videoTitle.text = title
        let process = isLoading ? Text.processing : ""
        videoProcess.text = process
    }
    
}
