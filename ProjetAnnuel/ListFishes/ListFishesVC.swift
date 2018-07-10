//
//  ListFishesVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ListFishesVC: DefaultVC, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    var fishes = [Fish]()
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vos poissons"
        self.addButton.layer.cornerRadius = 30.0
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "FishCollectionCell", bundle:nil) , forCellWithReuseIdentifier: "fishCollectionCell")
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self

        self.collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestGetAllFishes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func requestGetAllFishes() {
        let url = self.baseUrl + "/fishes/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Fish]>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let fishes = response.result.value {
                        self.fishes = fishes
                        self.collectionView.reloadData()
                    }
                    
                case .failure:
                    if response.response?.statusCode == 204 {
                        self.fishes = []
                        self.collectionView.reloadData()
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Fishes \(String(describing: response.response?.statusCode))")
                    }
                    
                }
            }
        })
    }

    func requestRemoveFish(id: String) {
        let url = self.baseUrl + "/fishes/" + id
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    self.requestGetAllFishes()
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Remove Fish \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func askDeleteFish(index: Int) {
        let alert = UIAlertController(title: "Attention", message: "Voulez-vous supprimer le poisson ?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestRemoveFish(id: self.fishes[index].id!)
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                self.askDeleteFish(index: indexPath.row)
            }
        }
    }
}

extension ListFishesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fishes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "fishCollectionCell", for: indexPath)
        if let fishCell = cell as? FishCollectionCell {
            if let pictures = self.fishes[indexPath.row].species?.pictures, pictures.count > 0 {
                fishCell.bindData(name: self.fishes[indexPath.row].name!, imageUrl: pictures.first)
            } else {
                fishCell.bindData(name: self.fishes[indexPath.row].name!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailFish", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailFishVC") as? DetailFishVC {
            controller.fish = self.fishes[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension ListFishesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.minimumInteritemSpacing
        }
        return CGSize(width: width / 2, height: width / 2)
    }
}
