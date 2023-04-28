//
//  ViewController.swift
//  Hung-Villa_FinalProject
//
//  Created by student on 4/19/23.
//

import UIKit

class MyFavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource, DogDetailsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var delegate: FavoritesDelegate?
    private var dogs = [String: Dog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.onFavoritesResult(favs: dogs)
        super.viewWillDisappear(animated)
    }
    
    func setData(_ dogs: [String: Dog]) {
        self.dogs = dogs
    }
    
    func setDelegate(_ delegate: FavoritesDelegate) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = Array(dogs.values)[indexPath.row]

        cell.textLabel?.text = "\(item.name)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dog = Array(dogs.values)[indexPath.row]
        goToDogDetails(dog: dog, indexPath: indexPath)
    }
    
    func goToDogDetails(dog: Dog, indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "DogDetailsController", bundle: nil)
        guard let destVC = storyboard.instantiateViewController(withIdentifier: "dog_details") as? DogDetailsController else { return }
        
        destVC.setData(dog: dog, isFavorite: true, indexPath: indexPath)
        destVC.setDelegate(self)
        present(destVC, animated: true)
    }
    
    func onDogDetailsResult(id: String, isFavorite: Bool, indexPath: IndexPath) {
        if !isFavorite {
            dogs.removeValue(forKey: id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
