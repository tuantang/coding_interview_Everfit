//
//  CTWorkoutInfoView.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import UIKit



class CTWorkoutInfoView: CTXibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var completeImageView: UIImageView!
    
    var assignment: CTAssignment!
    var date: Date!
    
    convenience init(assignment: CTAssignment, date: Date) {
        self.init()
        self.assignment = assignment
        self.date = date
        self.configureView()
    }
    
    override func adjustUI() {
        super.adjustUI()
        
        self.contentView.backgroundColor = .clear
        self.layer.cornerRadius = 8
        
        self.addTapGestureRecognizer {
            self.handleTapPressed()
        }
    }
    
    func handleTapPressed() {
        guard let status = assignment.status else { return }
        switch self.date.checkDateState() {
        case .past:
            if status == .in_progress { self.assignment.status = .complete }
            if status == .complete { self.assignment.status = .in_progress }
        case .current:
            if status == .assigned || status == .in_progress { self.assignment.status = .complete }
            if status == .complete { self.assignment.status = .in_progress }
        case .future:
            break
        }
        self.configureView()
    }
    
    func configureView() {
        // set UI default
        self.titleLabel.text = self.assignment.title
        self.titleLabel.textColor = titleColor
        self.stateLabel.text = "\(self.assignment.totalExercise ?? 0) exercise"
        self.stateLabel.textColor = titleColor
        self.completeImageView.isHidden = true
        self.backgroundColor = unCompleteColor
        
        guard let status = assignment.status else { return }
        switch status {
        case .assigned:
            if self.date.checkDateState() == .past {
                self.stateLabel.attributedText = attributedMissStatus()
            }
        case .in_progress:
            break
        case .complete:
            if self.date.checkDateState() != .future {
                self.titleLabel.textColor = .white
                self.stateLabel.textColor = .white
                self.backgroundColor = completeColor
                self.completeImageView.isHidden = false
                self.stateLabel.text = "Complete"
            }
        }
        
        if self.date.checkDateState() == .future {
            self.titleLabel.textColor = titleFutureColor
            self.stateLabel.textColor = titleFutureColor
        }
    }
    
    // set attributed for misssed title
    func attributedMissStatus() -> NSAttributedString {
        let attr = NSMutableAttributedString()
        
        let attrMiss = NSMutableAttributedString(string: "Missed", attributes: [
            NSAttributedString.Key.foregroundColor : titleMissedColor,
            NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 13)!
        ])
        
        let attrExercise = NSMutableAttributedString(string: "  ● \(self.assignment.totalExercise ?? 0) exercise", attributes: [
            NSAttributedString.Key.foregroundColor : titleColor,
            NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 13)!
        ])
        
        attr.append(attrMiss)
        attr.append(attrExercise)
        
        return attr
    }
}
