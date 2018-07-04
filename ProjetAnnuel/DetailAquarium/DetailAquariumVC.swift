//
//  DetailAquariumVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class DetailAquariumVC: DefaultVC {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var isDirtyLabel: UILabel!
    
    
    
    var aquarium: Aquarium?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindData() {
        if let aquarium = aquarium {
            self.idLabel.text = aquarium.id
            self.nameLabel.text = aquarium.name
            self.temperatureLabel.text = "\(String(describing: aquarium.temperature))"
            self.volumeLabel.text = "\(String(describing: aquarium.volume))"
            self.isDirtyLabel.text = "\(String(describing: aquarium.isDirty))"
        }
    }
}
