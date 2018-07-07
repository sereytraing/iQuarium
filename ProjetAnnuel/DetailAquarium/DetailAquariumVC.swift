//
//  DetailAquariumVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class DetailAquariumVC: DefaultVC {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var isDirtyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var aquarium: Aquarium?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bindData() {
        if let aquarium = aquarium {
            self.nameLabel.text = aquarium.name
            self.temperatureLabel.text = "\(String(describing: aquarium.temperature))"
            self.volumeLabel.text = "\(String(describing: aquarium.volume))"
            self.isDirtyLabel.text = "\(String(describing: aquarium.isDirty))"
        }
    }
}

extension DetailAquariumVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fishes = self.aquarium?.fishes{
            return fishes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aquariumCell", for: indexPath) as! AquariumListCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        
        if let fishes = self.aquarium?.fishes {
            cell.bindData(title: fishes[indexPath.row].name) //Peut ajouter imageurl
        } else {
            cell.bindData(title: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailFish", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailFishVC") as? DetailFishVC {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
