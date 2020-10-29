//
//  PageRepositoryPresenter.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 28.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation

class PageRepositoryPresenter {
    
    // MARK: variables
    weak var viewController: PageRepositoryViewController?
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
}
