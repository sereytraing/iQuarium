//
//  FishCollectionCell.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 10/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class FishCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
    }
    
    func bindData(name: String, imageUrl: String? = nil) {
        self.nameLabel.text = name
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            let data = try? Data(contentsOf: url)
            self.imageView.image = UIImage(data: data!)
        } else {
            self.imageView.image = UIImage(named: "fish_1")
        }
    }

}
