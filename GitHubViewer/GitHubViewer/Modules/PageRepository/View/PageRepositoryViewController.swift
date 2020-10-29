//
//  PageRepositoryViewController.swift
//  GitHubViewer
//
//  Created by Максим Разумов on 28.10.2020.
//  Copyright © 2020 Максим Разумов. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import WebKit

class PageRepositoryViewController: UIViewController {
    
    // MARK: variables
    var page = WKWebView()
    var presenter: PageRepositoryPresenter?
    
    // MARK: init
    init(presenter: PageRepositoryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shared))
        
        if let url =  URL(string: presenter?.url ?? "") {
            page.load(URLRequest(url: url))
            page.allowsBackForwardNavigationGestures = true
        }
    }
    
    // MARK: setupView
    func setupView() {
        view.addSubview(page)
        page.easy.layout(Top(), Trailing(), Leading(), Bottom())
    }
    
    // MARK: shared
    @objc func shared() {
        
        let activityVC = UIActivityViewController(activityItems: [presenter?.url ?? ""], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC,animated: true, completion: nil)
    }
}
