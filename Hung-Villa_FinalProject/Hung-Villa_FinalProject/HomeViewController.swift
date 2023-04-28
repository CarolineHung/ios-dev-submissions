//
//  ViewController.swift
//  Hung-Villa_FinalProject
//
//  Created by student on 4/19/23.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DogDetailsDelegate, FavoritesDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favBtn: UIButton!

    private var dogs = [String: Dog]()
    private var favs = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favs = UserDefaults.standard.dictionary(forKey: AppDelegate.FAVORITES_KEY) as? [String:String] ?? [String: String]()
        
        tableView.delegate = self
        tableView.dataSource = self

        makeAPICall { searchResponse in
            self.dogs = searchResponse
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        favBtn.addTarget(self, action: #selector(onFavClick), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(favs, forKey: AppDelegate.FAVORITES_KEY)
        super.viewWillDisappear(animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let key = Array(dogs.keys)[indexPath.row]
        let item = Array(dogs.values)[indexPath.row]
        
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: favs[key] == nil ? "star" : "star.fill"), for: .normal)
        btn.tag = Int(key) ?? 0
        btn.addTarget(self, action: #selector(onFavRowClick(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(btn)
        cell.textLabel?.text = "\(item.name)"
        cell.textLabel?.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            btn.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            btn.widthAnchor.constraint(equalToConstant: 80),
            btn.heightAnchor.constraint(equalToConstant: 30)
        ])

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

        destVC.setData(dog: dog, isFavorite: favs[dog.id] == "1", indexPath: indexPath)
        destVC.setDelegate(self)
        present(destVC, animated: true)
    }
    
    func onDogDetailsResult(id: String, isFavorite: Bool, indexPath: IndexPath) {
        if !isFavorite {
            favs.removeValue(forKey: id)
        } else {
            favs[id] = "1"
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func onFavoritesResult(favs: [String : Dog]) {
        self.favs = favs.mapValues { _ in "1" }
        tableView.reloadData()
    }

    func makeAPICall(completion: @escaping ([String: Dog]) -> Void) {
        let domain = "https://api.thedogapi.com/v1/"
        let searchQuery = "breeds?limit=10&page=0"
        
        guard let url = URL(string:"\(domain)\(searchQuery)") else {
            completion([:])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var searchResponse = [String: Dog]()
            defer {completion(searchResponse)}
            
            if let error = error {
                print("Error with API call: \(error)")
                return
            }

            // 200 means that it's connected
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response (\(String(describing: response))")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode([Dog].self, from: data)
                    searchResponse = response.reduce(into: [String: Dog]()) { result, dog in
                        result[dog.id] = dog
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    @objc func onFavClick() {
        let storyboard = UIStoryboard(name: "MyFavoritesController", bundle: nil)
        guard let destVC = storyboard.instantiateViewController(withIdentifier: "favorites") as? MyFavoritesController else { return }
        
        var filtered = [String: Dog]()
        
        for id in favs.keys {
            if let d = dogs[id] {
                filtered[id] = d
            }
        }
        
        destVC.setData(filtered)
        destVC.setDelegate(self)
        present(destVC, animated: true)
    }
    
    @objc func onFavRowClick(_ sender: UIButton) {
        let key = String(sender.tag)
        
        if favs[key] == nil {
            favs[key] = "1"
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            return
        }
        
        favs.removeValue(forKey: key)
        sender.setImage(UIImage(systemName: "star"), for: .normal)
    }
}

protocol DogDetailsDelegate {
    func onDogDetailsResult(id: String, isFavorite: Bool, indexPath: IndexPath)
}

protocol FavoritesDelegate {
    func onFavoritesResult(favs: [String: Dog])
}
