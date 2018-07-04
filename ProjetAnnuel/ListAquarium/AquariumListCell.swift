//
//  AquariumListCell.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class AquariumListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var view: UIView!
    var title: String?
    var imageURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(title: String?, imageURL: String? = nil) {
        titleLabel.text = title
        if imageURL != nil {
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!)
            coverImageView.image = UIImage(data: data!)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
