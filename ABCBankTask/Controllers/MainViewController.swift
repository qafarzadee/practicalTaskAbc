//  MainViewController.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit

class MainViewController: UIViewController {

    private let pages = galleryPages
    private var currentPage = 0
    private var searchQuery = ""

    private var filteredItems: [PlaceItem] {
        let items = pages[currentPage].items
        if searchQuery.isEmpty { return items }
        let q = searchQuery.lowercased()
        return items.filter { $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q) }
    }

    // MARK: - Views

    private lazy var mainScroll: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .onDrag
        return sv
    }()

    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private lazy var pageCtrl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .darkGray
        pc.pageIndicatorTintColor = .systemGray4
        pc.addTarget(self, action: #selector(pageDotTapped), for: .valueChanged)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private lazy var searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.borderStyle = .none
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        tf.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return tf
    }()

    private lazy var searchContainer: UIView = {
        let outer = UIView()
        outer.backgroundColor = UIColor.systemGroupedBackground
        outer.translatesAutoresizingMaskIntoConstraints = false

        let bg = UIView()
        bg.backgroundColor = .systemBackground
        bg.layer.cornerRadius = 10
        bg.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let hStack = UIStackView(arrangedSubviews: [icon, searchField])
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        outer.addSubview(bg)
        bg.addSubview(hStack)

        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: outer.topAnchor, constant: 6),
            bg.bottomAnchor.constraint(equalTo: outer.bottomAnchor, constant: -6),
            bg.leadingAnchor.constraint(equalTo: outer.leadingAnchor, constant: 16),
            bg.trailingAnchor.constraint(equalTo: outer.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: bg.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: bg.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -10),
        ])
        return outer
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseID)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private var tableHeight: NSLayoutConstraint!

    private var searchBarOriginY: CGFloat = 0
    private var stickyOverlay: UIView?
    private var isSticky = false

    private lazy var fabButton: UIButton = {
        let btn = UIButton(type: .custom)
        let cfg = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        btn.setImage(UIImage(systemName: "ellipsis", withConfiguration: cfg), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 0.29, green: 0.56, blue: 0.85, alpha: 1)
        btn.layer.cornerRadius = 28
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 5
        btn.layer.shadowOffset = .init(width: 0, height: 3)
        btn.addTarget(self, action: #selector(showStats), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        buildUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshTableHeight()
        searchBarOriginY = searchContainer.convert(.zero, to: mainScroll).y
    }

    // MARK: - Layout

    private func buildUI() {
        view.addSubview(mainScroll)
        mainScroll.addSubview(stackView)

        let carouselWrap = UIView()
        carouselWrap.translatesAutoresizingMaskIntoConstraints = false
        carouselWrap.addSubview(carousel)
        carouselWrap.addSubview(pageCtrl)

        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: carouselWrap.topAnchor, constant: 8),
            carousel.leadingAnchor.constraint(equalTo: carouselWrap.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: carouselWrap.trailingAnchor),
            carousel.heightAnchor.constraint(equalToConstant: 220),
            pageCtrl.topAnchor.constraint(equalTo: carousel.bottomAnchor, constant: 4),
            pageCtrl.centerXAnchor.constraint(equalTo: carouselWrap.centerXAnchor),
            pageCtrl.bottomAnchor.constraint(equalTo: carouselWrap.bottomAnchor, constant: -4),
        ])

        stackView.addArrangedSubview(carouselWrap)
        stackView.addArrangedSubview(searchContainer)
        stackView.addArrangedSubview(tableView)

        tableHeight = tableView.heightAnchor.constraint(equalToConstant: 500)
        tableHeight.isActive = true

        NSLayoutConstraint.activate([
            mainScroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: mainScroll.widthAnchor),
        ])

        view.addSubview(fabButton)
        NSLayoutConstraint.activate([
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56),
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    private func refreshTableHeight() {
        tableView.layoutIfNeeded()
        let h = tableView.contentSize.height
        if h > 0, tableHeight.constant != h { tableHeight.constant = h }
    }

    // MARK: - Actions

    @objc private func pageDotTapped() {
        currentPage = pageCtrl.currentPage
        let x = CGFloat(currentPage) * carousel.bounds.width
        carousel.setContentOffset(.init(x: x, y: 0), animated: true)
        reloadItems()
    }

    @objc private func searchTextChanged() {
        searchQuery = searchField.text ?? ""
        reloadItems()
    }

    @objc private func showStats() {
        let vc = StatsViewController(pages: pages)
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(nav, animated: true)
    }

    private func reloadItems() {
        tableView.reloadData()
        DispatchQueue.main.async { [weak self] in self?.refreshTableHeight() }
    }
}

// MARK: - Carousel datasource

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { pages.count }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseID, for: indexPath) as! CarouselCell
        cell.configure(imageName: pages[indexPath.item].imageName)
        return cell
    }

    func collectionView(_ cv: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: cv.bounds.width, height: cv.bounds.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === carousel {
            let pg = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            guard pg != currentPage else { return }
            currentPage = pg
            pageCtrl.currentPage = pg
            reloadItems()
        }
    }
}

// MARK: - Table datasource

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int { filteredItems.count }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: PlaceCell.reuseID, for: indexPath) as! PlaceCell
        cell.configure(item: filteredItems[indexPath.row], imageName: pages[currentPage].imageName)
        return cell
    }

    func tableView(_ tv: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 76 }
}

// MARK: - Sticky search

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === mainScroll else { return }
        let y = scrollView.contentOffset.y

        if searchBarOriginY > 0 {
            if y >= searchBarOriginY && !isSticky {
                isSticky = true
                let overlay = buildStickyBar()
                overlay.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, height: searchContainer.bounds.height)
                view.insertSubview(overlay, belowSubview: fabButton)
                stickyOverlay = overlay
                searchContainer.alpha = 0
            } else if y < searchBarOriginY && isSticky {
                isSticky = false
                stickyOverlay?.removeFromSuperview()
                stickyOverlay = nil
                searchContainer.alpha = 1
            }
        }
    }

    private func buildStickyBar() -> UIView {
        let wrap = UIView()
        wrap.backgroundColor = .systemGroupedBackground

        let bg = UIView()
        bg.backgroundColor = .systemBackground
        bg.layer.cornerRadius = 10
        bg.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        let lbl = UILabel()
        lbl.text = searchQuery.isEmpty ? "Search" : searchQuery
        lbl.textColor = searchQuery.isEmpty ? .placeholderText : .label

        let hStack = UIStackView(arrangedSubviews: [icon, lbl])
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false

        wrap.addSubview(bg)
        bg.addSubview(hStack)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: wrap.topAnchor, constant: 6),
            bg.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -6),
            bg.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: 16),
            bg.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: bg.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: bg.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -10),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(focusSearch))
        wrap.addGestureRecognizer(tap)
        return wrap
    }

    @objc private func focusSearch() {
        mainScroll.setContentOffset(.init(x: 0, y: searchBarOriginY), animated: false)
        searchField.becomeFirstResponder()
    }
}
