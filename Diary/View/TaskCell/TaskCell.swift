//
//  TaskCell.swift
//  Diary
//
//  Created by Артём Амаев on 06.12.2024.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    func configure(with task: Task) {
        let startDate = Date(timeIntervalSince1970: TimeInterval(task.dateStart))
        let endDate = Date(timeIntervalSince1970: TimeInterval(task.dateFinish))

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let startTime = timeFormatter.string(from: startDate)
        let endTime = timeFormatter.string(from: endDate)

        self.taskNameLabel.text = task.name
        self.timeRangeLabel.text = "\(startTime) - \(endTime)"
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        stackView.backgroundColor = UIColor(named: "lightGray1")
        stackView.layer.cornerRadius = 20
    }
}
