//
//  Owner.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 29.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation

struct Owner: Decodable {
    var login: String?
    var avatarurl: String?
    
    enum CodingKeys: String, CodingKey {
        
        case login
        case avatarurl = "avatar_url"
    }
}
