//
//  CharacterTableViewCell.swift
//  CharactersApp-api
//
//  Created by Alex  on 19.07.2024.
//

import UIKit


class CharacterTableViewCell: UITableViewCell {

	private let characterImageView = UIImageView()
	private let nameLabel = UILabel()
	private let statusLabel = UILabel()
	private let speciesLabel = UILabel()
	private let genderLabel = UILabel()
	private let statusSpacesView = UIStackView()
	
	private let backgroundContainerView = UIView()
	private let labelStackView = UIStackView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		addSubviews()
		setupStyle()
		setupConstraints()

		backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
		characterImageView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func addSubviews() {
		contentView.addSubview(backgroundContainerView)
		backgroundContainerView.addSubview(characterImageView)
		backgroundContainerView.addSubview(labelStackView)
		statusSpacesView.addArrangedSubview(statusLabel)
		statusSpacesView.addArrangedSubview(speciesLabel)
		
		labelStackView.addArrangedSubview(nameLabel)
		labelStackView.addArrangedSubview(statusSpacesView)
		labelStackView.addArrangedSubview(genderLabel)
		
	}
	
	private func setupStyle() {
		nameLabel.textColor = .white
		statusLabel.textColor = .white
		speciesLabel.textColor = .white
		genderLabel.textColor = .white
		
		nameLabel.font = UIFont(name: "IBMPlexSans-Medium", size: 18)
		statusLabel.font = UIFont(name: "IBMPlexSans-Regular", size: 12)
		speciesLabel.font = UIFont(name: "IBMPlexSans-Regular", size: 12)
		genderLabel.font = UIFont(name: "IBMPlexSans-Regular", size: 12)
		
		backgroundContainerView.backgroundColor = .darkGray
		backgroundContainerView.layer.cornerRadius = 10
		
		labelStackView.axis = .vertical
		labelStackView.alignment = .leading
		labelStackView.spacing = 6
		labelStackView.translatesAutoresizingMaskIntoConstraints = false
		
		characterImageView.backgroundColor = .red
		//labelStackView.backgroundColor = .black
		
		backgroundColor = .black
	}
	
	func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
		
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			characterImageView.widthAnchor.constraint(equalToConstant: 84),
			characterImageView.heightAnchor.constraint(equalToConstant: 64), 
			characterImageView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 16), 
			characterImageView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 16),
			
			labelStackView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 16),
			labelStackView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 16),
			labelStackView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -16),
			labelStackView.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -16),

		])
		
		NSLayoutConstraint.activate([
			backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
			backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
			backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			backgroundContainerView.heightAnchor.constraint(equalToConstant: 96),
		])
	}
	
	func configure(with character: Character) {
		nameLabel.text = character.name
		statusLabel.text = character.status
		speciesLabel.text = character.species
		genderLabel.text = character.gender
		let url = URL(string: character.image)!
		getData(from: url) { data, urlres, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async { [weak self] in
				self?.characterImageView.image = UIImage(data: data)
			}
		}
		
		
//		if let url = URL(string: character.image) {
//			// кэш
//		}
	}
}


