//
//  ViewController.swift
//  researchPurpose
//
//  Created by Suitmedia on 02/03/25.
//

import UIKit
import ReadiumShared
import ReadiumStreamer
import ReadiumNavigator
import ReadiumAdapterGCDWebServer
import SVProgressHUD

class ViewController: UIViewController {
    
    lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        return stackView
    }()

    lazy var httpClient: HTTPClient = DefaultHTTPClient()
    lazy var httpServer: HTTPServer = GCDHTTPServer(assetRetriever: assetRetriever)
    lazy var assetRetriever = AssetRetriever(
            httpClient: httpClient
        )
    lazy var publicationOpener = PublicationOpener(
        parser: DefaultPublicationParser(
            httpClient: httpClient,
            assetRetriever: assetRetriever,
            pdfFactory: DefaultPDFDocumentFactory()
        ),
        contentProtections: []
    )
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
    }
    
    func setupView() {
        let buttonCoba = UIButton(type: .system)
        buttonCoba.setTitle("Tap Me", for: .normal)
        buttonCoba.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
        buttonCoba.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonCobaWebView = UIButton(type: .system)
        buttonCobaWebView.setTitle("Tap Me (WebView)", for: .normal)
        buttonCobaWebView.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
                
        buttonCoba.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonCoba.heightAnchor.constraint(equalToConstant: 50),
            buttonCobaWebView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
        containerView.addArrangedSubview(buttonCoba)
        containerView.addArrangedSubview(buttonCobaWebView)
    }
    
    @objc func dismissNavigator() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonTapped() {
        OpenEPUB()
    }
    
    @objc func buttonTapped2() {
        let controller = epubWebviewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func OpenEPUB() {
        let urlepub = HTTPURL(string: "https://raw.githubusercontent.com/mickael-menu/test-publications/refs/heads/main/epub/childrens-literature.epub")
        Task {
            await MainActor.run {
                SVProgressHUD.show()
            }
            
            do {
                let asset = try await assetRetriever.retrieve(url: urlepub!).get()
                let publication = try await publicationOpener.open(asset: asset, allowUserInteraction: true).get()
                
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    
                    let controller = CustomEPUBViewController(publication: publication, httpServer: self.httpServer, controller: self)
                    controller.presentEPUBNavigator()
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    print("Failed to retrieve the asset: \(error)")
                }
            }
        }
        
    }

}

#if DEBUG
extension UIViewController {
    @objc func injected() {
        viewDidLoad()
    }
}
#endif
