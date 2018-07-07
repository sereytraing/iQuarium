//
//  DetailFishVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class DetailFishVC: DefaultVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var aquariumLabel: UILabel!
    
    var fish: Fish?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
    }

    func bindData() {
        if let fish = fish {
            self.nameLabel.text = fish.name
            self.specieLabel.text = "\(String(describing: fish.species?.commonNames?.first!))"
            self.heightLabel.text = "\(String(describing: fish.height)) cm"
            self.aquariumLabel.text = "\(String(describing: fish.aquarium?.name))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showDetailAquarium(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DetailAquarium", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailAquariumVC") as? DetailAquariumVC {
            controller.aquarium = self.fish?.aquarium
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
