//
//  SimpleCell.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 04/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class SimpleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.accessoryType = .none
    }
    
    func bindData(title: String?) {
        titleLabel.text = title        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /*if self.accessoryType == .checkmark {
            self.accessoryType = .none
        } else {
            self.accessoryType = .checkmark
        }*/
    }
}
