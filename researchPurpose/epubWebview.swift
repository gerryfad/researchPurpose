//
//  epubWebview.swift
//  researchPurpose
//
//  Created by Suitmedia on 04/03/25.
//

import UIKit
import WebKit
import SVProgressHUD

class epubWebviewController: UIViewController {
    
    private var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        self.view.addSubview(stackView)
        NSLayoutConstraint.pinToSafeArea(stackView, toView: self.view)
        return stackView
    }()
    
    lazy var navBar: Navbar = {
        let view = Navbar(controller: self, useMargin: true)
        return view
    }()
    
    lazy var contentView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    var urlLink: URL = URL(string: "https://playground.readium.org/read?book=https%3A%2F%2Fpublication-server.readium.org%2FQmVsbGFPcmlnaW5hbDMuZXB1Yg")!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupComponent()
        activityIndicator.startAnimating()
    }
    
    func setupComponent() {
        containerView.addArrangedSubview(navBar)
        containerView.addArrangedSubview(contentView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.navigationDelegate = self
        contentView.load(URLRequest(url: urlLink))
    }
    
}

extension epubWebviewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error")
        activityIndicator.stopAnimating()
    }
}

