//
//  CustomEpubViewController.swift
//  researchPurpose
//
//  Created by Suitmedia on 04/03/25.
//

import ReadiumNavigator
import ReadiumShared
import ReadiumStreamer
import ReadiumAdapterGCDWebServer
import UIKit
import Foundation
import WebKit

class CustomEPUBViewController: UIViewController {
    
    private var navigator: EPUBNavigatorViewController!
    private var footerView: UIView!
    private var progressLabel: UILabel!
    
    var publication: Publication
    var httpServer: HTTPServer
    var controller : UIViewController
    
    init(publication: Publication, httpServer: HTTPServer, controller: UIViewController) {
        self.publication = publication
        self.httpServer = httpServer
        self.controller = controller
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentEPUBNavigator() {
        do {
            navigator = try EPUBNavigatorViewController(
                publication: self.publication,
                initialLocation: nil,
                httpServer: self.httpServer
            )
            navigator.delegate = self
            
            let navigationController = UINavigationController(rootViewController: navigator)
            
            // Kustomisasi Navigation Bar
            let navBar = navigationController.navigationBar
            navBar.isTranslucent = false
            navBar.backgroundColor = .white
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = .black
            
            navigationController.view.backgroundColor = .white
            
            navigator.navigationItem.title = self.publication.metadata.title ?? ""
            
            navigator.navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(dismissNavigator)
            )
            
            
            // Setup footer
            setupFooterView()
            
            navigationController.modalPresentationStyle = .fullScreen
            controller.present(navigationController, animated: true, completion: nil)
            
        } catch {
            print("Gagal inisialisasi EPUBNavigatorViewController: \(error)")
         
        }
    }
    
    private func setupFooterView() {
        footerView = UIView()
        footerView.backgroundColor = .lightGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        navigator.view.addSubview(footerView)
        
        progressLabel = UILabel()
        progressLabel.textAlignment = .center
        progressLabel.textColor = .black
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.text = "Total Pages"
        footerView.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: navigator.view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: navigator.view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: navigator.view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 44),
            
            progressLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
    }
        
    private func updateProgress() {

    }
    
    @objc func dismissNavigator() {
        dismiss(animated: true, completion: nil)
    }
}

extension CustomEPUBViewController: NavigatorDelegate,EPUBNavigatorDelegate {
    
    func navigator(_ navigator: Navigator, locationDidChange locator: Locator) {
        updateProgress()
    }
    
    func navigator(_ navigator: ReadiumNavigator.EPUBNavigatorViewController, setupUserScripts userContentController: WKUserContentController) {
        
    }
    
    func navigator(_ navigator: any ReadiumNavigator.Navigator, didFailToLoadResourceAt href: ReadiumShared.RelativeURL, withError error: ReadiumShared.ReadError) {
        
    }
    
    func navigator(_ navigator: any ReadiumNavigator.Navigator, presentError error: ReadiumNavigator.NavigatorError) {
        
    }
    
}
