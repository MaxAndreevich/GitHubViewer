//
//  GitHubViewController.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 29.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class GitHubViewController: UIViewController {
    
    // MARK: variables
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    private var presenter: GitHubPresenter?
    
    // MARK: init
    init(presenter: GitHubPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        
        applyStyle()
        setupView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(GitHubCell.self, forCellReuseIdentifier: "cellId")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        presenter?.fetchRepositories()
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: setupView
    func setupView() {
        view.addSubview(tableView)
        
        tableView.easy.layout(Top(), Trailing(), Leading(), Bottom())
    }
    
    // MARK: applyStyle
    func applyStyle() {
        navigationItem.title = "Public repositories"
    }
    
    // MARK: reload
    func reload(isRefresh: Bool = false, calculateIndexPathsToReload: [IndexPath] = []) {
        if isRefresh {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
        } else {
            tableView.insertRows(at: calculateIndexPathsToReload, with: .automatic)
        }
    }
    
    // MARK: refresh
    @objc func refresh() {
        presenter?.fetchRepositories(isRefresh: true)
    }
    
    // MARK: visibleIndexPathsToReload
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: extension GitHubViewController
extension GitHubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.totalCount ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? GitHubCell,
            let model = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell() }
        cell.setUp(newModel: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter?.selectViewData(at: indexPath)
    }
}

// MARK: extension GitHubViewController
extension GitHubViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        
        if (indexPaths.last?.row ?? 0) >= (presenter?.totalCount ?? 0) - 10 {
            presenter?.fetchRepositories()
        }
    }
}
