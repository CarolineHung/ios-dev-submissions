//
//  SearchMoviesListViewController.swift
//  Lab 3
//
//  Created by Luis Ligunas on 4/26/23.
//

import UIKit
import Foundation

class SearchMoviesListViewController: UITableViewController {

	var queryString = ""
	private var movieResults = [Movie]()
	private let movieService = MovieService()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		title = "Search"

		movieService.searchMovies(query: queryString) { [weak self] response in
			guard let self = self,
				  let response = response
			else { return }

			self.movieResults = response.search
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movieResults.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = movieResults[indexPath.row].title
		return cell
	}
}

