//
//  PokemonDetailsViewController.swift
//  Hung_Project1
//
//  Created by student on 4/19/23.
//

import UIKit
import PokemonAPI

class PokemonDetailsViewController: UIViewController {
    var pokemonID = 0
    var pokemon: Pokemon?
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("\(AppDelegate.POKENAME_KEY)\(pokemonID)", comment: "The translated name of the pokemon")
        Label?.text = self.title
        
        makeAPICall { data in
            self.pokemon = data
            
            var image: UIImage?
            
            if let data = data,
               let url = URL(string: data.sprite),
               let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
            
            DispatchQueue.main.async { [self] in
                guard let data = self.pokemon else {
                    let alertController = UIAlertController(
                        title: "An error occured",
                        message: "Failed to load Pokemon. Please check your internet connection and try again.",
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default))
                    navigationController?.popViewController(animated: true)
                    present(alertController, animated: true, completion: nil)
                    return
                }
                
                
                if image != nil { imageView?.image = image }
                
                let type1 = NSLocalizedString(("\(AppDelegate.POKETYPE_KEY)\(data.types[0])"), comment: "Translated pokemon type 1")

                //Types
                if data.types.count == 1 {
                    createLabel(
                        text: type1,
                        bounds: CGRect(x: 140, y: 350, width: 100, height: 30),
                        backgroundColor: getTypeColor(data.types[0])
                    )
                } else if data.types.count == 2 {
                    createLabel(
                        text: type1,
                        bounds: CGRect(x: 85, y: 350, width: 100, height: 30),
                        backgroundColor: getTypeColor(data.types[0])
                    )
                    
                    let type2 = NSLocalizedString(("\(AppDelegate.POKETYPE_KEY)\(data.types[1])"), comment: "Translated pokemon type 2")
                    
                    createLabel(
                        text: type2,
                        bounds: CGRect(x: 195, y: 350, width: 100, height: 30),
                        backgroundColor: getTypeColor(data.types[1])
                    )
                }
            }
        }
    }
    
    private func createLabel(text: String, bounds: CGRect, backgroundColor: UIColor) {
        let label = UILabel()
        label.frame = bounds
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6.0
        label.textAlignment = .center
        label.textColor = .white
        label.text = text
        label.backgroundColor = backgroundColor
        view.addSubview(label)
    }

    private func getTypeColor (_ type: String?) -> UIColor {
        var c = ""

        if (traitCollection.userInterfaceStyle == .dark) {
            switch type {
                case "bug":       c = "#6D7815"
                case "dark":      c = "#49392F"
                case "dragon":    c = "#7038F8"
                case "electric":  c = "#A1871F"
                case "fairy":     c = "#9B6470"
                case "fighting":  c = "#7D1F1A"
                case "fire":      c = "#9C531F"
                case "flying":    c = "#6D5E9C"
                case "ghost":     c = "#493963"
                case "grass":     c = "#4E8234"
                case "ground":    c = "#927D44"
                case "ice":       c = "#638D8D"
                case "normal":    c = "#6D6D4E"
                case "poison":    c = "#682A68"
                case "psychic":   c = "#A13959"
                case "rock":      c = "#786824"
                case "steel":     c = "#787887"
                case "water":     c = "#445E9C"
                default:          c = ""
           }
        } else {
            switch(type) {
                case "bug":       c = "#A8B820"
                case "dark":      c = "#705848"
                case "dragon":    c = "#7038F8"
                case "electric":  c = "#F8D030"
                case "fairy":     c = "#EE99AC"
                case "fighting":  c = "#C03028"
                case "fire":      c = "#F08030"
                case "flying":    c = "#A890F0"
                case "ghost":     c = "#705898"
                case "grass":     c = "#78C850"
                case "ground":    c = "#E0C068"
                case "ice":       c = "#98D8D8"
                case "normal":    c = "#A8A878"
                case "poison":    c = "#A040A0"
                case "psychic":   c = "#F85888"
                case "rock":      c = "#B8A038"
                case "steel":     c = "#B8A038"
                case "water":     c = "#6890F0"
                default:          c = ""
            }
        }

        return UIColor.parseHex(hex: c) ?? .lightGray
    }
        
    func makeAPICall(completion: @escaping (Pokemon?) -> Void) {
        let domain = "https://pokeapi.co/api/v2/pokemon/"

        guard let url = URL(string: "\(domain)\(pokemonID)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var searchResponse: Pokemon?
            defer {completion(searchResponse)}
            if let error = error {
                print("Error with API call: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response (\(String(describing: response))")
                return
            }

            if let data = data,
               let response = try? JSONDecoder().decode(Pokemon.self, from: data)
            {
                searchResponse = response
            }
        }
        
        task.resume()
    }
}

struct Pokemon: Codable {
    let sprite: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case sprite = "sprites"
        case types
    }

    struct TypeSlot: Codable {
        let type: PokeType
        
        struct PokeType: Codable {
            let name: String
        }
    }

    struct Sprite: Codable {
        let front: String
        enum CodingKeys: String, CodingKey{
            case front = "front_default"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sprite = try container.decode(Sprite.self, forKey: .sprite).front
        types = try container.decode([TypeSlot].self, forKey: .types).map { $0.type.name }
    }
}
