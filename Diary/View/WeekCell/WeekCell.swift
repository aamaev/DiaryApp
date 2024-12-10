    //
//  WeekCell.swift
//  Diary
//
//  Created by Артём Амаев on 05.12.2024.
//

import UIKit

class WeekCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var isSelectedCell: Bool = false

    func configure(dayName: String, dayNumber: String, isSelected: Bool) {
        dayLabel.text = dayName
        dateLabel.text = dayNumber
        self.layer.cornerRadius = 20
        
        isSelectedCell = isSelected
        updateSelectionAppearance()
    }
    
    func animateSelection(selected: Bool) {
        isSelectedCell = selected
        
        UIView.animate(withDuration: 0.2) {
            self.updateSelectionAppearance()
        }
    }

    private func updateSelectionAppearance() {
        self.transform = isSelectedCell ? CGAffineTransform(scaleX: 1.01, y: 1.01) : .identity
        self.layer.backgroundColor = isSelectedCell ? UIColor.lightBlue.cgColor : UIColor.lightGray1.cgColor
        self.dayLabel.textColor = isSelectedCell ? UIColor.white : UIColor.lightGray
        self.dateLabel.textColor = isSelectedCell ? UIColor.white : UIColor.lightGray
    }
}



