//
//  AquariumCell.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 10/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class AquariumCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(title: String?, imageURL: String? = nil) {
        nameLabel.text = title
        /*if imageURL != nil {
            let url = URL(string: imageURL!)
            let data = try? Data(contentsOf: url!)
            myImageView.image = UIImage(data: data!)
        }*/
        if let imageUrl = imageURL, let url = URL(string: imageUrl) {
            let data = try? Data(contentsOf: url)
            self.myImageView.image = UIImage(data: data!)
        } else {
            self.myImageView.image = UIImage(named: "aquarium_1")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}
