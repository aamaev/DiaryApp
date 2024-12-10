//
//  TimeCell.swift
//  Diary
//
//  Created by Артём Амаев on 06.12.2024.
//

import UIKit

class TimeCell: UITableViewCell {
    @IBOutlet weak var timeRangeLabel: UILabel!
    
    func configure(with timeRange: String) {
        timeRangeLabel.text = timeRange.description
    }
}
