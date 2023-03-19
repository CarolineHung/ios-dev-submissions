//
//  TableViewController.swift
//  Exercise
//
//  Created by student on 3/1/23.
//

import UIKit

class TableViewController: UITableViewController {
    var searchResponse: SearchResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAPICall { searchResponse in
            self.searchResponse = searchResponse
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResponse?.images[indexPath.row].title
        if let res = searchResponse, let url = URL(string: res.images[indexPath.row].original) {
            cell.imageView?.load(url: url)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.images.count ?? 0
    }
    
    func makeAPICall(completion: @escaping (SearchResponse?) -> Void) {
        print("Start API Call")
        let domain = "https://serpapi.com/search.json"
        let apiKey = "02c14fe79e481822faadffa800e0880af3102d7d1cb843ac2514c4d16421a2fa"
        let query = "cat"
        
        guard let url = URL(string: "\(domain)?api_key=\(apiKey)&tbm=isch&q=\(query)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var searchResponse: SearchResponse?
            defer {completion(searchResponse)}
            print("Done with call")
            if let error = error {
                print("Error with API call: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response: \(String(describing: response))")
                return
            }
            if let data = data,
               let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
                print("success")
                searchResponse = response
            } else {
                print("Something is wrong with decoding, probably.")
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

struct SearchResponse: Codable {
    let images: [SerpImage]

    enum CodingKeys: String, CodingKey {
        case images = "images_results"
    }
}

struct SerpImage: Codable {
    let title: String
    let source: String
    let original: String
}
