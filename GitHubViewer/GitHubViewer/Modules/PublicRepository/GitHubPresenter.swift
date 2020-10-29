//
//  GitHubPresenter.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 28.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation
import Alamofire

class GitHubPresenter {
    
    // MARK: variables
    weak var gitHubViewController: GitHubViewController?
    
    private var repositories: [Repo] = []
    private var total = 0
    private var isFetchInProgress = false

    var totalCount: Int {
      return total
    }
    
    // MARK: getModelAtIndex
    func getModelAtIndex(indexPath: IndexPath) -> Repo {
        return repositories[indexPath.row]
    }
    
    // MARK: selectViewData
    func selectViewData(at indexPath: IndexPath) {
        showProfile(url: repositories[indexPath.row].htmlUrl ?? "")
    }
    
    // MARK: fetchRepositories
    func fetchRepositories(isRefresh: Bool = false) {
    
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        let url = "https://api.github.com/repositories"
        let params = ["since" : isRefresh ? 0 : repositories.last?.id ?? 0]
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            AF.request(url, method: .get, parameters: params).validate()
                .responseDecodable(of: [Repo].self) { [weak self] (response) in
                    guard let resp = response.value, let self = self else {return}
                    
                    self.isFetchInProgress = false
                    self.repositories.append(contentsOf: resp)
                    self.total += resp.count
                    
                    DispatchQueue.main.async {
                        self.gitHubViewController?.reload(isRefresh: isRefresh,
                                                    calculateIndexPathsToReload: self.calculateIndexPathsToReload(from: resp))
                    }
            }
        }
    }
    
    // MARK: calculateIndexPathsToReload
    private func calculateIndexPathsToReload(from newRepositories: [Repo]) -> [IndexPath] {
       let startIndex = repositories.count - newRepositories.count
       let endIndex = startIndex + newRepositories.count
       return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
     }
}

// MARK: extension GitHubPresenter
extension GitHubPresenter {
    
    private func showProfile(url: String) {
        
        let pageRepositoryPresenter = PageRepositoryPresenter(url: url)
        let pageRepositoryViewController = PageRepositoryViewController(presenter: pageRepositoryPresenter)
        pageRepositoryPresenter.viewController = pageRepositoryViewController
        
        self.gitHubViewController?.navigationController?.pushViewController(pageRepositoryViewController, animated: true)
    }
}
