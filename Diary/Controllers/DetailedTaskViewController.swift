//
//  DetailedTaskViewController.swift
//  Diary
//
//  Created by Артём Амаев on 05.12.2024.
//

import UIKit

class DetailedTaskViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var task: Task?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
    private func setupUI() {
        guard let task = task else { return }
        
        titleLabel.text = task.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(task.dateStart))
        let endDate = Date(timeIntervalSince1970: TimeInterval(task.dateFinish))
        
        dateLabel.text = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        
        navigationController?.navigationBar.topItem?.backBarButtonItem?.title = "Back"
        descriptionLabel.text = task.descriptionText
    }
    
}
