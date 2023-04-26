//
//  ViewController.swift
//  Lab 3
//
//  Created by Luis Ligunas on 4/26/23.
//

import UIKit

class MovieListViewController: UITableViewController {

	private let queryStrings = [
		"Harry Potter",
		"Star Wars",
		"Pokemon",
		"Superman",
		"Batman"
	]

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		title = NSLocalizedString("navigation-title", comment: "")
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return queryStrings.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = queryStrings[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard let searchMoviesListViewController = storyboard?.instantiateViewController(withIdentifier: "searchMoviesListID") as? SearchMoviesListViewController else { return }
        searchMoviesListViewController.queryString = queryStrings[indexPath.row]
		navigationController?.pushViewController(searchMoviesListViewController, animated: true)
	}
}

