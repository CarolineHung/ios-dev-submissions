//
//  TableViewController.swift
//  Lab Exercise 1
//
//  Created by Lyanne Carmel Sy on 2/23/23.
//

import UIKit

struct Restaurant{
    var imageName: String
    var name: String
}

class TableViewController: UITableViewController {
    private static let cellIdentifier = "something"
    
    var restaurants = [
        Restaurant(imageName: "jollibeeImage", name: "Jolibee"),
        Restaurant(imageName: "mcdoPic", name: "McDonald's"),
        Restaurant(imageName: "Wendys", name: "Wendy's"),
        Restaurant(imageName: "tacoBelll", name: "Taco Bell"),
        Restaurant(imageName: "kFc", name: "KFC"),
        Restaurant(imageName: "burgerKing", name: "Burger King"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: TableViewController.cellIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewController.cellIdentifier,
            for: indexPath
        ) as? TableViewCell
        else { return UITableViewCell() }
        
        let res = restaurants[indexPath.row]
        cell.resLabel.text = res.name
        cell.myImageView.image = UIImage(named: res.imageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToDetailsViewController(res: restaurants[indexPath.row])
    }
    
    func goToDetailsViewController(res: Restaurant) {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "detailsVCIdentifier") as? DetailsViewController else {return}

        controller.restaurant = res
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableiew: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
}

