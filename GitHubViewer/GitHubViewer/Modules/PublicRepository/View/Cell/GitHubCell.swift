//
//  GitHubCell.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 28.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Alamofire

class GitHubCell: UITableViewCell {
    
    // MARK: variables
    private lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    private lazy var idLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    var nameLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    var loginLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    var descriptionLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = 40
        avatarImage.layer.masksToBounds = true
    }
    
    // MARK: setUpView
    func setUpView() {
        addSubview(avatarImage)
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(loginLabel)
        addSubview(descriptionLabel)
        
        avatarImage.easy.layout(Top(15), Leading(15), Bottom(15), Height(80), Width(80))
        
        idLabel.easy.layout(Top(10), Trailing(), Leading(15).to(avatarImage,.trailing))
        nameLabel.easy.layout(Top(5).to(idLabel,.bottom), Trailing(), Leading(15).to(avatarImage,.trailing))
        loginLabel.easy.layout(Top(5).to(nameLabel,.bottom), Trailing(), Leading(15).to(avatarImage,.trailing))
        descriptionLabel.easy.layout(Top(5).to(loginLabel,.bottom), Trailing(10), Leading(15).to(avatarImage,.trailing))
        
    }
    
    // MARK: prepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
    }
    
    // MARK: setUp
    func setUp(newModel: Repo) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let photoUrl = URL(string: newModel.owner?.avatarurl ?? "") {
                let photo = photoUrl
                if let photoData = try? Data(contentsOf: photo) {
                    let data = photoData
                    let photoImage = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.avatarImage.image = photoImage
                    }
                }
            }
        }
        
        idLabel.text = "Id: \(newModel.id)"
        nameLabel.text = "Name: \(newModel.name ?? "")"
        loginLabel.text = "Login: \(newModel.owner?.login ?? "")"
        descriptionLabel.text = "Description: \(newModel.description ?? "")"
    }
}
