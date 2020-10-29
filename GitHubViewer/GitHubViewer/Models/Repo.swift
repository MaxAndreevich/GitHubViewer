//
//  GitHubModel.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 28.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    var id: Int
    var owner: Owner?
    var name: String?
    var description: String?
    var htmlUrl: String?
    
    
    enum CodingKeys: String,CodingKey {
        case id
        case owner
        case name
        case description
        case htmlUrl = "html_url"
    }
}
