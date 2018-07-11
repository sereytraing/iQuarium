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
    @IBOutlet weak var aquariumLabel: UILabel!
    
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(title: String, nameAquarium: String? = nil) {
        titleLabel.text = title
        if nameAquarium != nil {
            aquariumLabel.text = nameAquarium
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
