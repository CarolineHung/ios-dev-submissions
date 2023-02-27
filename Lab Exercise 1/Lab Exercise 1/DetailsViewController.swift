//
//  DetailsViewController.swift
//  Lab Exercise 1
//
//  Created by Lyanne Carmel Sy on 2/23/23.
//

import UIKit

class DetailsViewController: UIViewController {
    var restaurant: Restaurant?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel?.text = restaurant?.name ?? "No Restaurant"
        image?.image = UIImage(named: restaurant?.imageName ?? "AppIcon")
    }
}

