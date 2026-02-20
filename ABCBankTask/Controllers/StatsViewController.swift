//  StatsViewController.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class StatsViewController: UITableViewController {
    private let pages: [GalleryPage]
    private var topChars: [(Character, Int)] = []

    init(pages: [GalleryPage]) {
        self.pages = pages
        super.init(style: .insetGrouped)
        self.topChars = computeTopChars()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        navigationItem.largeTitleDisplayMode = .never
    }

    private func computeTopChars() -> [(Character, Int)] {
        var freq: [Character: Int] = [:]
        for page in pages {
            for item in page.items {
                for ch in item.title.lowercased() {
                    if ch.isLetter { freq[ch, default: 0] += 1 }
                }
            }
        }
        return freq.sorted { $0.value > $1.value }
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Items per Category" : "Top Characters"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? pages.count : min(3, topChars.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            let p = pages[indexPath.row]
            cell.textLabel?.text = p.categoryName
            cell.detailTextLabel?.text = "\(p.items.count) items"
        } else {
            let (ch, cnt) = topChars[indexPath.row]
            cell.textLabel?.text = "\(String(ch).uppercased())"
            cell.textLabel?.font = .monospacedSystemFont(ofSize: 17, weight: .semibold)
            cell.detailTextLabel?.text = "\(cnt)"
        }
        return cell
    }
}
