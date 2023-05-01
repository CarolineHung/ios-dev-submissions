//
//  TableViewController.swift
//  Hung_Project1
//
//  Created by student on 4/14/23.
//

import UIKit
import PokemonAPI

class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = NSLocalizedString("\(AppDelegate.POKENAME_KEY)\(indexPath.row+1)", comment: "The translated name of a pokemon")
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 151
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewPokemonDetails(indexPath.row + 1)
    }

    func viewPokemonDetails(_ index: Int) {
        let storyboard = UIStoryboard(name: "PokemonDetailsViewController", bundle: nil)
        guard let pokemonDetailsViewController = storyboard.instantiateViewController(withIdentifier: "Pokedex") as? PokemonDetailsViewController else { return }
        pokemonDetailsViewController.pokemonID = index
        navigationController?.pushViewController(pokemonDetailsViewController, animated: true)
    }
}

