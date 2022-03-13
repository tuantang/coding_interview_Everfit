//
//  CTTrainingTableViewCell.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import UIKit

class CTTrainingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var EEELabel: UILabel!
    var date: Date?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    

    func configure(workout: CTWorkout) {
        
        if let date = workout.date {
            self.date = date
            self.EEELabel.text = date.toString(format: "EEE").uppercased()
            self.ddLabel.text = date.toString(format: "dd")
            if date.isCurrentDate() {
                self.EEELabel.textColor = completeColor
                self.ddLabel.textColor = completeColor
            }
        }
        
        guard let assignments = workout.assignments else { return }
        assignments.forEach { self.contentStackView.addArrangedSubview(CTWorkoutInfoView(assignment: $0, date: self.date ?? Date())) }
    }
    
}
