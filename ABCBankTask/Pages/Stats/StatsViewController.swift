//  StatsViewController.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class StatsViewController: UITableViewController {
    private let pages: [GalleryPage]
    private var topCharacters: [(Character, Int)] = []

    init(pages: [GalleryPage]) {
        self.pages = pages
        super.init(style: .insetGrouped)
        self.topCharacters = computeTopCharacters()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppConstants.Strings.statisticsTitle
        navigationItem.largeTitleDisplayMode = .never
    }

    private func computeTopCharacters() -> [(Character, Int)] {
        let frequency = pages
            .flatMap(\.items)
            .flatMap { $0.title.lowercased() }
            .filter(\.isLetter)
            .reduce(into: [Character: Int]()) { result, character in
                result[character, default: 0] += 1
            }
        return frequency.sorted { $0.value > $1.value }
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? AppConstants.Strings.itemsPerCategory : AppConstants.Strings.topCharacters
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? pages.count : min(3, topCharacters.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let page = pages[indexPath.row]
            cell.textLabel?.text = page.categoryName
            cell.detailTextLabel?.text = "\(page.items.count) \(AppConstants.Strings.itemsSuffix)"
        } else {
            let (character, count) = topCharacters[indexPath.row]
            cell.textLabel?.text = "\(String(character).uppercased())"
            cell.textLabel?.font = .monospacedSystemFont(ofSize: 17, weight: .semibold)
            cell.detailTextLabel?.text = "\(count)"
        }
        return cell
    }
}
