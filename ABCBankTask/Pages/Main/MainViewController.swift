//  MainViewController.swift
//  Created by Elgun Gafarzada on 20.02.26.

import UIKit
import Combine

class MainViewController: UIViewController {

    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()

    enum Section { case main }

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var carouselCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .darkGray
        control.pageIndicatorTintColor = .systemGray4
        control.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AppConstants.Strings.searchPlaceholder
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var searchContainerView: UIView = {
        let outerView = UIView()
        outerView.backgroundColor = .systemGroupedBackground
        outerView.translatesAutoresizingMaskIntoConstraints = false

        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBackground
        backgroundView.layer.cornerRadius = AppConstants.Layout.searchBarCornerRadius
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: AppConstants.Images.searchIcon))
        iconImageView.tintColor = .gray
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)

        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, searchTextField])
        horizontalStack.spacing = 8
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        outerView.addSubview(backgroundView)
        backgroundView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 6),
            backgroundView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -6),
            backgroundView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: AppConstants.Layout.horizontalPadding),
            backgroundView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -AppConstants.Layout.horizontalPadding),
            horizontalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            horizontalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            horizontalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
        ])
        return outerView
    }()

    private lazy var placesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var tableHeightConstraint: NSLayoutConstraint!

    private var searchBarOriginY: CGFloat = 0
    private var stickyOverlayView: UIView?
    private var isSearchBarSticky = false

    private lazy var diffableDataSource: UITableViewDiffableDataSource<Section, PlaceItem> = {
        UITableViewDiffableDataSource<Section, PlaceItem>(tableView: placesTableView) { [weak self] tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseID, for: indexPath) as! PlaceCell
            cell.configure(item: item, imageLoader: self?.viewModel.imageLoader ?? DefaultImageLoader())
            return cell
        }
    }()

    private lazy var floatingActionButton: UIButton = {
        let button = UIButton(type: .custom)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: AppConstants.Images.fabIcon, withConfiguration: symbolConfiguration), for: .normal)
        button.tintColor = .white
        button.backgroundColor = AppConstants.Colors.fabBackground
        button.layer.cornerRadius = AppConstants.Layout.fabCornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = .init(width: 0, height: 3)
        button.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupKeyboardDismissal()
        bindViewModel()
        Task {
            await viewModel.loadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshTableHeight()
        searchBarOriginY = searchContainerView.convert(.zero, to: mainScrollView).y
    }

    private func setupLayout() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentStackView)

        let carouselWrapper = UIView()
        carouselWrapper.translatesAutoresizingMaskIntoConstraints = false
        carouselWrapper.addSubview(carouselCollectionView)
        carouselWrapper.addSubview(pageControl)

        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: carouselWrapper.topAnchor, constant: 8),
            carouselCollectionView.leadingAnchor.constraint(equalTo: carouselWrapper.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: carouselWrapper.trailingAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: AppConstants.Layout.carouselHeight),
            pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 4),
            pageControl.centerXAnchor.constraint(equalTo: carouselWrapper.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: carouselWrapper.bottomAnchor, constant: -4),
        ])

        contentStackView.addArrangedSubview(carouselWrapper)
        contentStackView.addArrangedSubview(searchContainerView)
        contentStackView.addArrangedSubview(placesTableView)

        tableHeightConstraint = placesTableView.heightAnchor.constraint(equalToConstant: 500)
        tableHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
        ])

        view.addSubview(floatingActionButton)
        NSLayoutConstraint.activate([
            floatingActionButton.widthAnchor.constraint(equalToConstant: AppConstants.Layout.fabSize),
            floatingActionButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.fabSize),
            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        mainScrollView.addGestureRecognizer(tapGesture)
    }

    private func bindViewModel() {
        viewModel.$pages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pages in
                guard let self = self else { return }
                self.pageControl.numberOfPages = pages.count
                self.carouselCollectionView.reloadData()
                self.applySnapshot()
            }
            .store(in: &cancellables)

        viewModel.$currentPage
            .combineLatest(viewModel.$searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlaceItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.filteredItems)
        diffableDataSource.apply(snapshot, animatingDifferences: false)
        DispatchQueue.main.async { [weak self] in
            self?.refreshTableHeight()
        }
    }

    private func refreshTableHeight() {
        placesTableView.layoutIfNeeded()
        let height = placesTableView.contentSize.height
        if height > 0, tableHeightConstraint.constant != height {
            tableHeightConstraint.constant = height
        }
    }

    @objc private func pageControlTapped() {
        viewModel.currentPage = pageControl.currentPage
        let offsetX = CGFloat(viewModel.currentPage) * carouselCollectionView.bounds.width
        carouselCollectionView.setContentOffset(.init(x: offsetX, y: 0), animated: true)
    }

    @objc private func searchTextChanged() {
        viewModel.searchText = searchTextField.text ?? ""
    }

    @objc private func showStatistics() {
        let statsViewController = StatsViewController(pages: viewModel.pages)
        let navigationController = UINavigationController(rootViewController: statsViewController)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(navigationController, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseID, for: indexPath) as! CarouselCell
        cell.configure(imageName: viewModel.pages[indexPath.item].imageName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === carouselCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            guard pageIndex != viewModel.currentPage else { return }
            viewModel.currentPage = pageIndex
            pageControl.currentPage = pageIndex
        }
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }
}

extension MainViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === mainScrollView else { return }
        let offsetY = scrollView.contentOffset.y

        if searchBarOriginY > 0 {
            if offsetY >= searchBarOriginY && !isSearchBarSticky {
                isSearchBarSticky = true
                let overlay = buildStickySearchBar()
                overlay.frame = CGRect(
                    x: 0,
                    y: view.safeAreaInsets.top,
                    width: view.bounds.width,
                    height: searchContainerView.bounds.height
                )
                view.insertSubview(overlay, belowSubview: floatingActionButton)
                stickyOverlayView = overlay
                searchContainerView.alpha = 0
            } else if offsetY < searchBarOriginY && isSearchBarSticky {
                isSearchBarSticky = false
                stickyOverlayView?.removeFromSuperview()
                stickyOverlayView = nil
                searchContainerView.alpha = 1
            }
        }
    }

    private func buildStickySearchBar() -> UIView {
        let wrapperView = UIView()
        wrapperView.backgroundColor = .systemGroupedBackground

        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBackground
        backgroundView.layer.cornerRadius = AppConstants.Layout.searchBarCornerRadius
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: AppConstants.Images.searchIcon))
        iconImageView.tintColor = .gray
        let textLabel = UILabel()
        textLabel.text = viewModel.searchText.isEmpty ? AppConstants.Strings.searchPlaceholder : viewModel.searchText
        textLabel.textColor = viewModel.searchText.isEmpty ? .placeholderText : .label

        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, textLabel])
        horizontalStack.spacing = 8
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        wrapperView.addSubview(backgroundView)
        backgroundView.addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 6),
            backgroundView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -6),
            backgroundView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: AppConstants.Layout.horizontalPadding),
            backgroundView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -AppConstants.Layout.horizontalPadding),
            horizontalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            horizontalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            horizontalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusSearchField))
        wrapperView.addGestureRecognizer(tapGesture)
        return wrapperView
    }

    @objc private func focusSearchField() {
        mainScrollView.setContentOffset(.init(x: 0, y: searchBarOriginY), animated: false)
        searchTextField.becomeFirstResponder()
    }
}
