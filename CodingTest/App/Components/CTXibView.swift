//
//  CTXibView.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import UIKit

class CTXibView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentView()
        self.adjustUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setContentView()
        self.adjustUI()
    }
    
    func setContentView() {
        Bundle.main.loadNibNamed(self.setXibName() ?? self.nameOfClass(), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setXibName() -> String? {
        return nil
    }
    
    func adjustUI() {
        
    }
    
}

extension NSObject{
    public static var nameOfClass: String {
        return String(describing: self)
    }
    
    func nameOfClass() -> String {
        return "\(type(of: self))"
    }
}

