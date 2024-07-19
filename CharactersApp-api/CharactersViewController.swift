//
//  ViewController.swift
//  CharactersApp-api
//
//  Created by Alex  on 17.07.2024.
//

import UIKit
// 353x96 - ячейка, отступы 20х20х177, между яч. 4
// стек в ячейке: слева15, справа18, верх-низ16
// стек titles возле картинки: слева16, справа110, между title 6px

class CharactersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
	
	var characters: [Character] = []
	var currentPage = 1
	var isLoading = false
	//private var filterCharacters = [Character]()
	private let activityIndicator = UIActivityIndicatorView(style: .large)
	
	private let tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupViews()
		loadCharacters(page: currentPage)
	}

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Rick & Morty Characters"
		label.textColor = .white
		label.font = UIFont(name: "IBMPlexSans-SemiBold", size: 24)
		return label
	}()
	
	private lazy var searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Search"
		searchBar.delegate = self
		searchBar.searchBarStyle = .minimal
		searchBar.barTintColor = .black // цвета фона для поля ввода и всей поисковой строки
		searchBar.tintColor = .white // Цвет текста и иконок
		
		// Настройка текстового поля внутри UISearchBar
		if let textField = searchBar.value(forKey: "searchField") as? UITextField {
			textField.textColor = .white // Цвет текста
			textField.backgroundColor = .black // Цвет фона текстового поля
			textField.layer.cornerRadius = 10
			textField.layer.borderWidth = 1
			textField.layer.borderColor = UIColor.darkGray.cgColor // Цвет обводки
			textField.clipsToBounds = true // Чтобы углы были закругленными
		}
		
		return searchBar
	}()
	
	private lazy var filterButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(named: "Filters"), for: .normal)
		button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
		return button
	}()
	
	@objc func filterButtonTapped() {
		let filterVC = FiltersViewController()
		filterVC.modalPresentationStyle = .pageSheet
		
		if let sheet = filterVC.sheetPresentationController {
			sheet.detents = [UISheetPresentationController.Detent.custom { _ in 312 }] // высота окна
			sheet.preferredCornerRadius = 16 // Уголок для скругления
		}
		present(filterVC, animated: true, completion: nil)
	}
	
	private lazy var stackViewSearch: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [searchBar, filterButton])
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 16 // Расстояние между
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return characters.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as? CharacterTableViewCell else {
			return UITableViewCell()
		}
		let character = characters[indexPath.row]
		cell.configure(with: character)
		cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//let character = characters[indexPath.row]
		let detailVC = CharacterDetailsViewController() // !
		navigationController?.pushViewController(detailVC, animated: true)
	} 
	
	
	func loadCharacters(page: Int) {
		isLoading = true
		NetworkManager.shared.fetchCharacters(page: page) { [weak self] result in
			guard let self = self else { return }
			self.isLoading = false
			switch result {
			case .success(let response):
				self.characters.append(contentsOf: response.results)
				self.currentPage += 1
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(let error):
				print("Error fetching characters: \(error)")
			}
		}
	
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height * 2 {
			if !isLoading {
				loadCharacters(page: currentPage)
			}
		}
	}
	
	func setupViews() {
		view.addSubview(titleLabel)
		view.addSubview(stackViewSearch)
		view.addSubview(tableView)
		view.addSubview(activityIndicator)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		stackViewSearch.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
		tableView.separatorStyle = .none
		tableView.backgroundColor = .black 
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackViewSearch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			stackViewSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stackViewSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			tableView.topAnchor.constraint(equalTo: stackViewSearch.bottomAnchor, constant: 24),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50), 
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor) 
		])
	}
}


extension CharactersViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
	}

}


